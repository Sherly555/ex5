import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _salaryController = TextEditingController();
  final _existingEmiController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _newEmiController = TextEditingController(); // Assume user inputs the potential new EMI

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _salaryController.dispose();
    _existingEmiController.dispose();
    _loanAmountController.dispose();
    _newEmiController.dispose();
    super.dispose();
  }

  void _checkEligibility() {
    if (_formKey.currentState!.validate()) {
      // Input is valid, prepare data for navigation
      final Map<String, dynamic> loanData = {
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'salary': double.tryParse(_salaryController.text) ?? 0.0,
        'existingEmi': double.tryParse(_existingEmiController.text) ?? 0.0,
        'loanAmount': double.tryParse(_loanAmountController.text) ?? 0.0,
        'newEmi': double.tryParse(_newEmiController.text) ?? 0.0,
      };

      // Navigate to the result screen and pass the data
      Navigator.pushNamed(
        context,
        '/result',
        arguments: loanData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Eligibility Checker'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Age Field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age (21-60)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final age = int.tryParse(value ?? '');
                  if (age == null || age < 21 || age > 60) {
                    return 'Age must be between 21 and 60';
                  }
                  return null;
                },
              ),
              // Monthly Salary Field
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Monthly Salary'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final salary = double.tryParse(value ?? '');
                  if (salary == null || salary <= 0) {
                    return 'Please enter a valid salary';
                  }
                  return null;
                },
              ),
              // Existing EMI/Debts Field
              TextFormField(
                controller: _existingEmiController,
                decoration: const InputDecoration(labelText: 'Existing EMI/Debts (Monthly)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final emi = double.tryParse(value ?? '');
                  if (emi == null || emi < 0) {
                    return 'Please enter a valid EMI/Debt amount';
                  }
                  return null;
                },
              ),
              // Loan Amount Requested Field
              TextFormField(
                controller: _loanAmountController,
                decoration: const InputDecoration(labelText: 'Loan Amount Requested'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid loan amount';
                  }
                  return null;
                },
              ),
              // New EMI (Estimated) Field - Required for DTI calculation
              TextFormField(
                controller: _newEmiController,
                decoration: const InputDecoration(labelText: 'Estimated New Loan EMI (Monthly)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final newEmi = double.tryParse(value ?? '');
                  if (newEmi == null || newEmi <= 0) {
                    return 'Please estimate a monthly EMI for the new loan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _checkEligibility,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Check Eligibility',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
