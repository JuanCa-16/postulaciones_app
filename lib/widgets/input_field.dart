import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.placeholder = 'Placeholder',
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium,
        ),

        const SizedBox(height: 5),

        TextFormField(
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return Colors.transparent;
              }

              return AppColors.inputBackground;
            }),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
