import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final void Function(String otp) onCompleted;
  final void Function(String otp)? onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    if (value.isEmpty) {
      // Move back on delete
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    } else {
      // Move forward on entry
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final otp = _currentOtp;
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        return _OtpDigitBox(
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          onChanged: (val) => _onDigitEntered(i, val),
          isFirst: i == 0,
        );
      }),
    );
  }
}

class _OtpDigitBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final bool isFirst;

  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.isFirst = false,
  });

  @override
  State<_OtpDigitBox> createState() => _OtpDigitBoxState();
}

class _OtpDigitBoxState extends State<_OtpDigitBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        decoration: BoxDecoration(
          color: _isFocused ? AppColors.gradientStart.withAlpha(25) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isFocused ? AppColors.gradientStart : AppColors.border,
            width: _isFocused ? 1.5 : 1,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: AppTextStyles.headlineMedium.copyWith(letterSpacing: 0, height: 1),
          cursorColor: AppColors.gradientStart,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            filled: false,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
