public class UtilityClass {

    // Method 1: Get full name
    public static String getFullName(String firstName, String lastName) {
        return firstName + ' ' + lastName;
    }

    // Method 2: Multiply two numbers
    public static Decimal multiplyNumbers(Decimal a, Decimal b) {
        return a * b;
    }

    // Method 3: Return today's date in string format
    public static String getTodayDate() {
        return Date.today().format();
    }
}