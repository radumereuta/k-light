// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil; // in main kil package to avoid access restriction violations

import org.kframework.frontend.kil.loader.Context;
import org.kframework.frontend.kil.visitors.AbstractTransformer;
import org.kframework.frontend.kil.visitors.BasicVisitor;
import org.kframework.frontend.kil.visitors.CopyOnWriteTransformer;
import org.kframework.frontend.kil.visitors.Visitor;

import java.util.*;

/**
 * A super-visitor class designed to support all use cases for visiting K and KAST syntax.
 *
 * To use as a visitor, override this class and implement the methods you want to perform
 * an action on. To apply to a term, use {@link #visitNode(ASTNode)} or
 * {@link #visitNode(ASTNode, Object)}.
 *
 * To use this class as a transformer, see {@link AbstractTransformer}.
 *
 * The algorithm used to implement each of the visitors for each of the different visit methods
 * is as follows:
 *
 * <ol>
 * <li>Check if we are caching terms and we have seen the term already in the {@link #cache}.
 * If yes, return the result of visiting that term previously.</li>
 * <li>Check if we are visiting child terms. If not, call the {@code visit} method for the superclass,
 * and return the result. Otherwise, proceed to next step.</li>
 * <li>Visit each child term, and collect the result of calling {@link #processChildTerm(ASTNode, Object)}
 * on each one. If it returns null on the element of a collection or the key or value of a
 * map, delete the entry.</li>
 * <li>Call {@link #changed(ASTNode, ASTNode)} on each child term, and if any are modified, replace
 * them in the tree. If {@link #copy(ASTNode)} returns {@code true} or the node is immutable,
 * also clone the node itself.</li>
 * <li>Call {@code visit} for the superclass of the term being visited. Once you reach
 * {@link #visit(ASTNode, Object)}, put the result of visiting the object in the cache
 * (if the cache is enabled), and return the result of calling {@link #defaultReturnValue(ASTNode, Object)}
 * on the node.</li>
 *
 * For details on the implementation of this algorithm, which makes heavy use of generics in order to avoid
 * repeating boilerplate code, refer to the section of the code with the heading "Generic Machinery".
 *
 * @author dwightguth
 *
 * @param <P> The parameter to pass to each visit method. Use {@link Void} if not needed, and call
 * {@link #visitNode(ASTNode)}.
 * @param <R> The parameter to return from each visit method. Use {@link Void} if not needed, and
 * return {@code null}.
 */
public abstract class AbstractVisitor<P, R, E extends Throwable> implements Visitor<P, R, E> {
    protected final Context context;
    private Module currentModule;
    private Definition currentDefinition;
    final String name;

    protected IdentityHashMap<ASTNode, R> cache = new IdentityHashMap<>();

    public AbstractVisitor(Context context) {
        this(null, context, null, null);
    }

    public AbstractVisitor(String name, Context context) {
        this(name, context, null, null);
    }

    public AbstractVisitor(String name, Context context,
                           Definition currentDefinition, Module currentModule) {
        this.context = context;
        this.currentDefinition = currentDefinition;
        this.currentModule = currentModule;
        this.name = name == null ? this.getClass().toString() : name;
    }

    protected final Definition getCurrentDefinition() {
        return currentDefinition;
    }

    protected final Module getCurrentModule() {
        return currentModule;
    }

    @Override
    public R visitNode(ASTNode node, P p) throws E {
        if (cache() && cache.containsKey(node)) {
            return cache.get(node);
        }
        return node.accept(this, p);
    }

    @Override
    public R visitNode(ASTNode node) throws E {
        if (cache() && cache.containsKey(node)) {
            return cache.get(node);
        }
        return node.accept(this, null);
    }

    // GENERIC MACHINERY

