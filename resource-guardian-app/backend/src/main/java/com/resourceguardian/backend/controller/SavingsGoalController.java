package com.resourceguardian.backend.controller;

import com.resourceguardian.backend.entity.SavingsGoal;
import com.resourceguardian.backend.security.JwtUserDetailsService;
import com.resourceguardian.backend.service.SavingsGoalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/savings-goals")
@CrossOrigin(origins = "*")
public class SavingsGoalController {

    @Autowired
    private SavingsGoalService savingsGoalService;

    @PostMapping
    public ResponseEntity<SavingsGoal> createSavingsGoal(
            @Valid @RequestBody SavingsGoal savingsGoal,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        SavingsGoal createdGoal = savingsGoalService.createSavingsGoal(savingsGoal, userPrincipal.getUserId());
        return ResponseEntity.ok(createdGoal);
    }

    @GetMapping
    public ResponseEntity<Page<SavingsGoal>> getSavingsGoals(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<SavingsGoal> goals = savingsGoalService.findByUserId(userPrincipal.getUserId(), pageable);
        return ResponseEntity.ok(goals);
    }

    @GetMapping("/{id}")
    public ResponseEntity<SavingsGoal> getSavingsGoal(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        SavingsGoal goal = savingsGoalService.findByIdAndUserId(id, userPrincipal.getUserId());
        return ResponseEntity.ok(goal);
    }

    @PutMapping("/{id}")
    public ResponseEntity<SavingsGoal> updateSavingsGoal(
            @PathVariable Long id,
            @Valid @RequestBody SavingsGoal savingsGoal,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        SavingsGoal updatedGoal = savingsGoalService.updateSavingsGoal(id, savingsGoal, userPrincipal.getUserId());
        return ResponseEntity.ok(updatedGoal);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSavingsGoal(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        savingsGoalService.deleteSavingsGoal(id, userPrincipal.getUserId());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/add")
    public ResponseEntity<SavingsGoal> addToSavingsGoal(
            @PathVariable Long id,
            @RequestBody Map<String, BigDecimal> request,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        BigDecimal amount = request.get("amount");
        SavingsGoal updatedGoal = savingsGoalService.addToSavingsGoal(id, amount, userPrincipal.getUserId());
        return ResponseEntity.ok(updatedGoal);
    }

    @PostMapping("/{id}/withdraw")
    public ResponseEntity<SavingsGoal> withdrawFromSavingsGoal(
            @PathVariable Long id,
            @RequestBody Map<String, BigDecimal> request,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        BigDecimal amount = request.get("amount");
        SavingsGoal updatedGoal = savingsGoalService.withdrawFromSavingsGoal(id, amount, userPrincipal.getUserId());
        return ResponseEntity.ok(updatedGoal);
    }

    @GetMapping("/active")
    public ResponseEntity<List<SavingsGoal>> getActiveSavingsGoals(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<SavingsGoal> goals = savingsGoalService.findActiveByUserId(userPrincipal.getUserId());
        return ResponseEntity.ok(goals);
    }

    @GetMapping("/completed")
    public ResponseEntity<List<SavingsGoal>> getCompletedSavingsGoals(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<SavingsGoal> goals = savingsGoalService.findCompletedByUserId(userPrincipal.getUserId());
        return ResponseEntity.ok(goals);
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<SavingsGoal>> getSavingsGoalsByCategory(
            @PathVariable String category,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<SavingsGoal> goals = savingsGoalService.findByCategory(category, userPrincipal.getUserId());
        return ResponseEntity.ok(goals);
    }

    @GetMapping("/time-locked")
    public ResponseEntity<List<SavingsGoal>> getTimeLockedSavingsGoals(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<SavingsGoal> goals = savingsGoalService.findTimeLockedGoals(userPrincipal.getUserId());
        return ResponseEntity.ok(goals);
    }

    @PostMapping("/{id}/unlock")
    public ResponseEntity<SavingsGoal> unlockTimeLockedGoal(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        SavingsGoal unlockedGoal = savingsGoalService.unlockTimeLockedGoal(id, userPrincipal.getUserId());
        return ResponseEntity.ok(unlockedGoal);
    }

    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getSavingsStatistics(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Long userId = userPrincipal.getUserId();
        Map<String, Object> statistics = Map.of(
                "totalSaved", savingsGoalService.getTotalSavedByUserId(userId),
                "totalTarget", savingsGoalService.getTotalTargetByUserId(userId),
                "completedGoalsCount", savingsGoalService.getCompletedGoalsCount(userId),
                "activeGoalsCount", savingsGoalService.getActiveGoalsCount(userId));

        return ResponseEntity.ok(statistics);
    }
}
