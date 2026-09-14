import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PhoneInputField extends StatefulWidget {
  final void Function(String fullNumber) onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const PhoneInputField({
    super.key,
    required this.onChanged,
    this.validator,
    this.focusNode,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String _selectedPrefix = '+225';
  late TextEditingController _controller;

  final List<Map<String, dynamic>> _countries = [
    {'code': '+225', 'flag': '🇨🇮', 'digits': 10, 'hint': '07 XX XX XX XX'},
    {'code': '+221', 'flag': '🇸🇳', 'digits': 9, 'hint': '77 XXX XX XX'},
    {'code': '+223', 'flag': '🇲🇱', 'digits': 8, 'hint': '76 XX XX XX'},
    {'code': '+226', 'flag': '🇧🇫', 'digits': 8, 'hint': '70 XX XX XX'},
  ];

  Map<String, dynamic> get _currentCountry =>
      _countries.firstWhere((c) => c['code'] == _selectedPrefix);

  int get _currentDigits => _currentCountry['digits'] as int;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged('$_selectedPrefix${_controller.text}');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_currentDigits),
      ],
      style: AppTextStyles.bodyLarge,
      cursorColor: AppColors.gradientStart,
      decoration: InputDecoration(
        hintText: _currentCountry['hint'] as String,
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: PopupMenuButton<String>(
            initialValue: _selectedPrefix,
            color: AppColors.surfaceElevated,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            position: PopupMenuPosition.under,
            onSelected: (value) {
              setState(() {
                _selectedPrefix = value;
                final maxDigits = _currentDigits;
                if (_controller.text.length > maxDigits) {
                  _controller.text = _controller.text.substring(0, maxDigits);
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              });
              _notifyChange();
            },
            itemBuilder: (context) {
              return _countries.map((country) {
                final code = country['code'] as String;
                final flag = country['flag'] as String;
                final digits = country['digits'] as int;
                return PopupMenuItem<String>(
                  value: code,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(code, style: AppTextStyles.bodyLarge),
                      const SizedBox(width: 8),
                      Text(
                        '($digits ch.)',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentCountry['flag'] as String,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(_selectedPrefix, style: AppTextStyles.bodyLarge),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gradientStart, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        counterText: '',
      ),
      onChanged: (val) {
        _notifyChange();
      },
      validator: (val) {
        if (widget.validator != null) {
          return widget.validator!(val);
        }
        if (val == null || val.trim().isEmpty) {
          return 'Veuillez entrer votre numéro de téléphone';
        }
        if (val.length != _currentDigits) {
          return 'Le numéro doit comporter $_currentDigits chiffres';
        }
        return null;
      },
    );
  }
}
