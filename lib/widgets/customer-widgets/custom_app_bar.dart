import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../views/styles/app_colors.dart';
import '../../views/styles/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Widget? leading;
  final double? elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.onBackPressed,
    this.centerTitle = true,
    this.leading,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: leading ?? (showBackButton
          ? Container(
              margin: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textColor,
                      size: 16,
                    ),
                  ),
                ),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              ),
            )
          : null),
      title: Text(
        title,
        style: AppTextStyles.heading3.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions != null
          ? actions!.map((action) {
              return Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: action,
              );
            }).toList()
          : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (backgroundColor ?? AppColors.backgroundColor).withOpacity(0.95),
              (backgroundColor ?? AppColors.backgroundColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Alternative Custom App Bar with Search functionality
class CustomAppBarWithSearch extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearch;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchTap;
  final String? searchHint;
  final List<Widget>? actions;

  const CustomAppBarWithSearch({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.onSearchTap,
    this.searchHint = 'Search...',
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: showBackButton
          ? Container(
              margin: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.textColor,
                    size: 16,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      title: showSearch
          ? Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                onTap: onSearchTap,
                style: AppTextStyles.bodyText,
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: AppTextStyles.captionText,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.greyColor,
                    size: 20,
                  ),
                  suffixIcon: searchController?.text.isNotEmpty == true
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.greyColor,
                            size: 20,
                          ),
                          onPressed: () {
                            searchController?.clear();
                            if (onSearchChanged != null) onSearchChanged!('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                ),
              ),
            )
          : Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Custom App Bar with Gradient Background
class CustomGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final List<Color> gradientColors;
  final VoidCallback? onBackPressed;

  const CustomGradientAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.gradientColors = const [Color(0xFF9C7CE8), Color(0xFFE8C5A0)],
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: showBackButton
            ? IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: actions?.map((action) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: action,
          );
        }).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Custom App Bar with Bottom Border
class CustomBorderedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color borderColor;
  final double borderWidth;

  const CustomBorderedAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.borderColor = const Color(0xFFE5E5EA),
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textColor,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
