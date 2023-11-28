/**
 * Simple program for exploring KeyStore aliases and certificate details extracted from:
 * https://github.com/openjdk/jdk21u/blob/master/test/jdk/sun/security/lib/CheckBlockedCerts.java
 * 
 * export JAVA_HOME=/c/java/binaries/jdk/x64/jdk-21.0.1+12/
 * $JAVA_HOME/bin/javac GetKeyStoreAliases.java
 * $JAVA_HOME/bin/java GetKeyStoreAliases /c/java/binaries/jdk/x64/jdk-17.0.9+8
 */

import java.io.*;
import java.security.KeyStore;
import java.security.cert.*;
import java.util.*;

public final class GetKeyStoreAliases {

    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Usage: GetKeyStoreAliases <JDK Home>");
            return;
        }

        String jdkHome = args[0];
        File file = new File(jdkHome, "lib/security/cacerts");
        KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
        try (FileInputStream fis = new FileInputStream(file)) {
            ks.load(fis, null);
        }

        System.out.println("Number of cacerts: " + ks.size());
        for (String alias: Collections.list(ks.aliases())) {
            X509Certificate cert = (X509Certificate)ks.getCertificate(alias);
            System.out.println("Found certificate for alias: " + alias);
            System.out.println(cert);
            System.out.println("-----------------------------------------------------------------------");
        }
    }
}
