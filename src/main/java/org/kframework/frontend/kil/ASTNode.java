// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import org.kframework.attributes.Location;
import org.kframework.attributes.Source;
import org.kframework.frontend.kil.visitors.Visitor;

import java.io.Serializable;

/**
 * Base class for K AST. Useful for Visitors and Transformers.
 */
public abstract class ASTNode implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 1L;
    /**
     * Used on any node for metadata also used on {@link Production} for the attribute list.
     */
    private Attributes attributes;

    private Source source;
    private Location location;

    /**
     * Copy constructor
     *
     * @param astNode
     */
    public ASTNode(ASTNode astNode) {
        copyAttributesFrom(astNode);
        location = astNode.location;
        source = astNode.source;
    }

    /**
     * Default constructor (generated at runtime)
     */
    public ASTNode() {
        this(null, null);
    }

    /**
     * Constructor with specified location and filename.
     *
     * @param loc (<start_line>, <start_column>, <end_line>, <end_column>)
     * @param source File location or compilation stage.
     */
    public ASTNode(Location loc, Source source) {
        setLocation(loc);
        setSource(source);
    }

    /**
     * Retrieves the location of the current ASTNode.
     *
     * @return recorded location or null if no recorded location found.
     */
    public Location getLocation() {
        return location;
    }

    /**
     * Sets the location or removes it if appropriate.
     *
     * @param location
     */
    public void setLocation(Location location) {
        this.location = location;
    }

    /**
     * Retrieves the source of the current ASTNode.
     *
     * @return recorded source or null if no recorded source found.
     */
    public Source getSource() {
        return source;
    }

    /**
     * Sets the source or removes it if appropriate.
     *
     * @param source
     */
    public void setSource(Source source) {
        this.source = source;
    }

    /*
     * methods for easy attributes manipulation
     */

    /**
     * Appends an attribute to the list of attributes.
     *
     * @param key
     * @param val
     */
    public void addAttribute(String key, String val) {
        addAttribute(Attribute.of(key, val));
    }


    /**
     * Appends an attribute to the list of attributes.
     *
     * @param attr
     */
    public void addAttribute(Attribute attr) {
        if (attributes == null)
            attributes = new Attributes();

        attributes.add(attr);
    }

    /**
     * @param key
     * @return whether the attribute key occurs in the list of attributes.
     */
    public boolean containsAttribute(String key) {
        if (attributes == null)
            return false;

        return attributes.containsKey(key);
    }

    /**
     * Retrieves the attribute by key from the list of attributes
     *
     * @param key
     * @return a value for key in the list of attributes or the default value.
     */
    public String getAttributeValue(String key) {
        if (attributes == null)
            return null;
        final Attribute value = (Attribute) attributes.get(key);
        if (value == null)
            return null;
        return value.getValue();
    }

    public Attribute getAttribute(String key) {
        if (attributes == null)
            return null;
        return attributes.get(key);
    }

    /**
     * Updates the value of an attribute in the list of attributes.
     *get
     * @param key
     * @param val
     */
    public void putAttribute(String key, String val) {
        addAttribute(key, val);
    }

    public void removeAttribute(String key) {
        getAttributes().remove(key);
    }

    /**
     * @return the attributes object associated to this ASTNode. Constructs one if it is
     * not already created.
     */
    public Attributes getAttributes() {
        if (attributes == null) {
            attributes = new Attributes();
        }
        return attributes;
    }

    /**
     * Sets the attributes object associated to this ASTNode.
     *
     * @param attrs
     */
    public void setAttributes(Attributes attrs) {
        attributes = attrs;
    }

    /**
     * Copies attributes from another node into this node.
     * Use this in preference to {@link ASTNode#getAttributes} where appropriate because
     * the latter will create a new object if no attributes exist.
     * @param node The ASTNode to copy all attributes from.
     */
    public void copyAttributesFrom(ASTNode node) {
        if (node.attributes == null)
            return;
        this.getAttributes().putAll(node.attributes);
    }

    /**
     * @return a copy of the ASTNode containing the same fields.
     */
    public abstract ASTNode shallowCopy();

    protected abstract <P, R, E extends Throwable> R accept(Visitor<P, R, E> visitor, P p) throws E;

    public int computeHashCode() {
        throw new AssertionError("Subclasses should implement their own hashCode so this code should not be reachable");
    }

    public int cachedHashCode() {
        throw new AssertionError("Subclasses should implement their own hashCode so this code should not be reachable");
    }
}
