// Copyright (c) 2012-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil.visitors;

import org.kframework.frontend.kil.*;

public interface Visitor<P, R, E extends Throwable> {
    public R visit(ASTNode node, P p) throws E;
    public R visit(Definition node, P p) throws E;
    public R visit(DefinitionItem node, P p) throws E;
    // <DefinitionItems>
    public R visit(LiterateDefinitionComment node, P p) throws E;
    public R visit(Module node, P p) throws E;
    public R visit(Require require, P p) throws E;
    // </DefinitionItems>
    public R visit(ModuleItem node, P p) throws E;
    // <ModuleItems>
    public R visit(Import node, P p) throws E;
    public R visit(LiterateModuleComment node, P p) throws E;
    public R visit(StringSentence node, P p) throws E;
    // </Sentences>
    public R visit(Syntax node, P p) throws E;
    public R visit(PriorityExtended node, P p) throws E;
    public R visit(PriorityExtendedAssoc node, P p) throws E;
    // <ModuleItems>
    public R visit(PriorityBlock node, P p) throws E;
    public R visit(PriorityBlockExtended node, P p) throws E;
    public R visit(Production node, P p) throws E;
    public R visit(ProductionItem node, P p) throws E;
    // <ProductionItems>
    public R visit(NonTerminal node, P p) throws E;
    public R visit(Lexical node, P p) throws E;
    public R visit(Terminal node, P p) throws E;
    public R visit(UserList node, P p) throws E;
    // Others
    public R visit(Attributes node, P p) throws E;
    public R visit(Attribute node, P p) throws E;

    /**
     * Visit an AST tree. This is the main entry point whenever you want to apply a visitor to an ASTNode.
     *
     * @param node The node to visit.
     * @param p The optional parameter to pass to the visit methods.
     * @return The value returned from visiting the entire ASTNode tree.
     * @throws E if the visitor implementation raises an exception.
     */
    public R visitNode(ASTNode node, P p) throws E;

    /**
     * Visit an AST tree with {@code p} equal to null. Useful if {@code <P>} is {@link Void}.
     *
     * This method should be implemented by calling {@code visitNode(node, null)}.
     *
     * @param node The node to visit.
     * @return The value returned from visiting the entire ASTNode tree.
     * @throws E if the visitor implementation raises an exception.
     */
    public R visitNode(ASTNode node) throws E;

    /**
     * This method must be called by {@link ASTNode#accept(Visitor, Object)} with the ASTNode
     * and the result of transforming the ASTNode. Its purpose is to factor out functionality
     * which must be performed by the visitor for correctness regardless of whether the visit
     * methods are overridden. For example, a visitor may override a method in such a way that
     * children are not accepted, or so that the parent class's visit method is not called.
     * This method serves to guarantee that certain functionality will occur regardless of whether
     * this is the case.
     * @param node Should be the {@code this} of the ASTNode.
     * @param r Should be the result of visiting the ASTNode.
     * @return Implementations should return {@code r}.
     */
    public R complete(ASTNode node, R r);
}
