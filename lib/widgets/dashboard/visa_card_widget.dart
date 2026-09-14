import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/visa_card_model.dart';
import '../../theme/app_text_styles.dart';

class VisaCardWidget extends StatefulWidget {
  final VisaCardModel card;
  final bool revealed;
  final VoidCallback onToggleReveal;
  final EdgeInsetsGeometry? margin;

  const VisaCardWidget({
    super.key,
    required this.card,
    required this.revealed,
    required this.onToggleReveal,
    this.margin,
  });

  @override
  State<VisaCardWidget> createState() => _VisaCardWidgetState();
}

class _VisaCardWidgetState extends State<VisaCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VisaCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed != oldWidget.revealed) {
      if (widget.revealed) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 20),
          height: 200,
          child: AnimatedBuilder(
            animation: _flipAnim,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnim.value * 0.15),
                alignment: Alignment.center,
                child: _buildCardFace(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardFace() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.card.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Top row --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Zeno Pay', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                  GestureDetector(
                    onTap: widget.onToggleReveal,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        widget.revealed ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        key: ValueKey(widget.revealed),
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // -- Card number --
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: Text(
                  widget.revealed ? widget.card.formattedNumber : widget.card.maskedNumber,
                  key: ValueKey(widget.revealed),
                  style: AppTextStyles.cardNumber,
                ),
              ),
              const SizedBox(height: 20),
              // -- Bottom row --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TITULAIRE', style: AppTextStyles.cardLabel),
                      const SizedBox(height: 4),
                      Text(widget.card.cardholderName, style: AppTextStyles.cardValue),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('EXPIRE', style: AppTextStyles.cardLabel),
                      const SizedBox(height: 4),
                      Text(widget.card.expiryDate, style: AppTextStyles.cardValue),
                    ],
                  ),
                  // -- CVV only visible when revealed --
                  AnimatedOpacity(
                    opacity: widget.revealed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('CVV', style: AppTextStyles.cardLabel),
                        const SizedBox(height: 4),
                        Text(widget.card.cvv, style: AppTextStyles.cardValue),
                      ],
                    ),
                  ),
                  // -- Card type logo --
                  _CardTypeBadge(type: widget.card.cardType),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTypeBadge extends StatelessWidget {
  final String type;

  const _CardTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'Mastercard') {
      return Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withAlpha(220),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
    // -- Visa text logo --
    return Text(
      'VISA',
      style: AppTextStyles.cardValue.copyWith(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        letterSpacing: 2,
      ),
    );
  }
}
