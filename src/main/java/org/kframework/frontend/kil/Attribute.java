// Copyright (c) 2014-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import com.google.common.reflect.TypeToken;
import com.google.inject.name.Named;
import com.google.inject.name.Names;
import org.kframework.frontend.kil.loader.Constants;
import org.kframework.frontend.kil.visitors.Visitor;

import java.io.Serializable;
import java.lang.annotation.Annotation;

/**
 * Please use {@link org.kframework.attributes.Att}
 * Represents either an explicit attribute on a {@link Bubble} or {@link Production},
 * or node metadata like location.
 * The inherited member attributes is used for location information
 * if this represents an explicitly written attribute.
 */
public class Attribute extends ASTNode {

    public static final String TOKEN = "token";
    public static final String KLABEL = "klabel";
    public static final String RULE = "rule";
    public static final String CONFIG = "config";
    public static final String CONTEXT = "context";


    public static final Attribute BRACKET = Attribute.of("bracket", "");

    private String key;
    private String value;

    public static Attribute of(String key, String value) {
        return new Attribute(key, value);
    }

    public Attribute(String key, String value) {
        super();
        this.key = key;
        this.value = value;
    }

    public Attribute(Attribute attribute) {
        super(attribute);
        key = attribute.key;
        value = attribute.value;
    }

    @Override
    public String toString() {
        return " " + this.getKey() + "(" + this.getValue() + ")";
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getKey() {
        return key;
    }

    @Override
    public Attribute shallowCopy() {
        return new Attribute(this);
    }

    @Override
    protected <P, R, E extends Throwable> R accept(Visitor<P, R, E> visitor, P p) throws E {
        return visitor.complete(this, visitor.visit(this, p));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((key == null) ? 0 : key.hashCode());
        result = prime * result + ((value == null) ? 0 : value.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Attribute other = (Attribute) obj;
        if (key == null) {
            if (other.key != null)
                return false;
        } else if (!key.equals(other.key))
            return false;
        if (value == null) {
            if (other.value != null)
                return false;
        } else if (!value.equals(other.value))
            return false;
        return true;
    }
}