    /**
     * Generically visit a single child of an ASTNode. A node implements Interfaces.Parent
     * if it has one or more multiplicity 1 (i.e. not a collection or map) child nodes.
     */
    private <Child extends ASTNode, EnumType extends Enum<?>,
        Parent extends ASTNode & Interfaces.Parent<Child, EnumType>>
            Parent genericVisitChild(
                Parent node, P p,
                ChildASTNodeCopier<Child, EnumType, Parent> copier, EnumType type) throws E {
        if (visitChildren()) {
            Child child = node.getChild(type);
            Child result = null;
            if (child != null) {
                result = processChildTerm(child, this.visitNode(child, p));
            }
            node = copier.copy(node, result, type);
        }
        return node;
    }

    /**
     * Generically visit a list of children of an ASTNode. A node implements Interfaces.Collection
     * if it has one or more multiplicity * (i.e. a java.util.Collection) child nodes.
     * For example usage of this method, refer to {@link #visit(Object)}
     * to see an example with multiple multiplicity * child nodes, or
     * {@link #visit(Definition, Object)} for an example with only one.
     */
    private <Child extends ASTNode, EnumType extends Enum<?>,
        Parent extends ASTNode & Interfaces.Collection<Child, EnumType>>
            Parent genericVisitList(
                    Parent node, P p,
                    CollectionASTNodeCopier<Child, EnumType, Parent> copier, EnumType type) throws E {
        if(visitChildren()) {
            List<Child> items = new ArrayList<>();
            for (Child item : node.getChildren(type)) {
                Child result = processChildTerm(item, this.visitNode(item, p));
                if (result != null) {
                    items.add(result);
                }
            }
            node = copier.copy(node, items, type);
        }
        return node;
    }

    /**
     * An abstract class encapsulating the generic functionality of copying an ASTNode
     * that extends {@link Interfaces.Collection}. Instances of this class should override the
     * {@link #doCopy(ASTNode, java.util.Collection, Enum)} method.
     *
     * @param <Child> The item type of the collection of child terms being modified
     * @param <EnumType> The enum used to identify which child collection is being targeted.
     * @param <Parent> The type of the ASTNode being copied.
     */
    private abstract class CollectionASTNodeCopier<Child extends ASTNode,
        EnumType extends Enum<?>,
        Parent extends ASTNode & Interfaces.Collection<Child, EnumType>> {

        public final Parent copy(Parent node, java.util.Collection<Child> items, EnumType type) {
            if (changed(node.getChildren(type), items)) {
                node = doCopy(node, items, type);
            }
            return node;
        }

        protected abstract Parent doCopy(Parent node, java.util.Collection<Child> items, EnumType cls);
    }


    /**
     * An abstract class encapsulating the generic functionality of copying an ASTNode
     * that extends {@link Interfaces.Parent}. Instances of this class should override the
     * {@link #doCopy(ASTNode, ASTNode, Enum)} method.
     *
     * @param <Child> The type of the child term being modified
     * @param <EnumType> The enum used to identify which child term is being targeted.
     * @param <Parent> The type of the ASTNode being copied.
     */
    private abstract class ChildASTNodeCopier<Child extends ASTNode,
        EnumType extends Enum<?>,
        Parent extends ASTNode & Interfaces.Parent<Child, EnumType>> {

        public Parent copy(Parent node, Child child, EnumType type) {
            if (changed(node.getChild(type), child)) {
                node = doCopy(node, child, type);
            }
            return node;
        }

        protected abstract Parent doCopy(Parent node, Child child, EnumType type);
    }

    /**
     * Create a new {@link CollectionASTNodeCopier} for a mutable class.
     * @param cls The ASTNode class to create a copier of.
     * @return A copier suitable for passing to
     * {@link AbstractVisitor#genericVisitList(ASTNode, Object, CollectionASTNodeCopier, Enum)}.
     */
    private <Child extends ASTNode, EnumType extends Enum<?>,
        ParentType extends ASTNode & Interfaces.MutableList<Child, EnumType>>
        CollectionASTNodeCopier<Child, EnumType, ParentType> mutableList(Class<ParentType> cls) {

        return new CollectionASTNodeCopier<Child, EnumType, ParentType>() {

            @Override
            protected ParentType doCopy(ParentType node,
                    java.util.Collection<Child> items, EnumType type) {
                node = AbstractVisitor.this.copy(node);
                node.setChildren((List<Child>)items, type);
                return node;
            }
        };
    }

