package org.mockserver.character;

import org.apache.commons.text.StringEscapeUtils;

/**
 * @author jamesdbloom
 */
public class Character {

    public static final String NEW_LINE = System.getProperty("line.separator");
    public static final String ESCAPED_NEW_LINE = StringEscapeUtils.escapeJava(NEW_LINE);

}
