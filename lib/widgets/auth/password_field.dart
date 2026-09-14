import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Mot de passe',
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscured,
      textInputAction: widget.textInputAction,
      style: AppTextStyles.bodyLarge,
      cursorColor: AppColors.gradientStart,
      validator: widget.validator,
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscured = !_obscured),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              key: ValueKey(_obscured),
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