    /**
     * Create a new {@link ChildASTNodeCopier} for a mutable class.
     * @param cls The ASTNode class to create a copier of.
     * @return A copier suitable for passing to
     * {@link AbstractVisitor#genericVisitChild(ASTNode, Object, ChildASTNodeCopier, Enum)}.
     */
    private <Child extends ASTNode, EnumType extends Enum<?>,
        ParentType extends ASTNode & Interfaces.MutableParent<Child, EnumType>>
        ChildASTNodeCopier<Child, EnumType, ParentType> mutableChild(Class<ParentType> cls) {

        return new ChildASTNodeCopier<Child, EnumType, ParentType>() {

            @Override
            protected ParentType doCopy(ParentType node, Child child,
                    EnumType type) {
                node = AbstractVisitor.this.copy(node);
                node.setChild(child, type);
                return node;
            }

        };
    }

    /**
     * Helper method to check {@link #changed(ASTNode, ASTNode)} on collections of terms.
     * @param o
     * @param n
     * @return
     */
    private final <T extends ASTNode> boolean changed(java.util.Collection<T> o,
            java.util.Collection<T> n) {
        Iterator<T> iter1 = o.iterator();
        Iterator<T> iter2 = n.iterator();
        boolean change = false;
        while (iter1.hasNext() && iter2.hasNext()) {
            change |= changed(iter1.next(), iter2.next());
        }
        return change || iter1.hasNext() != iter2.hasNext();
    }

    /**
     * Helper method to check {@link #changed(ASTNode, ASTNode)} on maps of terms.
     * @param o
     * @param n
     * @return
     */
    private final <K extends ASTNode, V extends ASTNode> boolean changed(
            Map<K, V> o, Map<K, V> n) {
        Iterator<Map.Entry<K, V>> iter1 = o.entrySet().iterator();
        Iterator<Map.Entry<K, V>> iter2 = n.entrySet().iterator();
        boolean change = false;
        while (iter1.hasNext() && iter2.hasNext()) {
            Map.Entry<K, V> e1 = iter1.next();
            Map.Entry<K, V> e2 = iter2.next();
            change |= changed(e1.getKey(), e2.getKey());
            change |= changed(e1.getValue(), e2.getValue());
        }
        return change || iter1.hasNext() != iter2.hasNext();
    }

    // END GENERIC MACHINERY

    @Override
    public R visit(ASTNode node, P p) throws E {
        R ret = defaultReturnValue(node, p);
        return ret;
    }

