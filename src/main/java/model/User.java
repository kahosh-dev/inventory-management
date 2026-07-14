package model;

public class User {
    private int id;
    private String fullname;
    private String username;
    private String password;
    private String email;
    private String role;
    private String status;
    private String createdAt;

    public User() {
        this.role = "User";
        this.status = "Active";
        this.fullname = "";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullname() { 
        return fullname != null && !fullname.isEmpty() ? fullname : username; 
    }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}