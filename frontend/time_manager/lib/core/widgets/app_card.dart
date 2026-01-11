import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final bool elevated;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.elevated = true,
    this.borderRadius,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRad = widget.borderRadius ?? BorderRadius.circular(AppSizes.r16);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        } : null,
        onTapUp: widget.onTap != null ? (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
        } : null,
        onTapCancel: widget.onTap != null ? () {
          setState(() => _isPressed = false);
          _controller.reverse();
        } : null,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          margin: widget.margin ?? EdgeInsets.all(AppSizes.p8),
          padding: widget.padding ?? EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: widget.color ?? colorScheme.surface,
            borderRadius: borderRad,
            boxShadow: widget.elevated
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha:_isPressed ? 0.1 : 0.15),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ]
                : null,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha:0.1),
              width: 0.5,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}