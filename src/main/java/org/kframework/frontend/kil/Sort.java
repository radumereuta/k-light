// Copyright (c) 2012-2016 K Team. All Rights Reserved.
package org.kframework.frontend.kil;

import java.io.Serializable;

public class Sort implements Serializable {

    private final String name;

    public static Sort of(String name) {
        return new Sort(name);
    }

    private Sort(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Sort)) {
            return false;
        }
        Sort other = (Sort) obj;
        return name.equals(other.name);
    }

    @Override
    public int hashCode() {
        return name.hashCode();
    }

    @Override
    public String toString() {
        return name;
    }
}
