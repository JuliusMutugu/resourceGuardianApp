package com.resourceguardian.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 50)
    @Column(unique = true)
    private String username;

    @NotBlank
    @Size(max = 100)
    @Email
    @Column(unique = true)
    private String email;

    @Size(max = 15)
    @Column(unique = true)
    private String phoneNumber;

    @NotBlank
    @Size(max = 100)
    private String firstName;

    @NotBlank
    @Size(max = 100)
    private String lastName;

    @NotBlank
    @Size(max = 120)
    private String password;

    @Enumerated(EnumType.STRING)
    private Role role = Role.USER;

    @Enumerated(EnumType.STRING)
    private AccountStatus status = AccountStatus.ACTIVE;

    private boolean emailVerified = false;
    private boolean phoneVerified = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    // User preferences
    @Enumerated(EnumType.STRING)
    private Theme theme = Theme.LIGHT;

    @Enumerated(EnumType.STRING)
    private Language language = Language.EN;

    private String currency = "KES";
    private Double monthlyBudget = 0.0;

    // Behavior control settings
    private Integer socialMediaTimeLimit = 30; // minutes
    private Boolean contentBlockingEnabled = false;
    private Boolean strictMode = false;
    private Integer warningThreshold = 75; // percentage

    // Notification settings
    private Boolean notificationsEnabled = true;
    private Boolean motivationalQuotes = true;
    private Boolean spendingAlerts = true;
    private Boolean timeWarnings = true;
    private Boolean goalReminders = true;
    private Boolean biblicalQuotes = false;
    private Boolean philosophicalWisdom = false;

    // M-Pesa integration
    private Boolean mpesaIntegrationEnabled = false;
    private String mpesaPhoneNumber;

    // Additional status fields
    private Boolean isBlocked = false;
    private Boolean isActive = true;
    private String userType = "REGULAR";

    // Relations
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Transaction> transactions;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Goal> goals;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<AppUsage> appUsages;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<SavingsGoal> savingsGoals;

    // Constructors
    public User() {
    }

    public User(String username, String email, String firstName, String lastName, String password) {
        this.username = username;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
    }

    // UserDetails implementation
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public boolean isAccountNonExpired() {
        return status != AccountStatus.EXPIRED;
    }

    @Override
    public boolean isAccountNonLocked() {
        return status != AccountStatus.LOCKED;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return status == AccountStatus.ACTIVE;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public AccountStatus getStatus() {
        return status;
    }

    public void setStatus(AccountStatus status) {
        this.status = status;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    public boolean isPhoneVerified() {
        return phoneVerified;
    }

    public void setPhoneVerified(boolean phoneVerified) {
        this.phoneVerified = phoneVerified;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public Theme getTheme() {
        return theme;
    }

    public void setTheme(Theme theme) {
        this.theme = theme;
    }

    public Language getLanguage() {
        return language;
    }

    public void setLanguage(Language language) {
        this.language = language;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Double getMonthlyBudget() {
        return monthlyBudget;
    }

    public void setMonthlyBudget(Double monthlyBudget) {
        this.monthlyBudget = monthlyBudget;
    }

    public Integer getSocialMediaTimeLimit() {
        return socialMediaTimeLimit;
    }

    public void setSocialMediaTimeLimit(Integer socialMediaTimeLimit) {
        this.socialMediaTimeLimit = socialMediaTimeLimit;
    }

    public Boolean getContentBlockingEnabled() {
        return contentBlockingEnabled;
    }

    public void setContentBlockingEnabled(Boolean contentBlockingEnabled) {
        this.contentBlockingEnabled = contentBlockingEnabled;
    }

    public Boolean getStrictMode() {
        return strictMode;
    }

    public void setStrictMode(Boolean strictMode) {
        this.strictMode = strictMode;
    }

    public Integer getWarningThreshold() {
        return warningThreshold;
    }

    public void setWarningThreshold(Integer warningThreshold) {
        this.warningThreshold = warningThreshold;
    }

    public Boolean getNotificationsEnabled() {
        return notificationsEnabled;
    }

    public void setNotificationsEnabled(Boolean notificationsEnabled) {
        this.notificationsEnabled = notificationsEnabled;
    }

    public Boolean getMotivationalQuotes() {
        return motivationalQuotes;
    }

    public void setMotivationalQuotes(Boolean motivationalQuotes) {
        this.motivationalQuotes = motivationalQuotes;
    }

    public Boolean getSpendingAlerts() {
        return spendingAlerts;
    }

    public void setSpendingAlerts(Boolean spendingAlerts) {
        this.spendingAlerts = spendingAlerts;
    }

    public Boolean getTimeWarnings() {
        return timeWarnings;
    }

    public void setTimeWarnings(Boolean timeWarnings) {
        this.timeWarnings = timeWarnings;
    }

    public Boolean getGoalReminders() {
        return goalReminders;
    }

    public void setGoalReminders(Boolean goalReminders) {
        this.goalReminders = goalReminders;
    }

    public Boolean getBiblicalQuotes() {
        return biblicalQuotes;
    }

    public void setBiblicalQuotes(Boolean biblicalQuotes) {
        this.biblicalQuotes = biblicalQuotes;
    }

    public Boolean getPhilosophicalWisdom() {
        return philosophicalWisdom;
    }

    public void setPhilosophicalWisdom(Boolean philosophicalWisdom) {
        this.philosophicalWisdom = philosophicalWisdom;
    }

    public Boolean getMpesaIntegrationEnabled() {
        return mpesaIntegrationEnabled;
    }

    public void setMpesaIntegrationEnabled(Boolean mpesaIntegrationEnabled) {
        this.mpesaIntegrationEnabled = mpesaIntegrationEnabled;
    }

    public String getMpesaPhoneNumber() {
        return mpesaPhoneNumber;
    }

    public void setMpesaPhoneNumber(String mpesaPhoneNumber) {
        this.mpesaPhoneNumber = mpesaPhoneNumber;
    }

    public Boolean getIsBlocked() {
        return isBlocked;
    }

    public void setIsBlocked(Boolean isBlocked) {
        this.isBlocked = isBlocked;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public Set<Transaction> getTransactions() {
        return transactions;
    }

    public void setTransactions(Set<Transaction> transactions) {
        this.transactions = transactions;
    }

    public Set<Goal> getGoals() {
        return goals;
    }

    public void setGoals(Set<Goal> goals) {
        this.goals = goals;
    }

    public Set<AppUsage> getAppUsages() {
        return appUsages;
    }

    public void setAppUsages(Set<AppUsage> appUsages) {
        this.appUsages = appUsages;
    }

    public Set<SavingsGoal> getSavingsGoals() {
        return savingsGoals;
    }

    public void setSavingsGoals(Set<SavingsGoal> savingsGoals) {
        this.savingsGoals = savingsGoals;
    }

    // Enums
    public enum Role {
        USER, ADMIN
    }

    public enum AccountStatus {
        ACTIVE, LOCKED, EXPIRED, PENDING_VERIFICATION
    }

    public enum Theme {
        LIGHT, DARK, AUTO
    }

    public enum Language {
        EN, SW
    }
}
