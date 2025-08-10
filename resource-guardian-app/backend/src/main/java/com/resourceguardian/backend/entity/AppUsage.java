package main.java.com.resourceguardian.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

@Entity
@Table(name = "app_usage")
public class AppUsage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(name = "app_name")
    private String appName;

    @NotBlank
    @Column(name = "package_name")
    private String packageName;

    @NotNull
    private Integer duration; // in minutes

    @NotNull
    @Column(name = "usage_date")
    private LocalDateTime usageDate = LocalDateTime.now();

    @NotNull
    @Enumerated(EnumType.STRING)
    private AppCategory category;

    private Boolean blocked = false;

    @Column(name = "warning_shown")
    private Boolean warningShown = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Constructors
    public AppUsage() {
    }

    public AppUsage(String appName, String packageName, Integer duration, AppCategory category, User user) {
        this.appName = appName;
        this.packageName = packageName;
        this.duration = duration;
        this.category = category;
        this.user = user;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public LocalDateTime getUsageDate() {
        return usageDate;
    }

    public void setUsageDate(LocalDateTime usageDate) {
        this.usageDate = usageDate;
    }

    public AppCategory getCategory() {
        return category;
    }

    public void setCategory(AppCategory category) {
        this.category = category;
    }

    public Boolean getBlocked() {
        return blocked;
    }

    public void setBlocked(Boolean blocked) {
        this.blocked = blocked;
    }

    public Boolean getWarningShown() {
        return warningShown;
    }

    public void setWarningShown(Boolean warningShown) {
        this.warningShown = warningShown;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // Enums
    public enum AppCategory {
        SOCIAL_MEDIA, PRODUCTIVE, ENTERTAINMENT, EDUCATION, OTHER
    }
}
