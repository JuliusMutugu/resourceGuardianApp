package main.java.com.resourceguardian.backend.service;

import main.java.com.resourceguardian.backend.entity.Transaction;
import main.java.com.resourceguardian.backend.entity.User;
import main.java.com.resourceguardian.backend.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private UserService userService;

    public Transaction createTransaction(Transaction transaction, Long userId) {
        User user = userService.findById(userId);
        transaction.setUser(user);
        transaction.setCreatedAt(LocalDateTime.now());
        transaction.setUpdatedAt(LocalDateTime.now());

        if (transaction.getStatus() == null) {
            transaction.setStatus("COMPLETED");
        }

        return transactionRepository.save(transaction);
    }

    public Transaction updateTransaction(Long id, Transaction updatedTransaction, Long userId) {
        Transaction existingTransaction = findByIdAndUserId(id, userId);

        // Update fields
        existingTransaction.setAmount(updatedTransaction.getAmount());
        existingTransaction.setDescription(updatedTransaction.getDescription());
        existingTransaction.setCategory(updatedTransaction.getCategory());
        existingTransaction.setType(updatedTransaction.getType());
        existingTransaction.setStatus(updatedTransaction.getStatus());
        existingTransaction.setMerchant(updatedTransaction.getMerchant());
        existingTransaction.setLocation(updatedTransaction.getLocation());
        existingTransaction.setNotes(updatedTransaction.getNotes());
        existingTransaction.setUpdatedAt(LocalDateTime.now());

        return transactionRepository.save(existingTransaction);
    }

    public void deleteTransaction(Long id, Long userId) {
        Transaction transaction = findByIdAndUserId(id, userId);
        transactionRepository.delete(transaction);
    }

    public Transaction findByIdAndUserId(Long id, Long userId) {
        return transactionRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));
    }

    public Optional<Transaction> findById(Long id) {
        return transactionRepository.findById(id);
    }

    public List<Transaction> findByUserId(Long userId) {
        return transactionRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Page<Transaction> findByUserId(Long userId, Pageable pageable) {
        return transactionRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    public List<Transaction> findByCategory(String category, Long userId) {
        Transaction.ExpenseCategory expenseCategory = Transaction.ExpenseCategory.valueOf(category);
        return transactionRepository.findByUserIdAndCategoryOrderByCreatedAtDesc(userId, expenseCategory);
    }

    public List<Transaction> findByType(String type, Long userId) {
        Transaction.TransactionType transactionType = Transaction.TransactionType.valueOf(type);
        return transactionRepository.findByUserIdAndTypeOrderByCreatedAtDesc(userId, transactionType);
    }

    public List<Transaction> findByDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        return transactionRepository.findByUserIdAndCreatedAtBetweenOrderByCreatedAtDesc(userId, startDate, endDate);
    }

    public List<Transaction> findByAmountRange(Long userId, BigDecimal minAmount, BigDecimal maxAmount) {
        return transactionRepository.findByUserIdAndAmountBetweenOrderByCreatedAtDesc(userId, minAmount, maxAmount);
    }

    public List<Transaction> searchTransactions(Long userId, String query) {
        return transactionRepository
                .findByUserIdAndDescriptionContainingIgnoreCaseOrMerchantContainingIgnoreCaseOrderByCreatedAtDesc(
                        userId, query, query);
    }

    public List<Transaction> findRecentTransactions(Long userId, int limit) {
        return transactionRepository.findByUserIdOrderByCreatedAtDesc(userId)
                .stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    public List<Transaction> findPendingTransactions(Long userId) {
        return transactionRepository.findByUserIdAndStatusOrderByCreatedAtDesc(userId, "PENDING");
    }

    public Transaction updateTransactionStatus(Long id, String status, Long userId) {
        Transaction transaction = findByIdAndUserId(id, userId);
        transaction.setStatus(status);
        transaction.setUpdatedAt(LocalDateTime.now());
        return transactionRepository.save(transaction);
    }

    public Map<String, Object> getTransactionStatistics(Long userId) {
        List<Transaction> transactions = findByUserId(userId);

        Map<String, Object> statistics = new HashMap<>();

        // Total transactions
        statistics.put("totalTransactions", transactions.size());

        // Total amount by type
        BigDecimal totalIncome = transactions.stream()
                .filter(t -> "INCOME".equals(t.getType()))
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalExpense = transactions.stream()
                .filter(t -> "EXPENSE".equals(t.getType()))
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        statistics.put("totalIncome", totalIncome);
        statistics.put("totalExpense", totalExpense);
        statistics.put("netBalance", totalIncome.subtract(totalExpense));

        // Transactions by category
        Map<String, Long> categoryCount = transactions.stream()
                .collect(Collectors.groupingBy(t -> t.getCategory().name(), Collectors.counting()));
        statistics.put("transactionsByCategory", categoryCount);

        // Average transaction amount
        BigDecimal averageAmount = transactions.stream()
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .divide(BigDecimal.valueOf(transactions.size()), 2, BigDecimal.ROUND_HALF_UP);
        statistics.put("averageTransactionAmount", averageAmount);

        return statistics;
    }

    public Map<String, Object> getMonthlySummary(Long userId, int year, int month) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDateTime startDate = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDate = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        List<Transaction> transactions = findByDateRange(userId, startDate, endDate);

        Map<String, Object> summary = new HashMap<>();

        BigDecimal totalIncome = transactions.stream()
                .filter(t -> "INCOME".equals(t.getType()))
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalExpense = transactions.stream()
                .filter(t -> "EXPENSE".equals(t.getType()))
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        summary.put("month", yearMonth.toString());
        summary.put("totalIncome", totalIncome);
        summary.put("totalExpense", totalExpense);
        summary.put("netBalance", totalIncome.subtract(totalExpense));
        summary.put("transactionCount", transactions.size());

        // Category breakdown
        Map<String, BigDecimal> categoryBreakdown = transactions.stream()
                .collect(Collectors.groupingBy(
                        t -> t.getCategory().name(),
                        Collectors.reducing(BigDecimal.ZERO, Transaction::getAmount, BigDecimal::add)));
        summary.put("categoryBreakdown", categoryBreakdown);

        return summary;
    }

    public Map<String, BigDecimal> getCategorySummary(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        List<Transaction> transactions;

        if (startDate != null && endDate != null) {
            transactions = findByDateRange(userId, startDate, endDate);
        } else {
            transactions = findByUserId(userId);
        }

        return transactions.stream()
                .collect(Collectors.groupingBy(
                        t -> t.getCategory().name(),
                        Collectors.reducing(BigDecimal.ZERO, Transaction::getAmount, BigDecimal::add)));
    }

    public Transaction createMpesaTransaction(Map<String, Object> mpesaData, Long userId) {
        Transaction transaction = new Transaction();
        transaction.setAmount(new BigDecimal(mpesaData.get("amount").toString()));
        transaction.setDescription("M-Pesa Transaction");
        transaction.setType(Transaction.TransactionType.EXPENSE); // Default for M-Pesa payments
        transaction.setCategory(Transaction.ExpenseCategory.OTHER);
        transaction.setStatus("COMPLETED");

        // M-Pesa specific fields
        transaction.setMpesaReceiptNumber(mpesaData.get("receiptNumber").toString());
        transaction.setMpesaTransactionId(mpesaData.get("transactionId").toString());
        transaction.setRecipientPhone(mpesaData.get("recipientPhone").toString());

        if (mpesaData.containsKey("merchant")) {
            transaction.setMerchant(mpesaData.get("merchant").toString());
        }

        return createTransaction(transaction, userId);
    }

    public BigDecimal getTotalIncomeByUserId(Long userId) {
        return transactionRepository.findByUserIdAndType(userId, Transaction.TransactionType.INCOME)
                .stream()
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal getTotalExpenseByUserId(Long userId) {
        return transactionRepository.findByUserIdAndType(userId, Transaction.TransactionType.EXPENSE)
                .stream()
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public long getTransactionCountByUserId(Long userId) {
        return transactionRepository.countByUserId(userId);
    }
}
