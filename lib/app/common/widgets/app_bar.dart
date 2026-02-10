import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final Widget? title;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool? centerTitle;
  final double? toolbarHeight;
  final double? titleSpacing;
  final double? leadingWidth;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? elevation;

  const CommonAppBar({
    super.key,
    this.actions,
    this.color,
    this.title,
    this.centerTitle,
    this.toolbarHeight,
    this.flexibleSpace,
    this.titleSpacing,
    this.leadingWidth,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      scrolledUnderElevation: 0.1,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      backgroundColor: color,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      title: title,
      leading: leading,
      actions: actions,
      flexibleSpace: flexibleSpace,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
