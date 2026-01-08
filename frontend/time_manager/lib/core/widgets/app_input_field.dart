import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

typedef StringValidator = String? Function(String?);

class AppInputField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool obscureText;
  final StringValidator? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final int? maxLines;
  final TextEditingController? controller;

  const AppInputField({
    super.key,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late bool _obscure;
  bool _touched = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _touched = true);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return TextFormField(
      focusNode: _focusNode,
      obscureText: _obscure,
      autofocus: true,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      autovalidateMode: _touched
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
      onChanged: widget.onChanged,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      controller: widget.controller,

      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
      ),

      decoration: InputDecoration(
        suffixIcon: widget.obscureText
            ? Semantics(
                label: _obscure ? 'Show password' : 'Hide password',
                button: true,
                child: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscure,
                  tooltip: _obscure ? 'Show password' : 'Hide password',
                ),
              )
            : null,
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: theme.colorScheme.primary)
            : null,
        labelText: widget.label,
        labelStyle: textTheme.bodySmall?.copyWith(
          fontSize: AppSizes.responsiveText(context, AppSizes.textSm),
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
