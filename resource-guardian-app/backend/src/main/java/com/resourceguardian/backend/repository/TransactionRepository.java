package com.resourceguardian.backend.repository;

import com.resourceguardian.backend.entity.Transaction;
import com.resourceguardian.backend.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    Page<Transaction> findByUserOrderByTransactionDateDesc(User user, Pageable pageable);

    List<Transaction> findByUserAndTransactionDateBetween(User user, LocalDateTime start, LocalDateTime end);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user = :user AND t.type = 'EXPENSE' AND t.transactionDate BETWEEN :start AND :end")
    BigDecimal getTotalExpensesByUserAndDateRange(@Param("user") User user, @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user = :user AND t.type = 'INCOME' AND t.transactionDate BETWEEN :start AND :end")
    BigDecimal getTotalIncomeByUserAndDateRange(@Param("user") User user, @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    @Query("SELECT t.category, SUM(t.amount) FROM Transaction t WHERE t.user = :user AND t.type = 'EXPENSE' AND t.transactionDate BETWEEN :start AND :end GROUP BY t.category")
    List<Object[]> getExpensesByCategory(@Param("user") User user, @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    List<Transaction> findByUserAndMpesaCodeIsNotNull(User user);

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.user = :user AND t.transactionDate BETWEEN :start AND :end")
    Long countTransactionsByUserAndDateRange(@Param("user") User user, @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    // Additional methods needed by TransactionService
    Optional<Transaction> findByIdAndUserId(Long id, Long userId);

    List<Transaction> findByUserIdOrderByCreatedAtDesc(Long userId);

    Page<Transaction> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);

    List<Transaction> findByUserIdAndCategoryOrderByCreatedAtDesc(Long userId, Transaction.ExpenseCategory category);

    List<Transaction> findByUserIdAndTypeOrderByCreatedAtDesc(Long userId, Transaction.TransactionType type);

    List<Transaction> findByUserIdAndCreatedAtBetweenOrderByCreatedAtDesc(Long userId, LocalDateTime start,
            LocalDateTime end);

    List<Transaction> findByUserIdAndAmountBetweenOrderByCreatedAtDesc(Long userId, BigDecimal minAmount,
            BigDecimal maxAmount);

    List<Transaction> findByUserIdAndDescriptionContainingIgnoreCaseOrMerchantContainingIgnoreCaseOrderByCreatedAtDesc(
            Long userId, String description, String merchant);

    List<Transaction> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, String status);

    List<Transaction> findByUserIdAndType(Long userId, Transaction.TransactionType type);

    Long countByUserId(Long userId);
}
