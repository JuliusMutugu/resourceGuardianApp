package main.java.com.resourceguardian.backend.repository;

import main.java.com.resourceguardian.backend.entity.SavingsGoal;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SavingsGoalRepository extends JpaRepository<SavingsGoal, Long> {
    
    Optional<SavingsGoal> findByIdAndUserId(Long id, Long userId);
    
    List<SavingsGoal> findByUserId(Long userId);
    
    List<SavingsGoal> findByUserIdOrderByCreatedAtDesc(Long userId);
    
    Page<SavingsGoal> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);
    
    List<SavingsGoal> findByUserIdAndIsCompletedFalseOrderByPriorityDesc(Long userId);
    
    List<SavingsGoal> findByUserIdAndIsCompletedTrueOrderByCompletedAtDesc(Long userId);
    
    List<SavingsGoal> findByUserIdAndCategoryOrderByCreatedAtDesc(Long userId, String category);
    
    long countByUserIdAndIsCompletedTrue(Long userId);
    
    long countByUserIdAndIsCompletedFalse(Long userId);
    
    List<SavingsGoal> findByUserIdAndIsTimeLockedTrueAndTimeLockedUntilAfter(Long userId, LocalDateTime now);
    
    @Query("SELECT sg FROM SavingsGoal sg WHERE sg.user.id = :userId AND sg.targetDate < :date AND sg.isCompleted = false")
    List<SavingsGoal> findOverdueGoals(@Param("userId") Long userId, @Param("date") LocalDateTime date);
    
    @Query("SELECT sg FROM SavingsGoal sg WHERE sg.user.id = :userId AND sg.targetDate BETWEEN :startDate AND :endDate")
    List<SavingsGoal> findGoalsByDateRange(@Param("userId") Long userId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
