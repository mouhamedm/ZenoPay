import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/auth/otp_input_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  String _currentOtp = '';
  int _countdown = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerified = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_slideController);
    _slideController.forward();
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_currentOtp.length != 6) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(_currentOtp);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isVerified = true;
      });
      // Wait a moment so the user sees the checkmark animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.of(context).pushReplacementNamed('/pin');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.status == AuthStatus.loading;
    final phone = auth.phoneNumber.isNotEmpty ? auth.phoneNumber : '+225 07 00 00 00 00';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // -- Header --
                  Text('Vérification', style: AppTextStyles.displayMedium),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      text: 'Code envoyé au ',
                      style: AppTextStyles.bodyMedium,
                      children: [
                        TextSpan(
                          text: phone,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 52),
                  // -- OTP input --
                  Center(
                    child: OtpInputField(
                      onCompleted: (otp) => setState(() => _currentOtp = otp),
                      onChanged: (otp) => setState(() => _currentOtp = otp),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // -- Verify button --
                  _GradientButton(
                    label: 'Vérifier',
                    isLoading: isLoading,
                    isSuccess: _isVerified,
                    enabled: _currentOtp.length == 6,
                    onTap: isLoading ? null : _handleVerify,
                  ),
                  const SizedBox(height: 32),
                  // -- Resend countdown --
                  Center(
                    child: _canResend
                        ? GestureDetector(
                            onTap: () {
                              _startCountdown();
                              context.read<AuthProvider>().resetStatus();
                            },
                            child: Text(
                              'Renvoyer le code',
                              style: AppTextStyles.labelLarge.copyWith(color: AppColors.gradientEnd),
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              text: 'Renvoyer dans ',
                              style: AppTextStyles.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${_countdown}s',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isSuccess;
  final bool enabled;
  final VoidCallback? onTap;

  const _GradientButton({
    required this.label,
    required this.isLoading,
    this.isSuccess = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !isLoading && !isSuccess ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (!enabled || isLoading) && !isSuccess
                ? [AppColors.gradientStart.withAlpha(100), AppColors.gradientEnd.withAlpha(100)]
                : [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled || isSuccess
              ? [
                  BoxShadow(
                    color: AppColors.gradientStart.withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isSuccess
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 32)
              : isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      label,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 16,
                        color: enabled ? Colors.white : Colors.white54,
                      ),
                    ),
        ),
      ),
    );
  }
}
