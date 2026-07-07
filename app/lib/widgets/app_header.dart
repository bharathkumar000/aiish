import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.borderDark, width: 5),
          left: BorderSide(color: AppTheme.borderDark, width: 5),
          right: BorderSide(color: AppTheme.borderDark, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderDark,
            offset: Offset(0, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.pastelPeach,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderDark, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.borderDark,
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppTheme.textMain,
                  size: 24,
                ),
              ),
            )
          else
            const SizedBox(width: 44),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textMain,
                letterSpacing: 0.5,
              ),
            ),
          ),
          trailing ?? const SizedBox(width: 44),
        ],
      ),
    );
  }
}
