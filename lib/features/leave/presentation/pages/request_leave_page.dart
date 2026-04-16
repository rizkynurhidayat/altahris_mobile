import 'package:flutter/material.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
import 'package:intl/intl.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  final _formKey = GlobalKey<FormState>();

  String _selectedLeaveType = 'cuti_tahunan';
  final TextEditingController _totalDaysController = TextEditingController(
    text: '1',
  );
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, String>> _leaveTypes = [
    {'value': 'cuti_tahunan', 'label': 'Cuti Tahunan'},
    {'value': 'cuti_sakit', 'label': 'Cuti Sakit'},
    {'value': 'cuti_melahirkan', 'label': 'Cuti Melahirkan'},
    {'value': 'cuti_besar', 'label': 'Cuti Besar'},
    {'value': 'izin', 'label': 'Izin'},
    {'value': 'dinas_luar', 'label': 'Dinas Luar'},
  ];

  @override
  void dispose() {
    _totalDaysController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    CustomDatePicker.show(
      context,
      initialDate: DateTime.now(),
      onDateSelected: (picked) {
        setState(() {
          if (isStartDate) {
            _startDate = picked;
            _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          } else {
            _endDate = picked;
            _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          }

          if (_startDate != null && _endDate != null) {
            final difference = _endDate!.difference(_startDate!).inDays + 1;
            if (difference > 0) {
              _totalDaysController.text = difference.toString();
            } else {
              _totalDaysController.text = '0';
            }
          }
        });
      },
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      LeaveRequestConfirmDialog.show(
        context,
        onConfirm: () {
          // Prepare data according to requestdata.json
          final data = {
            "attachment": "",
            "employee_id": "EMP001", // Placeholder
            "end_date": _endDate != null
                ? DateFormat('yyyy-MM-dd').format(_endDate!)
                : "",
            "leave_type": _selectedLeaveType,
            "reason": _reasonController.text,
            "start_date": _startDate != null
                ? DateFormat('yyyy-MM-dd').format(_startDate!)
                : "",
            "total_days": int.tryParse(_totalDaysController.text) ?? 0,
          };

          // Show success dialog
          SuccessDialog.show(
            context,
            title: 'Request Submitted',
            message:
                'Your leave request has been successfully submitted and is awaiting approval.',
            onDismiss: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Request Leave',
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
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLeaveType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                    items: _leaveTypes.map((type) {
                      return DropdownMenuItem(
                        value: type['value'],
                        child: Text(type['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLeaveType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Total Days *',
                    placeholder: '1',
                    controller: _totalDaysController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total days';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: 'Start Date *',
                        placeholder: 'dd/mm/yyyy',
                        controller: _startDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: 'End Date *',
                        placeholder: 'dd/mm/yyyy',
                        controller: _endDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Reason *",
                    placeholder: "Placeholder",
                    controller: _reasonController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                  // TextFormField(
                  //   controller: _reasonController,
                  //   maxLines: 4,
                  //   decoration: InputDecoration(
                  //     hintText: 'Placeholder',
                  //     hintStyle: const TextStyle(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 12,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: const BorderSide(color: AppColors.primary),
                  //     ),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter a reason';
                  //     }
                  //     return null;
                  //   },
                  // ),
              
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(0),
              elevation: 0,
            ),
            child: const Text(
              'Submit Request',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
