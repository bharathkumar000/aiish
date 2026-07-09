import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ClayCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20,
    this.borderWidth = 4,
    this.shadowOffset = 6,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isEnabled ? backgroundColor : backgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppTheme.borderDark.withValues(alpha: isEnabled ? 1.0 : 0.4),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderDark.withValues(alpha: isEnabled ? 1.0 : 0.3),
            offset: Offset(0, shadowOffset),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null && isEnabled) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }
    return content;
  }
}
