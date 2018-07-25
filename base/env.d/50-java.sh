#!/bin/sh

# Ensure Java uses font antialiasing and the GTK look-and-feel.
_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export _JAVA_OPTIONS
