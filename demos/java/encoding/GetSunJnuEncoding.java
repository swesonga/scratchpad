/**
 * export JAVA_HOME=~/java/binaries/jdk/x64/jdk-21.0.2+13
 * $JAVA_HOME/bin/javac GetSunJnuEncoding.java
 * $JAVA_HOME/bin/java GetSunJnuEncoding
 * 
 * https://docs.oracle.com/en/java/javase/21/docs/api/system-properties.html
 */

import java.nio.charset.Charset;

public class GetSunJnuEncoding {
    public static void main(String[] args) {
        var propertyName = "sun.jnu.encoding";
        var jnuEncoding = System.getProperty(propertyName);

        if (jnuEncoding == null) {
            System.out.printf("%s property is null.\n", propertyName);
            return;
        }

        System.out.printf("%s property value: %s\n", propertyName, jnuEncoding);

        boolean isSupported = Charset.isSupported(jnuEncoding);
        System.out.printf("Charset.isSupported(%s): %b\n", jnuEncoding, isSupported);    
    }
}