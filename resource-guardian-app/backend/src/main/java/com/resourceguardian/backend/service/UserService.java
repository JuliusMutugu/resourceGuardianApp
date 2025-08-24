package com.resourceguardian.backend.service;

import com.resourceguardian.backend.entity.User;
import com.resourceguardian.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Transactional
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsernameOrEmailOrPhone(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        // Update last login
        user.setLastLogin(LocalDateTime.now());
        userRepository.save(user);

        return user;
    }

    public User createUser(User user) {
        // Check if user already exists
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username already exists!");
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already exists!");
        }
        if (user.getPhoneNumber() != null && userRepository.existsByPhoneNumber(user.getPhoneNumber())) {
            throw new RuntimeException("Phone number already exists!");
        }

        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Set default values
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        user.setRole(User.Role.USER);
        user.setStatus(User.AccountStatus.PENDING_VERIFICATION);

        return userRepository.save(user);
    }

    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User updateUser(User user) {
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    public boolean existsByPhoneNumber(String phoneNumber) {
        return userRepository.existsByPhoneNumber(phoneNumber);
    }

    public User updateUserPreferences(Long userId, User.Theme theme, User.Language language,
            String currency, Double monthlyBudget) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setTheme(theme);
        user.setLanguage(language);
        user.setCurrency(currency);
        user.setMonthlyBudget(monthlyBudget);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public User updateBehaviorSettings(Long userId, Integer socialMediaTimeLimit,
            Boolean contentBlockingEnabled, Boolean strictMode,
            Integer warningThreshold) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setSocialMediaTimeLimit(socialMediaTimeLimit);
        user.setContentBlockingEnabled(contentBlockingEnabled);
        user.setStrictMode(strictMode);
        user.setWarningThreshold(warningThreshold);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public User updateNotificationSettings(Long userId, Boolean notificationsEnabled,
            Boolean motivationalQuotes, Boolean spendingAlerts,
            Boolean timeWarnings, Boolean goalReminders,
            Boolean biblicalQuotes, Boolean philosophicalWisdom) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setNotificationsEnabled(notificationsEnabled);
        user.setMotivationalQuotes(motivationalQuotes);
        user.setSpendingAlerts(spendingAlerts);
        user.setTimeWarnings(timeWarnings);
        user.setGoalReminders(goalReminders);
        user.setBiblicalQuotes(biblicalQuotes);
        user.setPhilosophicalWisdom(philosophicalWisdom);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public User verifyEmail(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEmailVerified(true);
        if (user.getStatus() == User.AccountStatus.PENDING_VERIFICATION) {
            user.setStatus(User.AccountStatus.ACTIVE);
        }
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public User verifyPhone(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPhoneVerified(true);
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public Long countActiveUsers() {
        return userRepository.countActiveUsers();
    }
}
