// lib/ui/widgets/guru/grade_input_form.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GradeInputForm extends StatefulWidget {
  final String studentName;
  final String studentId;
  final String subject;
  final String classId;
  final String semester;
  final List<GradeCategory> categories;
  final Map<String, double>? initialGrades;
  final Function(String studentId, Map<String, double> grades, String notes)
  onSubmit;
  final VoidCallback onCancel;

  const GradeInputForm({
    Key? key,
    required this.studentName,
    required this.studentId,
    required this.subject,
    required this.classId,
    required this.semester,
    required this.categories,
    this.initialGrades,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  _GradeInputFormState createState() => _GradeInputFormState();
}

class _GradeInputFormState extends State<GradeInputForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late TextEditingController _notesController;
  double _totalGrade = 0;
  String _letterGrade = '-';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _isEditing = widget.initialGrades != null;
    _notesController = TextEditingController();
    _calculateTotalGrade();
  }

  void _initControllers() {
    _controllers = {};
    for (var category in widget.categories) {
      final initialValue =
          widget.initialGrades != null &&
                  widget.initialGrades!.containsKey(category.id)
              ? widget.initialGrades![category.id].toString()
              : '';
      _controllers[category.id] = TextEditingController(text: initialValue);

      // Add listener to recalculate total when value changes
      _controllers[category.id]!.addListener(_calculateTotalGrade);
    }
  }

  void _calculateTotalGrade() {
    double weightedTotal = 0;
    double totalWeight = 0;

    for (var category in widget.categories) {
      final controller = _controllers[category.id];
      if (controller != null && controller.text.isNotEmpty) {
        try {
          final grade = double.parse(controller.text);
          weightedTotal += grade * (category.weight / 100);
          totalWeight += category.weight / 100;
        } catch (e) {
          // Skip invalid values
        }
      }
    }

    setState(() {
      if (totalWeight > 0) {
        _totalGrade = weightedTotal / totalWeight;
        _letterGrade = _getLetterGrade(_totalGrade);
      } else {
        _totalGrade = 0;
        _letterGrade = '-';
      }
    });
  }

  String _getLetterGrade(double grade) {
    if (grade >= 90) return 'A';
    if (grade >= 80) return 'B';
    if (grade >= 70) return 'C';
    if (grade >= 60) return 'D';
    return 'E';
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final grades = <String, double>{};
      _controllers.forEach((categoryId, controller) {
        if (controller.text.isNotEmpty) {
          grades[categoryId] = double.parse(controller.text);
        }
      });

      widget.onSubmit(widget.studentId, grades, _notesController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Nilai' : 'Input Nilai',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mata Pelajaran: ${widget.subject}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'Semester: ${widget.semester}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getGradeColor(_totalGrade).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Nilai Akhir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _totalGrade.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(_totalGrade),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getGradeColor(_totalGrade),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _letterGrade,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Student info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.studentName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'ID: ${widget.studentId}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            'Kelas: ${widget.classId}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Grade categories
              Text(
                'Komponen Penilaian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Grade input fields
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.categories.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder:
                    (context, index) =>
                        _buildGradeField(widget.categories[index]),
              ),

              const SizedBox(height: 24),

              // Notes field
              Text(
                'Catatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan untuk nilai siswa (opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Submit and cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: widget.onCancel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text('Batal'),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        _isEditing ? 'Perbarui Nilai' : 'Simpan Nilai',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeField(GradeCategory category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (category.description != null)
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Bobot: ${category.weight}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controllers[category.id],
                  decoration: InputDecoration(
                    labelText: 'Nilai',
                    hintText: '0-100',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixText: 'dari 100',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final grade = double.tryParse(value);
                      if (grade == null) {
                        return 'Masukkan nilai yang valid';
                      }
                      if (grade < 0 || grade > 100) {
                        return 'Nilai harus antara 0-100';
                      }
                    }
                    return null;
                  },
                ),
              ),
              if (category.hasAttachment)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle attachment upload
                    },
                    icon: Icon(Icons.attach_file),
                    label: Text('Lampiran'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 80) return Colors.green;
    if (grade >= 70) return Colors.blue;
    if (grade >= 60) return Colors.orange;
    return Colors.red;
  }
}

class GradeCategory {
  final String id;
  final String name;
  final double weight;
  final String? description;
  final bool hasAttachment;

  GradeCategory({
    required this.id,
    required this.name,
    required this.weight,
    this.description,
    this.hasAttachment = false,
  });
}
