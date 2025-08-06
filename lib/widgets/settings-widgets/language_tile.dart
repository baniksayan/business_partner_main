import 'package:flutter/material.dart';
import '../../views/styles/app_colors.dart';
import '../../views/styles/app_text_styles.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.leading,
    this.onTap,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: 16.0),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyTextMedium,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.0),
                        Text(
                          subtitle!,
                          style: AppTextStyles.captionText.copyWith(
                            color: subtitleColor ?? AppColors.greyColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 12.0),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
