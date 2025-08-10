package main.java.com.resourceguardian.backend.controller;

import main.java.com.resourceguardian.backend.entity.Transaction;
import main.java.com.resourceguardian.backend.security.JwtUserDetailsService;
import main.java.com.resourceguardian.backend.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/transactions")
@CrossOrigin(origins = "*")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @PostMapping
    public ResponseEntity<Transaction> createTransaction(
            @Valid @RequestBody Transaction transaction,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Transaction createdTransaction = transactionService.createTransaction(transaction, userPrincipal.getUserId());
        return ResponseEntity.ok(createdTransaction);
    }

    @GetMapping
    public ResponseEntity<Page<Transaction>> getTransactions(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Transaction> transactions = transactionService.findByUserId(userPrincipal.getUserId(), pageable);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Transaction> getTransaction(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Transaction transaction = transactionService.findByIdAndUserId(id, userPrincipal.getUserId());
        return ResponseEntity.ok(transaction);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Transaction> updateTransaction(
            @PathVariable Long id,
            @Valid @RequestBody Transaction transaction,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Transaction updatedTransaction = transactionService.updateTransaction(id, transaction,
                userPrincipal.getUserId());
        return ResponseEntity.ok(updatedTransaction);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTransaction(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        transactionService.deleteTransaction(id, userPrincipal.getUserId());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<Transaction>> getTransactionsByCategory(
            @PathVariable String category,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.findByCategory(category, userPrincipal.getUserId());
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<List<Transaction>> getTransactionsByType(
            @PathVariable String type,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.findByType(type, userPrincipal.getUserId());
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/date-range")
    public ResponseEntity<List<Transaction>> getTransactionsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.findByDateRange(userPrincipal.getUserId(), startDate,
                endDate);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/amount-range")
    public ResponseEntity<List<Transaction>> getTransactionsByAmountRange(
            @RequestParam BigDecimal minAmount,
            @RequestParam BigDecimal maxAmount,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.findByAmountRange(userPrincipal.getUserId(), minAmount,
                maxAmount);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/search")
    public ResponseEntity<List<Transaction>> searchTransactions(
            @RequestParam String query,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.searchTransactions(userPrincipal.getUserId(), query);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getTransactionStatistics(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Map<String, Object> statistics = transactionService.getTransactionStatistics(userPrincipal.getUserId());
        return ResponseEntity.ok(statistics);
    }

    @GetMapping("/monthly-summary")
    public ResponseEntity<Map<String, Object>> getMonthlySummary(
            @RequestParam int year,
            @RequestParam int month,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Map<String, Object> summary = transactionService.getMonthlySummary(userPrincipal.getUserId(), year, month);
        return ResponseEntity.ok(summary);
    }

    @GetMapping("/category-summary")
    public ResponseEntity<Map<String, BigDecimal>> getCategorySummary(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {

        Map<String, BigDecimal> summary = transactionService.getCategorySummary(userPrincipal.getUserId(), startDate,
                endDate);
        return ResponseEntity.ok(summary);
    }

    @PostMapping("/mpesa")
    public ResponseEntity<Transaction> createMpesaTransaction(
            @Valid @RequestBody Map<String, Object> mpesaData,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Transaction transaction = transactionService.createMpesaTransaction(mpesaData, userPrincipal.getUserId());
        return ResponseEntity.ok(transaction);
    }

    @GetMapping("/recent")
    public ResponseEntity<List<Transaction>> getRecentTransactions(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal,
            @RequestParam(defaultValue = "10") int limit) {

        List<Transaction> transactions = transactionService.findRecentTransactions(userPrincipal.getUserId(), limit);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/pending")
    public ResponseEntity<List<Transaction>> getPendingTransactions(
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        List<Transaction> transactions = transactionService.findPendingTransactions(userPrincipal.getUserId());
        return ResponseEntity.ok(transactions);
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Transaction> updateTransactionStatus(
            @PathVariable Long id,
            @RequestParam String status,
            @AuthenticationPrincipal JwtUserDetailsService.UserPrincipal userPrincipal) {

        Transaction transaction = transactionService.updateTransactionStatus(id, status, userPrincipal.getUserId());
        return ResponseEntity.ok(transaction);
    }
}
