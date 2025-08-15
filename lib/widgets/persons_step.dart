import 'package:flutter/material.dart';

import '../models/person.dart';

class PersonsStep extends StatefulWidget {
  final void Function(Person) onRemovePerson;
  final TextEditingController personController;
  final VoidCallback onAddPerson;
  final VoidCallback onNext;
  final List<Person> people;

  const PersonsStep({
    super.key,
    required this.personController,
    required this.people,
    required this.onAddPerson,
    required this.onNext,
    required this.onRemovePerson,
  });

  @override
  State<PersonsStep> createState() => _PersonsStepState();
}

class _PersonsStepState extends State<PersonsStep> {
  late ValueNotifier<String> _nameValue;

  @override
  void initState() {
    super.initState();
    _nameValue = ValueNotifier(widget.personController.text);
    widget.personController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _nameValue.value = widget.personController.text;
  }

  @override
  void dispose() {
    widget.personController.removeListener(_onTextChanged);
    _nameValue.dispose();
    super.dispose();
  }

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
                  'Agrega al menos dos personas que participarán en la división de los gastos.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.personController,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Nombre de la persona',
                          prefixIcon: const Icon(Icons.person, color: Colors.white),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: _nameValue,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          onPressed: value.trim().isNotEmpty ? widget.onAddPerson : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: value.trim().isNotEmpty ? theme.colorScheme.primary : Colors.grey[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                          child: const Icon(Icons.add, size: 28),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.people.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final person = widget.people[index];

                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: Text(person.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => widget.onRemovePerson(person),
                          tooltip: 'Eliminar',
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.people.length >= 2 ? widget.onNext : null,
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