    @Override
    public R visit(Definition node, P p) throws E {
        currentDefinition = node;
        node = genericVisitList(node, p, mutableList(Definition.class), null);
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(DefinitionItem node, P p) throws E {
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(LiterateDefinitionComment node, P p) throws E {
        return visit((DefinitionItem) node, p);
    }

    @Override
    public R visit(Module node, P p) throws E {
        currentModule = node;
        node = genericVisitList(node, p, mutableList(Module.class), null);
        return visit((DefinitionItem) node, p);
    }

    @Override
    public R visit(Require node, P p) throws E {
        return visit((DefinitionItem) node, p);
    }

    @Override
    public R visit(ModuleItem node, P p) throws E {
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(Import node, P p) throws E {
        return visit((ModuleItem) node, p);
    }

    @Override
    public R visit(LiterateModuleComment node, P p) throws E {
        return visit((ModuleItem) node, p);
    }

    @Override
    public R visit(Syntax node, P p) throws E {
        node = genericVisitChild(node, p, mutableChild(Syntax.class), null);
        node = genericVisitList(node, p, mutableList(Syntax.class), null);
        return visit((ModuleItem) node, p);
    }

    @Override
    public R visit(PriorityExtended node, P p) throws E {
        node = genericVisitList(node, p, mutableList(PriorityExtended.class), null);
        return visit((ModuleItem) node, p);
    }

    @Override
    public R visit(PriorityExtendedAssoc node, P p) throws E {
        return visit((ModuleItem) node, p);
    }

    @Override
    public R visit(PriorityBlock node, P p) throws E {
        node = genericVisitList(node, p, mutableList(PriorityBlock.class), null);
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(PriorityBlockExtended node, P p) throws E {
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(Production node, P p) throws E {
        node = genericVisitList(node, p, mutableList(Production.class), null);
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(ProductionItem node, P p) throws E {
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(NonTerminal node, P p) throws E {
        return visit((ProductionItem) node, p);
    }

    @Override
    public R visit(Terminal node, P p) throws E {
        return visit((ProductionItem) node, p);
    }

    @Override
    public R visit(Lexical node, P p) throws E {
        return visit((ProductionItem) node, p);
    }

    @Override
    public R visit(UserList node, P p) throws E {
        return visit((ProductionItem) node, p);
    }

    @Override
    public R visit(Attributes node, P p) throws E {
        node = genericVisitList(node, p, mutableList(Attributes.class), null);
        return visit((ASTNode) node, p);
    }


    @Override
    public R visit(Attribute node, P p) throws E {
        return visit((ASTNode) node, p);
    }

    @Override
    public R visit(StringSentence node, P p) throws E {
        return visit((ModuleItem) node, p);
    }

    public String getName() {
        return name;
    }

    @Override
    public R complete(ASTNode node, R r) {
        cache.put(node, r);
        return r;
    }

    // AbstractVisitor child class interface methods

    /**
     * Helper method to abstract details of how to decide whether a child term needs to
     * be replaced in the tree.
     *
     * Right now any object which is not identical to the object that was there before counts as
     * "changed". Theoretically we could inline this method everywhere, but by centralizing it here,
     * that mechanism can be changed later much more easily if we so desire.
     * @param oldObj The child node before potentially being replaced.
     * @param newObj The child node after having potentially been replaced.
     * @return
     */
    public <T extends ASTNode> boolean changed(T oldObj, T newObj) {
        return oldObj != newObj;
    }

    /**
     * The value this transformer returns by default from a {@link #visit(ASTNode, Object)}
     * or {@link #visitNode(ASTNode, Object)} invocation if not overriden by the implementation
     * of the visitor. For example, for {@link BasicVisitor}, which returns void, this method returns
     * {@code null}, whereas for {@link AbstractTransformer}, which returns {@link ASTNode}, this
     * method returns {@code node}.
     * @param node The node being visited
     * @param p The optional parameter for the visitor
     * @return The value to return from the visit to this node.
     */
    public abstract R defaultReturnValue(ASTNode node, P p);

    /**
     * Determines, based on the information provided from visiting a child term, what term should be
     * reinserted into the tree after the child term is visited. For a visitor which does not transform,
     * this is a no-op, returning {@code node}. For a visitor which transforms its children and
     * replaces them, {@code R} is an {@link ASTNode}, so it returns {@code childResult}.
     * @param child The child term before being visited.
     * @param childResult The result from visiting the child term.
     * @return The term to be reinserted as the new child in the tree.
     */
    public abstract <T extends ASTNode> T processChildTerm(T child, R childResult);

    /**
     * Returns true if this visitor should visit the children of the term being visited, false
     * if only the term itself should be visited.
     * @return
     */
    public abstract boolean visitChildren();

    /**
     * Returns true if the result of visiting the tree should be cached by object identity;
     * false if every term should be visited regardless of sharing.
     * @return
     */
    public abstract boolean cache();

    /**
     * Returns the object to pass to the visitor to the parent class of the class being visited.
     * By combining this field with {@link #defaultReturnValue(ASTNode, Object)}, it is possible
     * to decide whether a visitor should make copies of any terms it modifies. This is used to
     * distinguish {@link ParseForestTransformer}, which modifies nodes in-place in the tree, and
     * {@link CopyOnWriteTransformer}, which creates a copy of the tree to return if a node is changed.
     * @param original The node being visited.
     * @return The node as it will be passed to the visit method for its parent class.
     */
    public abstract <T extends ASTNode> T copy(T original);
}
