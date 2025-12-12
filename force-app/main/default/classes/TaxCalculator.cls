/**
 * @description Tax Calculator for Small Business
 * @author Copado Test Agent
 * @date 2025
 */
public with sharing class TaxCalculator {
    
    // Tax rate constants
    public static final Decimal STANDARD_TAX_RATE = 0.0875; // 8.75%
    public static final Decimal LUXURY_TAX_RATE = 0.15;     // 15%
    public static final Decimal SERVICE_TAX_RATE = 0.06;    // 6%
    public static final Decimal TAX_EXEMPT_THRESHOLD = 100.00; // Items under $100 are exempt
    
    // Product categories
    public enum ProductCategory {
        STANDARD,
        LUXURY,
        SERVICE,
        EXEMPT
    }
    
    /**
     * @description Calculate tax for a single item
     * @param amount The item amount
     * @param category The product category
     * @return Decimal The calculated tax amount
     */
    public static Decimal calculateItemTax(Decimal amount, ProductCategory category) {
        if (amount == null || amount <= 0) {
            return 0;
        }
        
        // Tax exempt threshold check
        if (amount < TAX_EXEMPT_THRESHOLD && category != ProductCategory.LUXURY) {
            return 0;
        }
        
        switch on category {
            when STANDARD {
                return amount * STANDARD_TAX_RATE;
            }
            when LUXURY {
                return amount * LUXURY_TAX_RATE;
            }
            when SERVICE {
                return amount * SERVICE_TAX_RATE;
            }
            when EXEMPT {
                return 0;
            }
            when else {
                return amount * STANDARD_TAX_RATE;
            }
        }
    }
    
    /**
     * @description Calculate tax for multiple items
     * @param items List of TaxItem wrapper objects
     * @return TaxSummary The tax calculation summary
     */
    public static TaxSummary calculateOrderTax(List<TaxItem> items) {
        if (items == null || items.isEmpty()) {
            return new TaxSummary();
        }
        
        Decimal subtotal = 0;
        Decimal totalTax = 0;
        Map<ProductCategory, Decimal> taxByCategory = new Map<ProductCategory, Decimal>();
        
        for (TaxItem item : items) {
            if (item.amount != null && item.amount > 0) {
                subtotal += item.amount;
                Decimal itemTax = calculateItemTax(item.amount, item.category);
                totalTax += itemTax;
                
                // Track tax by category
                if (taxByCategory.containsKey(item.category)) {
                    taxByCategory.put(item.category, taxByCategory.get(item.category) + itemTax);
                } else {
                    taxByCategory.put(item.category, itemTax);
                }
            }
        }
        
        return new TaxSummary(subtotal, totalTax, taxByCategory);
    }
    
    /**
     * @description Apply discount to tax calculation
     * @param originalTax The original tax amount
     * @param discountPercent The discount percentage (0-100)
     * @return Decimal The tax amount after discount
     */
    public static Decimal applyTaxDiscount(Decimal originalTax, Decimal discountPercent) {
        if (originalTax == null || originalTax <= 0 || discountPercent == null || discountPercent <= 0) {
            return originalTax != null ? originalTax : 0;
        }
        
        if (discountPercent > 100) {
            discountPercent = 100;
        }
        
        Decimal discountAmount = originalTax * (discountPercent / 100);
        return originalTax - discountAmount;
    }
    
    /**
     * @description Check if customer is tax exempt (for non-profit organizations)
     * @param customerType The customer type
     * @return Boolean True if tax exempt
     */
    public static Boolean isCustomerTaxExempt(String customerType) {
        Set<String> exemptTypes = new Set<String>{
            'NON_PROFIT',
            'GOVERNMENT',
            'EDUCATIONAL',
            'RELIGIOUS'
        };
        
        return String.isNotBlank(customerType) && exemptTypes.contains(customerType.toUpperCase());
    }
    
    // Wrapper Classes
    public class TaxItem {
        public Decimal amount { get; set; }
        public ProductCategory category { get; set; }
        public String description { get; set; }
        
        public TaxItem(Decimal amount, ProductCategory category, String description) {
            this.amount = amount;
            this.category = category;
            this.description = description;
        }
    }
    
    public class TaxSummary {
        public Decimal subtotal { get; set; }
        public Decimal totalTax { get; set; }
        public Decimal grandTotal { get; set; }
        public Map<ProductCategory, Decimal> taxByCategory { get; set; }
        
        public TaxSummary() {
            this.subtotal = 0;
            this.totalTax = 0;
            this.grandTotal = 0;
            this.taxByCategory = new Map<ProductCategory, Decimal>();
        }
        
        public TaxSummary(Decimal subtotal, Decimal totalTax, Map<ProductCategory, Decimal> taxByCategory) {
            this.subtotal = subtotal;
            this.totalTax = totalTax;
            this.grandTotal = subtotal + totalTax;
            this.taxByCategory = taxByCategory;
        }
    }
}