package com.resourceguardian.backend.repository;

import com.resourceguardian.backend.entity.Goal;
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
public interface GoalRepository extends JpaRepository<Goal, Long> {

    Optional<Goal> findByIdAndUserId(Long id, Long userId);

    List<Goal> findByUserId(Long userId);

    List<Goal> findByUserIdOrderByCreatedAtDesc(Long userId);

    Page<Goal> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);

    List<Goal> findByUserIdAndIsCompletedFalseOrderByPriorityDesc(Long userId);

    List<Goal> findByUserIdAndIsCompletedTrueOrderByCompletedAtDesc(Long userId);

    List<Goal> findByUserIdAndCategoryOrderByCreatedAtDesc(Long userId, String category);

    List<Goal> findByUserIdAndTypeOrderByCreatedAtDesc(Long userId, String type);

    long countByUserIdAndIsCompletedTrue(Long userId);

    long countByUserIdAndIsCompletedFalse(Long userId);

    @Query("SELECT g FROM Goal g WHERE g.user.id = :userId AND g.targetDate < :date AND g.isCompleted = false")
    List<Goal> findOverdueGoals(@Param("userId") Long userId, @Param("date") LocalDateTime date);

    @Query("SELECT g FROM Goal g WHERE g.user.id = :userId AND g.targetDate BETWEEN :startDate AND :endDate")
    List<Goal> findGoalsByDateRange(@Param("userId") Long userId, @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT g FROM Goal g WHERE g.user.id = :userId AND g.progress >= :minProgress")
    List<Goal> findGoalsByMinProgress(@Param("userId") Long userId, @Param("minProgress") Integer minProgress);
}
