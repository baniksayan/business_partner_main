import 'package:flutter/material.dart';
import '../../views/styles/app_colors.dart';
import '../../views/styles/app_text_styles.dart';
import '../../views/styles/customer-style/customer_styles.dart';

class CustomerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String? tag;
  final VoidCallback? onTap;
  final bool showArrow;
  final int? totalBookings;
  final String? lastSeen;

  const CustomerCard({
    Key? key,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.tag,
    this.onTap,
    this.showArrow = true,
    this.totalBookings,
    this.lastSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: CustomerStyles.customerCardDecoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: onTap,
          splashColor: AppColors.primaryColor.withOpacity(0.1),
          highlightColor: AppColors.primaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Enhanced Avatar with gradient border
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.2),
                        AppColors.accentBeige.withOpacity(0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cardColor,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.lightGreyColor,
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? Text(
                              _getInitials(name),
                              style: AppTextStyles.bodyTextMedium.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                
                // Enhanced Customer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: AppTextStyles.bodyTextMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tag != null) ...[
                            SizedBox(width: 8.0),
                            _buildEnhancedTagChip(tag!),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        phone,
                        style: AppTextStyles.captionText.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyColor.withOpacity(0.8),
                        ),
                      ),
                      if (email != null) ...[
                        SizedBox(height: 3.0),
                        Text(
                          email!,
                          style: AppTextStyles.captionText.copyWith(
                            color: AppColors.greyColor.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (totalBookings != null || lastSeen != null) ...[
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            if (totalBookings != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accentGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$totalBookings bookings',
                                  style: AppTextStyles.smallText.copyWith(
                                    color: AppColors.accentGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (lastSeen != null) SizedBox(width: 8),
                            ],
                            if (lastSeen != null)
                              Text(
                                'Last seen: $lastSeen',
                                style: AppTextStyles.smallText.copyWith(
                                  color: AppColors.greyColor.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Enhanced Arrow Icon
                if (showArrow)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.greyColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  Widget _buildEnhancedTagChip(String tag) {
    Color tagColor;
    IconData tagIcon;
    switch (tag.toLowerCase()) {
      case 'frequent':
        tagColor = CustomerStyles.frequentCustomerColor;
        tagIcon = Icons.star_rounded;
        break;
      case 'vip':
        tagColor = CustomerStyles.vipCustomerColor;
        tagIcon = Icons.diamond_rounded;
        break;
      case 'premium':
        tagColor = CustomerStyles.premiumCustomerColor;
        tagIcon = Icons.workspace_premium_rounded;
        break;
      default:
        tagColor = CustomerStyles.regularCustomerColor;
        tagIcon = Icons.person_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tagColor.withOpacity(0.15),
            tagColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: tagColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tagIcon,
            size: 12,
            color: tagColor,
          ),
          SizedBox(width: 4),
          Text(
            tag.toUpperCase(),
            style: AppTextStyles.smallText.copyWith(
              color: tagColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
