import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import '../bloc/visit_plan_bloc.dart';
import '../bloc/visit_plan_event.dart';
import '../bloc/visit_plan_state.dart';
import '../widgets/visit_plan_item_card.dart';

class CreateVisitPlanPage extends StatefulWidget {
  const CreateVisitPlanPage({super.key});

  @override
  State<CreateVisitPlanPage> createState() => _CreateVisitPlanPageState();
}

class _CreateVisitPlanPageState extends State<CreateVisitPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _planDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  final List<VisitPlanItemFormModel> _items = [VisitPlanItemFormModel()];

  @override
  void dispose() {
    _planDateController.dispose();
    _notesController.dispose();
    for (var item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(VisitPlanItemFormModel());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    CustomDatePicker.show(
      context,
      initialDate: DateTime.now(),
      onDateSelected: (picked) {
        setState(() {
          _selectedDate = picked;
          _planDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        });
      },
    );
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _items[index].timeController.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final localDataSource = sl<HomeLocalDataSources>();
      final employee = await localDataSource.getCachedEmployee();

      if (employee == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee data not found.')),
          );
        }
        return;
      }

      if (mounted) {
        final visitPlanData = {
          "employee_id": employee.id,
          "plan_date": _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : "",
          "notes": _notesController.text,
          "status": "pending",
          "items": _items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return {
              "location": item.locationController.text,
              "sub_location": item.subLocationController.text,
              "purpose": item.purposeController.text,
              "scheduled_time": item.timeController.text,
              "sequence_order": idx + 1,
            };
          }).toList(),
        };

        context.read<VisitPlanBloc>().add(CreateVisitPlanEvent(visitPlanData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitPlanBloc, VisitPlanState>(
      listener: (context, state) {
        if (state is VisitPlanSuccess) {
          SuccessDialog.show(
            context,
            title: 'Visit Plan Created',
            message: 'Your visit plan has been successfully created.',
            onDismiss: () {
              Navigator.pop(context);
            },
          );
        } else if (state is VisitPlanFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Create Visit Plan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              label: 'Plan Date *',
                              placeholder: 'dd/mm/yyyy',
                              controller: _planDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select plan date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Notes",
                          placeholder: "Enter additional notes",
                          controller: _notesController,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Visit Items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add Item'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return VisitPlanItemCard(
                      index: index,
                      locationController: item.locationController,
                      subLocationController: item.subLocationController,
                      purposeController: item.purposeController,
                      timeController: item.timeController,
                      onRemove: () => _removeItem(index),
                      onSelectTime: () => _selectTime(context, index),
                    );
                  }),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: BlocBuilder<VisitPlanBloc, VisitPlanState>(
              builder: (context, state) {
                final isLoading = state is VisitPlanLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Visit Plan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VisitPlanItemFormModel {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController subLocationController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  void dispose() {
    locationController.dispose();
    subLocationController.dispose();
    purposeController.dispose();
    timeController.dispose();
  }
}
