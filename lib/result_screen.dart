import 'package:flutter/material.dart';
import 'dart:math';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve the arguments passed from InputScreen
    final Map<String, dynamic> loanData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // 2. Extract data
    final String name = loanData['name'] ?? 'N/A';
    final int age = loanData['age'] ?? 0;
    final double salary = loanData['salary'] ?? 0.0;
    final double existingEmi = loanData['existingEmi'] ?? 0.0;
    final double loanAmount = loanData['loanAmount'] ?? 0.0;
    final double newEmi = loanData['newEmi'] ?? 0.0;

    // 3. Perform Eligibility Checks and Calculations

    // --- Bank Criteria from Question 2 ---
    
    // Criterion 1: Age Check (21-60)
    final bool isAgeValid = age >= 21 && age <= 60;
    
    // Criterion 2: Loan Limit Check (Loan <= 10x Salary)
    final double maxLoanLimit = salary * 10;
    final bool isLoanLimitValid = loanAmount <= maxLoanLimit;
    
    // Criterion 3: DTI Check (DTI should not exceed 60%)
    // The formula provided in the document (x16) is ignored for a sensible percentage (x100)
    final double totalDebt = existingEmi + newEmi;
    final double dtiRatio = (salary > 0) ? (totalDebt / salary) * 100 : double.infinity;
    final bool isDtiValid = dtiRatio <= 60.0;

    // Final Eligibility Check
    final bool isEligible = isAgeValid && isLoanLimitValid && isDtiValid;

    // Prepare content for the Card
    final Color cardColor = isEligible ? Colors.green[800]! : Colors.red[800]!;
    final String eligibilityText = isEligible ? 'ELIGIBLE' : 'NOT ELIGIBLE';
    final String resultMessage = isEligible 
        ? 'Congratulations, your loan application is pre-approved!'
        : 'Unfortunately, your loan application is rejected.';

    final List<String> rejectionReasons = [];
    if (!isAgeValid) {
      rejectionReasons.add('Age ($age years) is outside the acceptable range of 21 to 60.');
    }
    if (!isLoanLimitValid) {
      rejectionReasons.add('Loan Requested (${loanAmount.toStringAsFixed(2)}) exceeds the maximum limit (10x Salary: ${maxLoanLimit.toStringAsFixed(2)}).');
    }
    if (!isDtiValid) {
      rejectionReasons.add('Debt-to-Income Ratio (${dtiRatio.toStringAsFixed(2)}%) exceeds the maximum limit of 60%.');
    }
    
    // Format Currency
    String formatCurrency(double amount) {
      return '\$${amount.toStringAsFixed(2)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligibility Result'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Required Card Widget
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: isEligible ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Eligibility Status Header
                    Center(
                      child: Text(
                        eligibilityText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: cardColor,
                        ),
                      ),
                    ),
                    const Divider(height: 30, thickness: 2),

                    // Customer Details
                    _buildDetailRow('Name', name),
                    _buildDetailRow('Age', '$age years'),
                    const SizedBox(height: 15),

                    // Financial Summary
                    _buildDetailRow('Monthly Salary', formatCurrency(salary)),
                    _buildDetailRow('Existing Debts (EMI)', formatCurrency(existingEmi)),
                    _buildDetailRow('Loan Requested', formatCurrency(loanAmount)),
                    _buildDetailRow('Estimated New EMI', formatCurrency(newEmi)),
                    const SizedBox(height: 20),
                    
                    // DTI Ratio
                    _buildDetailRow('DTI Ratio', '${dtiRatio.toStringAsFixed(2)}%', isDtiValid ? Colors.black : Colors.red),
                    
                    const Divider(height: 30, thickness: 1),

                    // Final Message and Reasons
                    Text(
                      resultMessage,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cardColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (!isEligible)
                      ...rejectionReasons.map((reason) => Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 5),
                            child: Text(
                              '• $reason',
                              style: TextStyle(color: Colors.red[800], fontSize: 14),
                            ),
                          )).toList(),
                    
                    if (isEligible)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildApprovedDetail('Approved Loan Amount:', formatCurrency(loanAmount), Colors.green),
                          _buildApprovedDetail('Approved Monthly EMI:', formatCurrency(newEmi), Colors.green),
                        ],
                      )
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Re-calculate button to go back
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Re-calculate Eligibility'),
            )
          ],
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(String label, String value, [Color valueColor = Colors.black]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  // Helper widget for approved details
  Widget _buildApprovedDetail(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}