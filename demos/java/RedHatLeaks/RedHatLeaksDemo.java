/*
 * From https://developers.redhat.com/blog/2020/08/25/get-started-with-jdk-flight-recorder-in-openjdk-8u#
 *
 * For an intro to JFR, see https://www.baeldung.com/java-flight-recorder-monitoring
 *
 * java -XX:StartFlightRecording=duration=5s,filename=flight.jfr RedHatLeaksDemo
 * java -XX:+UnlockDiagnosticVMOptions -XX:+LogCompilation -XX:StartFlightRecording=duration=60s,filename=flight-logcompilation.jfr RedHatLeaksDemo
 *
 * java RedHatLeaksDemo
 * java -XX:+UnlockDiagnosticVMOptions -XX:+LogCompilation RedHatLeaksDemo
 * ps -a | grep java
 * jcmd 13573 JFR.start duration=100s filename=flight-jcmd.jfr
 */
import java.util.HashMap;
import java.util.Map;

public class RedHatLeaksDemo {

   private static final Map<Object, Object> SESSION_DATA = new HashMap<>();

   public static class UserInformation {
      private byte[] data = new byte[10000];
   }

   public static void main(String[] args) {
       String userId = "user";
       while (true) {
           UserInformation user = (UserInformation) SESSION_DATA.get(userId);
           if (user == null) {
               user = findUserInformation(userId);
               // SESSION_DATA.put(userId, user); // Correct
               SESSION_DATA.put(user, user);      // Wrong
           }
           sleep();
       }
   }

   private static UserInformation findUserInformation(String userId) {
       sleep();
       return new UserInformation();
   }

   private static void sleep() {
       try {
           Thread.sleep(1);
       } catch (InterruptedException e) {}
   }
}