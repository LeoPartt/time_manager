
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

typedef StringValidator = String? Function(String?);

class AppInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final StringValidator? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> with SingleTickerProviderStateMixin {
  late bool _obscure;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: _obscure,
        enabled: widget.enabled,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged,
        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
        
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
          fontWeight: FontWeight.w500,
        ),
        
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: _isFocused 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withValues(alpha:0.5),
                )
              : null,
          
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: colorScheme.onSurface.withValues(alpha:0.5),
                  ),
                  onPressed: _toggleObscure,
                  tooltip: _obscure ? 'Afficher' : 'Masquer',
                )
              : widget.suffix,
          
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            fontSize: AppSizes.responsiveText(context, AppSizes.textSm),
            color: _isFocused 
                ? colorScheme.primary 
                : colorScheme.onSurface.withValues(alpha:0.6),
            fontWeight: FontWeight.w500,
          ),
          
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha:0.4),
          ),
          
          filled: true,
          fillColor: widget.enabled
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
          
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p16,
          ),
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha:0.3),
            ),
          ),
          
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha:0.3),
            ),
          ),
          
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.error,
            ),
          ),
          
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha:0.2),
            ),
          ),
        ),
      ),
    );
  }
}