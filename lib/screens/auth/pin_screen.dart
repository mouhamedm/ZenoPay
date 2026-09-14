import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with SingleTickerProviderStateMixin {
  String _currentPin = '';
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
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_currentPin.length < 6) {
      setState(() {
        _currentPin += value;
      });
      if (_currentPin.length == 6) {
        _handleLogin();
      }
    }
  }

  void _onDeletePress() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      });
    }
  }

  Future<void> _handleLogin() async {
    if (_currentPin.length != 6) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithPin(_currentPin);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      // Clear PIN on error so the user can try again
      setState(() {
        _currentPin = '';
      });
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

  Widget _buildPinIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < _currentPin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.gradientStart : Colors.transparent,
            border: Border.all(
              color: isFilled ? AppColors.gradientStart : AppColors.textMuted.withAlpha(100),
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumpad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNumpadRow(['1', '2', '3']),
        const SizedBox(height: 24),
        _buildNumpadRow(['4', '5', '6']),
        const SizedBox(height: 24),
        _buildNumpadRow(['7', '8', '9']),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72, height: 72), // Empty space placeholder for alignment
            _buildNumpadButton('0'),
            _buildActionNumpadButton(
              icon: Icons.backspace_rounded,
              onTap: _onDeletePress,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumpadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((n) => _buildNumpadButton(n)).toList(),
    );
  }

  Widget _buildNumpadButton(String number) {
    return InkWell(
      onTap: () => _onKeyPress(number),
      borderRadius: BorderRadius.circular(36),
      splashColor: AppColors.gradientStart.withAlpha(40),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          number,
          style: AppTextStyles.displayMedium.copyWith(fontSize: 28, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildActionNumpadButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      splashColor: AppColors.error.withAlpha(40),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: AppColors.textPrimary),
      ),
    );
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
            child: Column(
              children: [
                const Spacer(flex: 2),
                // -- Header --
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.gradientStart.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded, color: AppColors.gradientStart, size: 28),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text('Saisissez votre PIN', style: AppTextStyles.displayMedium),
                ),
                const SizedBox(height: 48),
                // -- Indicators --
                if (isLoading)
                  const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  _buildPinIndicators(),
                const Spacer(flex: 2),
                // -- Custom Numpad --
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildNumpad(),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
