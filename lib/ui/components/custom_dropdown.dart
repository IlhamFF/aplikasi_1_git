import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../styles/app_styles.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final bool isRequired;
  final String? errorText;
  final IconData? prefixIcon;
  final bool isExpanded;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    this.hintText = 'Pilih',
    this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.errorText,
    this.prefixIcon,
    this.isExpanded = true,
    this.isDense = false,
    this.contentPadding,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.radiusM),
            border: Border.all(
              color:
                  errorText != null
                      ? AppStyles.statusError
                      : Colors.grey.withOpacity(0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, color: AppStyles.textSecondary, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: value,
                      hint: Text(
                        hintText,
                        style: TextStyle(color: AppStyles.textSecondary),
                      ),
                      items: items,
                      onChanged: enabled ? onChanged : null,
                      isExpanded: isExpanded,
                      isDense: isDense,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppStyles.textSecondary,
                      ),
                      style: TextStyle(
                        color: AppStyles.textPrimary,
                        fontSize: 14,
                      ),
                      dropdownColor: Theme.of(context).cardColor,
                    ),
                  ),
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
