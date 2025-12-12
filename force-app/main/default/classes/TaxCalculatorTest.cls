/**
 * @description Test class for TaxCalculator
 * @author Copado Test Agent
 * @date 2025
 */
@IsTest
private class TaxCalculatorTest {
    
    /**
     * @description Test calculateItemTax method with standard category
     */
    @IsTest
    static void testCalculateItemTax_StandardCategory() {
        // Test data
        Decimal amount = 200.00;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.STANDARD;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Decimal expectedTax = amount * TaxCalculator.STANDARD_TAX_RATE;
        Assert.areEqual(expectedTax, result, 'Standard tax calculation should be correct');
    }
    
    /**
     * @description Test calculateItemTax method with luxury category
     */
    @IsTest
    static void testCalculateItemTax_LuxuryCategory() {
        // Test data
        Decimal amount = 50.00; // Below threshold but luxury items are always taxed
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.LUXURY;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Decimal expectedTax = amount * TaxCalculator.LUXURY_TAX_RATE;
        Assert.areEqual(expectedTax, result, 'Luxury tax should be applied even below threshold');
    }
    
    /**
     * @description Test calculateItemTax method with service category
     */
    @IsTest
    static void testCalculateItemTax_ServiceCategory() {
        // Test data
        Decimal amount = 150.00;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.SERVICE;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Decimal expectedTax = amount * TaxCalculator.SERVICE_TAX_RATE;
        Assert.areEqual(expectedTax, result, 'Service tax calculation should be correct');
    }
    
