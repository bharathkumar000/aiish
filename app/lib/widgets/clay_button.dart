import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClayButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double? width;
  final double fontSize;
  final bool isFullWidth;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget? prefixIcon;

  const ClayButton({
    super.key,
    this.child,
    this.text,
    this.onPressed,
    this.backgroundColor = AppTheme.primary,
    this.textColor = AppTheme.textMain,
    this.height = 54,
    this.width,
    this.fontSize = 18,
    this.isFullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.borderRadius = 16,
    this.prefixIcon,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final double offsetY = (_isPressed && isEnabled) ? 2 : 5;
    final double translateY = (_isPressed && isEnabled) ? 3 : 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 70),
      transform: Matrix4.translationValues(0, translateY, 0),
      width: widget.isFullWidth ? double.infinity : widget.width,
      height: widget.height,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        child: Container(
          padding: widget.padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isEnabled
                ? widget.backgroundColor
                : widget.backgroundColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: AppTheme.borderDark.withValues(alpha: isEnabled ? 1.0 : 0.4),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.borderDark.withValues(alpha: isEnabled ? 1.0 : 0.3),
                offset: Offset(0, offsetY),
                blurRadius: 0,
              ),
            ],
          ),
          child: widget.child ??
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.prefixIcon != null) ...[
                    widget.prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text ?? '',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w900,
                      color: isEnabled
                          ? widget.textColor
                          : widget.textColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
