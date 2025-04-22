import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../styles/app_styles.dart';
import '../theme/app_theme.dart'; // Tambahkan jika diperlukan

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String labelText;
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final IconData? icon;
  final bool isRequired;
  final String? errorText;
  final bool enabled;
  final DateFormat? dateFormat;

  const CustomDatePicker({
    super.key, // Menggunakan super parameter
    this.selectedDate,
    required this.onDateSelected,
    required this.labelText,
    this.hintText = 'Pilih tanggal',
    this.firstDate,
    this.lastDate,
    this.icon = Icons.calendar_today,
    this.isRequired = false,
    this.errorText,
    this.enabled = true,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFirstDate = firstDate ?? DateTime(1900);
    final effectiveLastDate = lastDate ?? DateTime(2100);
    final format = dateFormat ?? DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  labelText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppStyles.textSecondary,
                  ),
                ),
                if (isRequired)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: AppStyles.statusError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        InkWell(
          onTap:
              enabled
                  ? () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: effectiveFirstDate,
                      lastDate: effectiveLastDate,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: AppStyles.primaryColor,
                              onPrimary: Colors.white,
                              surface: AppStyles.bgCard,
                              onSurface: AppStyles.textPrimary,
                            ),
                            dialogBackgroundColor: AppStyles.bgCard,
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppStyles.primaryColor,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      onDateSelected(picked);
                    }
                  }
                  : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppStyles.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    errorText != null
                        ? AppStyles.statusError
                        : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      enabled
                          ? AppStyles.textSecondary
                          : AppStyles.textSecondary.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? format.format(selectedDate!)
                        : hintText,
                    style: TextStyle(
                      color:
                          selectedDate != null
                              ? AppStyles.textPrimary
                              : AppStyles.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color:
                      enabled
                          ? AppStyles.textSecondary
                          : AppStyles.textSecondary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorText!,
              style: TextStyle(color: AppStyles.statusError, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
