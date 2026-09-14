import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/auth/phone_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _fullPhone = '';
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fullPhone.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(_fullPhone);
    if (success && mounted) {
      Navigator.of(context).pushNamed('/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    // -- Header --
                    _buildHeader(),
                    const SizedBox(height: 48),
                    // -- Form fields --
                    Text('Numéro de téléphone', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 8),
                    PhoneInputField(onChanged: (val) => _fullPhone = val),
                    const SizedBox(height: 40),
                    // -- Signup button --
                    _GradientButton(
                      label: "Continuer",
                      isLoading: isLoading,
                      onTap: isLoading ? null : _handleSignup,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -- Logo --
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMuted.withAlpha(40),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 28),
        Text('Créer un compte', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Rejoignez Zeno Pay et gérez votre argent facilement.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

// -- Reusable gradient button --
class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _GradientButton({required this.label, required this.isLoading, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [AppColors.gradientStart.withAlpha(160), AppColors.gradientEnd.withAlpha(160)]
                : [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
