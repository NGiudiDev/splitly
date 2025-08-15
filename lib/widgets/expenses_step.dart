import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/person.dart';

class ExpensesStep extends StatelessWidget {
  final void Function(Expense) onRemoveExpense;
  final List<Person> people;
  final Person? selectedPerson;
  final TextEditingController amountController;
  final List<Expense> expenses;
  final VoidCallback onAddExpense;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool roundResults;
  final ValueChanged<bool?> onRoundChanged;
  final ValueChanged<Person?> onPersonChanged;

  const ExpensesStep({
    super.key,
    required this.people,
    required this.selectedPerson,
    required this.amountController,
    required this.expenses,
    required this.onAddExpense,
    required this.onPrev,
    required this.onNext,
    required this.roundResults,
    required this.onRoundChanged,
    required this.onPersonChanged,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Text(
                  'Agrega al menos un gasto.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 52,
                child: DropdownButtonFormField<Person>(
                  value: selectedPerson,
                  hint: const Text('Persona'),
                  isExpanded: true,
                  dropdownColor: theme.colorScheme.surface,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  items: people.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: onPersonChanged,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Monto',
                          prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: ElevatedButton(
                      onPressed: onAddExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expenses.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: Text('${expense.person.name} gastó ${expense.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => onRemoveExpense(expense),
                          tooltip: 'Eliminar',
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onPrev,
                        child: const Text('Atrás'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: expenses.isNotEmpty ? onNext : null,
                        child: const Text('Siguiente'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
