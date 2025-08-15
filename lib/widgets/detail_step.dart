import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/person.dart';

class DetailStep extends StatelessWidget {
  final Map<Person, double> balances;
  final List<String> settlements;
  final List<Expense> expenses;

  final ValueChanged<bool?> onRoundChanged;
  final VoidCallback onPrev;
  final bool roundResults;

  const DetailStep({
    super.key,
    required this.expenses,
    required this.balances,
    required this.settlements,
    required this.onPrev,
    required this.roundResults,
    required this.onRoundChanged,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saldos', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        ListView.separated(
                          itemCount: balances.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final entry = balances.entries.elementAt(index);
                            final totalGasto = expenses
                                .where((e) => e.person == entry.key)
                                .fold(0.0, (sum, e) => sum + e.amount);
                            return ListTile(
                              leading: const Icon(Icons.price_check, color: Colors.white),
                              title: Text(
                                '${entry.key.name} gastó ${totalGasto.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Liquidación', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: roundResults,
                              onChanged: onRoundChanged,
                            ),
                            Text('Redondear resultados', style: theme.textTheme.bodyMedium),
                          ],
                        ),  
                        ListView.separated(
                          itemCount: settlements.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final s = settlements[index];
                            return ListTile(
                              leading: const Icon(Icons.compare_arrows, color: Colors.white),
                              title: Text(s, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onPrev,
                    child: const Text('Atrás'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