    /**
     * @description Test calculateItemTax method with exempt category
     */
    @IsTest
    static void testCalculateItemTax_ExemptCategory() {
        // Test data
        Decimal amount = 500.00;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.EXEMPT;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, 'Exempt items should have no tax');
    }
    
    /**
     * @description Test calculateItemTax method with amount below tax exempt threshold
     */
    @IsTest
    static void testCalculateItemTax_BelowThreshold() {
        // Test data
        Decimal amount = 50.00; // Below $100 threshold
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.STANDARD;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, 'Items below threshold should be tax exempt');
    }
    
    /**
     * @description Test calculateItemTax method with null amount
     */
    @IsTest
    static void testCalculateItemTax_NullAmount() {
        // Test data
        Decimal amount = null;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.STANDARD;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, 'Null amount should return zero tax');
    }
    
    /**
     * @description Test calculateItemTax method with negative amount
     */
    @IsTest
    static void testCalculateItemTax_NegativeAmount() {
        // Test data
        Decimal amount = -100.00;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.STANDARD;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.calculateItemTax(amount, category);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, 'Negative amount should return zero tax');
    }
    
    /**
     * @description Test calculateOrderTax method with multiple items
     */
    @IsTest
    static void testCalculateOrderTax_MultipleItems() {
        // Test data
        List<TaxCalculator.TaxItem> items = new List<TaxCalculator.TaxItem>{
            new TaxCalculator.TaxItem(200.00, TaxCalculator.ProductCategory.STANDARD, 'Standard Item'),
            new TaxCalculator.TaxItem(300.00, TaxCalculator.ProductCategory.LUXURY, 'Luxury Item'),
            new TaxCalculator.TaxItem(150.00, TaxCalculator.ProductCategory.SERVICE, 'Service Item'),
            new TaxCalculator.TaxItem(250.00, TaxCalculator.ProductCategory.EXEMPT, 'Exempt Item')
        };
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary result = TaxCalculator.calculateOrderTax(items);
        Test.stopTest();
        
        // Verify
        Decimal expectedSubtotal = 900.00;
        Decimal expectedTax = (200.00 * 0.0875) + (300.00 * 0.15) + (150.00 * 0.06) + 0;
        
        Assert.areEqual(expectedSubtotal, result.subtotal, 'Subtotal calculation should be correct');
        Assert.areEqual(expectedTax, result.totalTax, 'Total tax calculation should be correct');
        Assert.areEqual(expectedSubtotal + expectedTax, result.grandTotal, 'Grand total calculation should be correct');
        Assert.isTrue(result.taxByCategory.containsKey(TaxCalculator.ProductCategory.STANDARD), 'Tax by category should include standard');
    }
    
    /**
     * @description Test calculateOrderTax method with empty list
     */
    @IsTest
    static void testCalculateOrderTax_EmptyList() {
        // Test data
        List<TaxCalculator.TaxItem> items = new List<TaxCalculator.TaxItem>();
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary result = TaxCalculator.calculateOrderTax(items);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result.subtotal, 'Empty list should have zero subtotal');
        Assert.areEqual(0, result.totalTax, 'Empty list should have zero tax');
        Assert.areEqual(0, result.grandTotal, 'Empty list should have zero grand total');
    }
    
    /**
     * @description Test calculateOrderTax method with null list
     */
    @IsTest
    static void testCalculateOrderTax_NullList() {
        // Test data
        List<TaxCalculator.TaxItem> items = null;
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary result = TaxCalculator.calculateOrderTax(items);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result.subtotal, 'Null list should have zero subtotal');
        Assert.areEqual(0, result.totalTax, 'Null list should have zero tax');
        Assert.areEqual(0, result.grandTotal, 'Null list should have zero grand total');
    }
    
    /**
     * @description Test applyTaxDiscount method with valid discount
     */
    @IsTest
    static void testApplyTaxDiscount_ValidDiscount() {
        // Test data
        Decimal originalTax = 100.00;
        Decimal discountPercent = 10.0;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.applyTaxDiscount(originalTax, discountPercent);
        Test.stopTest();
        
        // Verify
        Decimal expectedTax = 90.00; // 100 - (100 * 0.10)
        Assert.areEqual(expectedTax, result, 'Tax discount should be applied correctly');
    }
    
    /**
     * @description Test applyTaxDiscount method with 100% discount
     */
    @IsTest
    static void testApplyTaxDiscount_FullDiscount() {
        // Test data
        Decimal originalTax = 50.00;
        Decimal discountPercent = 100.0;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.applyTaxDiscount(originalTax, discountPercent);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, '100% discount should result in zero tax');
    }
    
    /**
     * @description Test applyTaxDiscount method with discount over 100%
     */
    @IsTest
    static void testApplyTaxDiscount_OverFullDiscount() {
        // Test data
        Decimal originalTax = 50.00;
        Decimal discountPercent = 150.0;
        
        // Execute
        Test.startTest();
        Decimal result = TaxCalculator.applyTaxDiscount(originalTax, discountPercent);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, result, 'Discount over 100% should be capped at 100%');
    }
    
    /**
     * @description Test applyTaxDiscount method with null values
     */
    @IsTest
    static void testApplyTaxDiscount_NullValues() {
        // Execute and verify null tax
        Test.startTest();
        Decimal result1 = TaxCalculator.applyTaxDiscount(null, 10.0);
        Test.stopTest();
        
        Assert.areEqual(0, result1, 'Null original tax should return zero');
        
        // Execute and verify null discount
        Test.startTest();
        Decimal result2 = TaxCalculator.applyTaxDiscount(50.00, null);
        Test.stopTest();
        
        Assert.areEqual(50.00, result2, 'Null discount should return original tax');
    }
    
    /**
     * @description Test isCustomerTaxExempt method with exempt customer types
     */
    @IsTest
    static void testIsCustomerTaxExempt_ExemptTypes() {
        // Test all exempt types
        Test.startTest();
        Assert.isTrue(TaxCalculator.isCustomerTaxExempt('NON_PROFIT'), 'Non-profit should be tax exempt');
        Assert.isTrue(TaxCalculator.isCustomerTaxExempt('GOVERNMENT'), 'Government should be tax exempt');
        Assert.isTrue(TaxCalculator.isCustomerTaxExempt('EDUCATIONAL'), 'Educational should be tax exempt');
        Assert.isTrue(TaxCalculator.isCustomerTaxExempt('RELIGIOUS'), 'Religious should be tax exempt');
        
        // Test case insensitive
        Assert.isTrue(TaxCalculator.isCustomerTaxExempt('non_profit'), 'Should be case insensitive');
        Test.stopTest();
    }
    
    /**
     * @description Test isCustomerTaxExempt method with non-exempt customer types
     */
    @IsTest
    static void testIsCustomerTaxExempt_NonExemptTypes() {
        // Test non-exempt types
        Test.startTest();
        Assert.isFalse(TaxCalculator.isCustomerTaxExempt('BUSINESS'), 'Business should not be tax exempt');
        Assert.isFalse(TaxCalculator.isCustomerTaxExempt('INDIVIDUAL'), 'Individual should not be tax exempt');
        Assert.isFalse(TaxCalculator.isCustomerTaxExempt(''), 'Empty string should not be tax exempt');
        Assert.isFalse(TaxCalculator.isCustomerTaxExempt(null), 'Null should not be tax exempt');
        Test.stopTest();
    }
    
    /**
     * @description Test TaxItem wrapper class constructor
     */
    @IsTest
    static void testTaxItem_Constructor() {
        // Test data
        Decimal amount = 100.00;
        TaxCalculator.ProductCategory category = TaxCalculator.ProductCategory.STANDARD;
        String description = 'Test Item';
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxItem item = new TaxCalculator.TaxItem(amount, category, description);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(amount, item.amount, 'Amount should be set correctly');
        Assert.areEqual(category, item.category, 'Category should be set correctly');
        Assert.areEqual(description, item.description, 'Description should be set correctly');
    }
    
    /**
     * @description Test TaxSummary wrapper class default constructor
     */
    @IsTest
    static void testTaxSummary_DefaultConstructor() {
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary summary = new TaxCalculator.TaxSummary();
        Test.stopTest();
        
        // Verify
        Assert.areEqual(0, summary.subtotal, 'Default subtotal should be zero');
        Assert.areEqual(0, summary.totalTax, 'Default total tax should be zero');
        Assert.areEqual(0, summary.grandTotal, 'Default grand total should be zero');
        Assert.isNotNull(summary.taxByCategory, 'Tax by category map should be initialized');
    }
    
    /**
     * @description Test TaxSummary wrapper class parameterized constructor
     */
    @IsTest
    static void testTaxSummary_ParameterizedConstructor() {
        // Test data
        Decimal subtotal = 100.00;
        Decimal totalTax = 8.75;
        Map<TaxCalculator.ProductCategory, Decimal> taxByCategory = 
            new Map<TaxCalculator.ProductCategory, Decimal>{
                TaxCalculator.ProductCategory.STANDARD => 8.75
            };
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary summary = new TaxCalculator.TaxSummary(subtotal, totalTax, taxByCategory);
        Test.stopTest();
        
        // Verify
        Assert.areEqual(subtotal, summary.subtotal, 'Subtotal should be set correctly');
        Assert.areEqual(totalTax, summary.totalTax, 'Total tax should be set correctly');
        Assert.areEqual(108.75, summary.grandTotal, 'Grand total should be calculated correctly');
        Assert.areEqual(taxByCategory, summary.taxByCategory, 'Tax by category should be set correctly');
    }
    
    /**
     * @description Test bulk processing with large dataset for performance
     */
    @IsTest
    static void testCalculateOrderTax_BulkProcessing() {
        // Test data - create 200 items
        List<TaxCalculator.TaxItem> items = new List<TaxCalculator.TaxItem>();
        for (Integer i = 0; i < 200; i++) {
            TaxCalculator.ProductCategory category = 
                Math.mod(i, 4) == 0 ? TaxCalculator.ProductCategory.STANDARD :
                Math.mod(i, 4) == 1 ? TaxCalculator.ProductCategory.LUXURY :
                Math.mod(i, 4) == 2 ? TaxCalculator.ProductCategory.SERVICE :
                TaxCalculator.ProductCategory.EXEMPT;
            
            items.add(new TaxCalculator.TaxItem(100.00 + i, category, 'Item ' + i));
        }
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary result = TaxCalculator.calculateOrderTax(items);
        Test.stopTest();
        
        // Verify
        Assert.isTrue(result.subtotal > 0, 'Bulk processing should handle large datasets');
        Assert.isTrue(result.totalTax > 0, 'Bulk processing should calculate tax correctly');
        Assert.areEqual(4, result.taxByCategory.size(), 'Should track all category types');
    }
    
    /**
     * @description Test integration scenario with tax exempt customer
     */
    @IsTest
    static void testIntegration_TaxExemptCustomer() {
        // Test data
        List<TaxCalculator.TaxItem> items = new List<TaxCalculator.TaxItem>{
            new TaxCalculator.TaxItem(200.00, TaxCalculator.ProductCategory.STANDARD, 'Standard Item'),
            new TaxCalculator.TaxItem(300.00, TaxCalculator.ProductCategory.LUXURY, 'Luxury Item')
        };
        String customerType = 'NON_PROFIT';
        
        // Execute
        Test.startTest();
        TaxCalculator.TaxSummary orderTax = TaxCalculator.calculateOrderTax(items);
        Boolean isExempt = TaxCalculator.isCustomerTaxExempt(customerType);
        
        Decimal finalTax = isExempt ? 0 : orderTax.totalTax;
        Test.stopTest();
        
        // Verify
        Assert.isTrue(isExempt, 'Non-profit customer should be tax exempt');
        Assert.areEqual(0, finalTax, 'Final tax should be zero for exempt customer');
        Assert.areEqual(500.00, orderTax.subtotal, 'Subtotal should not be affected by exemption');
    }
}