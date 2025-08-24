package com.resourceguardian.backend.service;

import com.resourceguardian.backend.entity.SavingsGoal;
import com.resourceguardian.backend.entity.User;
import com.resourceguardian.backend.repository.SavingsGoalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class SavingsGoalService {

    @Autowired
    private SavingsGoalRepository savingsGoalRepository;

    @Autowired
    private UserService userService;

    public SavingsGoal createSavingsGoal(SavingsGoal savingsGoal, Long userId) {
        User user = userService.findById(userId);
        savingsGoal.setUser(user);
        savingsGoal.setCreatedAt(LocalDateTime.now());
        savingsGoal.setUpdatedAt(LocalDateTime.now());

        if (savingsGoal.getCurrentAmount() == null) {
            savingsGoal.setCurrentAmount(BigDecimal.ZERO);
        }

        return savingsGoalRepository.save(savingsGoal);
    }

    public SavingsGoal updateSavingsGoal(Long id, SavingsGoal updatedGoal, Long userId) {
        SavingsGoal existingGoal = findByIdAndUserId(id, userId);

        // Update fields
        existingGoal.setName(updatedGoal.getName());
        existingGoal.setDescription(updatedGoal.getDescription());
        existingGoal.setTargetAmount(updatedGoal.getTargetAmount());
        existingGoal.setTargetDate(updatedGoal.getTargetDate());
        existingGoal.setPriority(updatedGoal.getPriority());
        existingGoal.setCategory(updatedGoal.getCategory());
        existingGoal.setIsTimeLocked(updatedGoal.getIsTimeLocked());
        existingGoal.setTimeLockedUntil(updatedGoal.getTimeLockedUntil());
        existingGoal.setUpdatedAt(LocalDateTime.now());

        return savingsGoalRepository.save(existingGoal);
    }

    public SavingsGoal addToSavingsGoal(Long id, BigDecimal amount, Long userId) {
        SavingsGoal goal = findByIdAndUserId(id, userId);

        if (goal.getIsTimeLocked() && goal.getTimeLockedUntil() != null &&
                LocalDateTime.now().isBefore(goal.getTimeLockedUntil())) {
            throw new IllegalStateException(
                    "Cannot modify time-locked savings goal until: " + goal.getTimeLockedUntil());
        }

        BigDecimal newAmount = goal.getCurrentAmount().add(amount);
        goal.setCurrentAmount(newAmount);
        goal.setUpdatedAt(LocalDateTime.now());

        // Check if goal is completed
        if (newAmount.compareTo(goal.getTargetAmount()) >= 0) {
            goal.setIsCompleted(true);
            goal.setCompletedAt(LocalDateTime.now());
        }

        return savingsGoalRepository.save(goal);
    }

    public SavingsGoal withdrawFromSavingsGoal(Long id, BigDecimal amount, Long userId) {
        SavingsGoal goal = findByIdAndUserId(id, userId);

        if (goal.getIsTimeLocked() && goal.getTimeLockedUntil() != null &&
                LocalDateTime.now().isBefore(goal.getTimeLockedUntil())) {
            throw new IllegalStateException(
                    "Cannot withdraw from time-locked savings goal until: " + goal.getTimeLockedUntil());
        }

        if (goal.getCurrentAmount().compareTo(amount) < 0) {
            throw new IllegalArgumentException("Insufficient funds in savings goal");
        }

        BigDecimal newAmount = goal.getCurrentAmount().subtract(amount);
        goal.setCurrentAmount(newAmount);
        goal.setUpdatedAt(LocalDateTime.now());

        // If goal was completed but now below target, mark as incomplete
        if (goal.getIsCompleted() && newAmount.compareTo(goal.getTargetAmount()) < 0) {
            goal.setIsCompleted(false);
            goal.setCompletedAt(null);
        }

        return savingsGoalRepository.save(goal);
    }

    public void deleteSavingsGoal(Long id, Long userId) {
        SavingsGoal goal = findByIdAndUserId(id, userId);

        if (goal.getIsTimeLocked() && goal.getTimeLockedUntil() != null &&
                LocalDateTime.now().isBefore(goal.getTimeLockedUntil())) {
            throw new IllegalStateException(
                    "Cannot delete time-locked savings goal until: " + goal.getTimeLockedUntil());
        }

        savingsGoalRepository.delete(goal);
    }

    public SavingsGoal findByIdAndUserId(Long id, Long userId) {
        return savingsGoalRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new RuntimeException("Savings goal not found"));
    }

    public Optional<SavingsGoal> findById(Long id) {
        return savingsGoalRepository.findById(id);
    }

    public List<SavingsGoal> findByUserId(Long userId) {
        return savingsGoalRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Page<SavingsGoal> findByUserId(Long userId, Pageable pageable) {
        return savingsGoalRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    public List<SavingsGoal> findActiveByUserId(Long userId) {
        return savingsGoalRepository.findByUserIdAndIsCompletedFalseOrderByPriorityDesc(userId);
    }

    public List<SavingsGoal> findCompletedByUserId(Long userId) {
        return savingsGoalRepository.findByUserIdAndIsCompletedTrueOrderByCompletedAtDesc(userId);
    }

    public List<SavingsGoal> findByCategory(String category, Long userId) {
        return savingsGoalRepository.findByUserIdAndCategoryOrderByCreatedAtDesc(userId, category);
    }

    public BigDecimal getTotalSavedByUserId(Long userId) {
        return savingsGoalRepository.findByUserId(userId)
                .stream()
                .map(SavingsGoal::getCurrentAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal getTotalTargetByUserId(Long userId) {
        return savingsGoalRepository.findByUserId(userId)
                .stream()
                .filter(goal -> !goal.getIsCompleted())
                .map(SavingsGoal::getTargetAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public long getCompletedGoalsCount(Long userId) {
        return savingsGoalRepository.countByUserIdAndIsCompletedTrue(userId);
    }

    public long getActiveGoalsCount(Long userId) {
        return savingsGoalRepository.countByUserIdAndIsCompletedFalse(userId);
    }

    public List<SavingsGoal> findTimeLockedGoals(Long userId) {
        return savingsGoalRepository.findByUserIdAndIsTimeLockedTrueAndTimeLockedUntilAfter(userId,
                LocalDateTime.now());
    }

    public SavingsGoal unlockTimeLockedGoal(Long id, Long userId) {
        SavingsGoal goal = findByIdAndUserId(id, userId);

        if (!goal.getIsTimeLocked()) {
            throw new IllegalStateException("Goal is not time-locked");
        }

        if (goal.getTimeLockedUntil() != null && LocalDateTime.now().isBefore(goal.getTimeLockedUntil())) {
            throw new IllegalStateException("Goal cannot be unlocked until: " + goal.getTimeLockedUntil());
        }

        goal.setIsTimeLocked(false);
        goal.setTimeLockedUntil(null);
        goal.setUpdatedAt(LocalDateTime.now());

        return savingsGoalRepository.save(goal);
    }
}
