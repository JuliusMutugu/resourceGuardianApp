package com.resourceguardian.backend.service;

import com.resourceguardian.backend.entity.Goal;
import com.resourceguardian.backend.entity.User;
import com.resourceguardian.backend.repository.GoalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class GoalService {

    @Autowired
    private GoalRepository goalRepository;

    @Autowired
    private UserService userService;

    public Goal createGoal(Goal goal, Long userId) {
        User user = userService.findById(userId);
        goal.setUser(user);
        goal.setCreatedAt(LocalDateTime.now());
        goal.setUpdatedAt(LocalDateTime.now());

        if (goal.getProgress() == null) {
            goal.setProgress(0);
        }

        return goalRepository.save(goal);
    }

    public Goal updateGoal(Long id, Goal updatedGoal, Long userId) {
        Goal existingGoal = findByIdAndUserId(id, userId);

        // Update fields
        existingGoal.setTitle(updatedGoal.getTitle());
        existingGoal.setDescription(updatedGoal.getDescription());
        existingGoal.setCategory(updatedGoal.getCategory());
        existingGoal.setType(updatedGoal.getType());
        existingGoal.setPriority(updatedGoal.getPriority());
        existingGoal.setTargetDate(updatedGoal.getTargetDate());
        existingGoal.setProgress(updatedGoal.getProgress());
        existingGoal.setUpdatedAt(LocalDateTime.now());

        // Check if goal is completed
        if (existingGoal.getProgress() >= 100 && !existingGoal.getIsCompleted()) {
            existingGoal.setIsCompleted(true);
            existingGoal.setCompletedAt(LocalDateTime.now());
        } else if (existingGoal.getProgress() < 100 && existingGoal.getIsCompleted()) {
            existingGoal.setIsCompleted(false);
            existingGoal.setCompletedAt(null);
        }

        return goalRepository.save(existingGoal);
    }

    public Goal updateGoalProgress(Long id, Integer progress, Long userId) {
        Goal goal = findByIdAndUserId(id, userId);

        goal.setProgress(Math.min(progress, 100)); // Cap at 100%
        goal.setUpdatedAt(LocalDateTime.now());

        // Check if goal is completed
        if (goal.getProgress() >= 100 && !goal.getIsCompleted()) {
            goal.setIsCompleted(true);
            goal.setCompletedAt(LocalDateTime.now());
        } else if (goal.getProgress() < 100 && goal.getIsCompleted()) {
            goal.setIsCompleted(false);
            goal.setCompletedAt(null);
        }

        return goalRepository.save(goal);
    }

    public void deleteGoal(Long id, Long userId) {
        Goal goal = findByIdAndUserId(id, userId);
        goalRepository.delete(goal);
    }

    public Goal findByIdAndUserId(Long id, Long userId) {
        return goalRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new RuntimeException("Goal not found"));
    }

    public Optional<Goal> findById(Long id) {
        return goalRepository.findById(id);
    }

    public List<Goal> findByUserId(Long userId) {
        return goalRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Page<Goal> findByUserId(Long userId, Pageable pageable) {
        return goalRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    public List<Goal> findActiveByUserId(Long userId) {
        return goalRepository.findByUserIdAndIsCompletedFalseOrderByPriorityDesc(userId);
    }

    public List<Goal> findCompletedByUserId(Long userId) {
        return goalRepository.findByUserIdAndIsCompletedTrueOrderByCompletedAtDesc(userId);
    }

    public List<Goal> findByCategory(String category, Long userId) {
        return goalRepository.findByUserIdAndCategoryOrderByCreatedAtDesc(userId, category);
    }

    public List<Goal> findByType(String type, Long userId) {
        return goalRepository.findByUserIdAndTypeOrderByCreatedAtDesc(userId, type);
    }

    public List<Goal> findOverdueGoals(Long userId) {
        return goalRepository.findOverdueGoals(userId, LocalDateTime.now());
    }

    public List<Goal> findGoalsByDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        return goalRepository.findGoalsByDateRange(userId, startDate, endDate);
    }

    public List<Goal> findGoalsByMinProgress(Long userId, Integer minProgress) {
        return goalRepository.findGoalsByMinProgress(userId, minProgress);
    }

    public long getCompletedGoalsCount(Long userId) {
        return goalRepository.countByUserIdAndIsCompletedTrue(userId);
    }

    public long getActiveGoalsCount(Long userId) {
        return goalRepository.countByUserIdAndIsCompletedFalse(userId);
    }

    public Goal completeGoal(Long id, Long userId) {
        Goal goal = findByIdAndUserId(id, userId);
        goal.setIsCompleted(true);
        goal.setProgress(100);
        goal.setCompletedAt(LocalDateTime.now());
        goal.setUpdatedAt(LocalDateTime.now());
        return goalRepository.save(goal);
    }

    public Goal reopenGoal(Long id, Long userId) {
        Goal goal = findByIdAndUserId(id, userId);
        goal.setIsCompleted(false);
        goal.setCompletedAt(null);
        goal.setUpdatedAt(LocalDateTime.now());
        return goalRepository.save(goal);
    }

    public double getAverageProgress(Long userId) {
        List<Goal> goals = findActiveByUserId(userId);
        if (goals.isEmpty()) {
            return 0.0;
        }

        double totalProgress = goals.stream()
                .mapToInt(Goal::getProgress)
                .average()
                .orElse(0.0);

        return totalProgress;
    }

    public List<Goal> findGoalsNearingDeadline(Long userId, int daysAhead) {
        LocalDateTime deadline = LocalDateTime.now().plusDays(daysAhead);
        return goalRepository.findGoalsByDateRange(userId, LocalDateTime.now(), deadline)
                .stream()
                .filter(goal -> !goal.getIsCompleted())
                .collect(java.util.stream.Collectors.toList());
    }
}
