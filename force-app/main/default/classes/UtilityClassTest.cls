@isTest
public class UtilityClassTest {

    @isTest
    static void testGetFullName() {
        String fullName = UtilityClass.getFullName('John', 'Doe');
        System.assertEquals('John Doe', fullName, 'Full name should be correct');
    }

    @isTest
    static void testMultiplyNumbers() {
        Decimal result = UtilityClass.multiplyNumbers(5, 2);
        System.assertEquals(10, result, 'Multiplication should be correct');
    }

    @isTest
    static void testGetTodayDate() {
        String today = UtilityClass.getTodayDate();
        System.assertEquals(Date.today().format(), today, 'Should return today\'s date');
    }
}