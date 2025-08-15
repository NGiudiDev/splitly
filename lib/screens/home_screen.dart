import 'package:flutter/material.dart';

import '../widgets/expenses_step.dart';
import '../widgets/persons_step.dart';
import '../widgets/detail_step.dart';

import '../models/expense.dart';
import '../models/person.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  final List<Expense> _expenses = [];
  final List<Person> _people = [];

  bool _roundResults = false;
  Person? _selectedPerson;
  int _step = 0;

  void _addPerson() {
    final name = _personController.text.trim();
    
    if (name.isEmpty) return;
    
    if (_people.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ese nombre ya está en la lista.')),
      );

      return;
    }

    setState(() {
      _people.add(Person(name: name));
      _personController.clear();
    });
  }

  void _addExpense() {
    if (_selectedPerson == null || _amountController.text.isEmpty) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido.')),
      );

      return;
    }

    setState(() {
      _expenses.add(Expense(person: _selectedPerson!, amount: amount));
      _amountController.clear();
      _selectedPerson = null;
    });
  }

  Map<Person, double> _calculateBalances() {
    final Map<Person, double> balances = {for (var p in _people) p: 0.0};

    if (_people.isEmpty) return balances;
    
    final total = _expenses.fold(0.0, (sum, e) => sum + e.amount);
      
    final share = total / _people.length;
    
    for (var e in _expenses) {
      balances[e.person] = (balances[e.person] ?? 0) + e.amount;
    }
    
    for (var p in _people) {
      balances[p] = (balances[p] ?? 0) - share;

      if (_roundResults) {
        balances[p] = balances[p]!.roundToDouble();
      }
    }
    
    return balances;
  }

  List<String> _calculateSettlements(Map<Person, double> balances) {
    final creditors = <Person, double>{};
    final debtors = <Person, double>{};

    balances.forEach((person, balance) {
      if (balance < -0.01) debtors[person] = -balance;
      if (balance > 0.01) creditors[person] = balance;
    });

    final settlements = <String>[];

    while (debtors.isNotEmpty && creditors.isNotEmpty) {
      final creditor = creditors.entries.first;
      final debtor = debtors.entries.first;

      final amount = [debtor.value, creditor.value].reduce((a, b) => a < b ? a : b);
      
      final payAmount = _roundResults ? amount.roundToDouble() : double.parse(amount.toStringAsFixed(2));
      
      settlements.add('${debtor.key.name} le paga a ${creditor.key.name}: ${payAmount.toStringAsFixed(2)}');

      creditors[creditor.key] = creditor.value - payAmount;
      debtors[debtor.key] = debtor.value - payAmount;
      
      if (creditors[creditor.key]! < 0.01) creditors.remove(creditor.key);
      
      if (debtors[debtor.key]! < 0.01) debtors.remove(debtor.key);
    }

    if (settlements.isEmpty) settlements.add('Todos están a mano.');

    return settlements;
  }

  void _nextStep() {
    if (_step == 0 && _people.length < 2) return;
    
    if (_step == 1 && _expenses.isEmpty) return;
    
    setState(() {
      _step++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) {
        _step--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final balances = _calculateBalances();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_step == 0) {
                    return PersonsStep(
                      personController: _personController,
                      people: _people,
                      onAddPerson: _addPerson,
                      onNext: _nextStep,
                      onRemovePerson: (person) {
                        setState(() {
                          _people.remove(person);
                          _expenses.removeWhere((e) => e.person == person);
                        });
                      },
                    );
                  } else if (_step == 1) {
                    return ExpensesStep(
                      people: _people,
                      selectedPerson: _selectedPerson,
                      amountController: _amountController,
                      expenses: _expenses,
                      onAddExpense: _addExpense,
                      onPrev: _prevStep,
                      onNext: _nextStep,
                      roundResults: _roundResults,
                      onRoundChanged: (v) => setState(() => _roundResults = v ?? false),
                      onPersonChanged: (p) => setState(() => _selectedPerson = p),
                      onRemoveExpense: (expense) {
                        setState(() {
                          _expenses.remove(expense);
                        });
                      },
                    );
                  } else {
                    return DetailStep(
                      expenses: _expenses,
                      balances: balances,
                      settlements: _calculateSettlements(balances),
                      onPrev: _prevStep,
                      roundResults: _roundResults,
                      onRoundChanged: (v) => setState(() => _roundResults = v ?? false),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
