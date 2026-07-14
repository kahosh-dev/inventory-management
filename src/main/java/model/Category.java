package model;

public class Category {
    private int categoryId;
    private String categoryName;
    private String createdAt;
    private String updatedAt;
    private int productCount;
    
    public Category() {
        // Default constructor
    }
    
    public Category(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }
    
    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public int getProductCount() {
        return productCount;
    }
    
    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
}