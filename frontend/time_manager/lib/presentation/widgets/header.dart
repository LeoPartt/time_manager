import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class Header extends StatelessWidget {
  final String label;

  const Header({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;
    final w = AppSizes.responsiveWidth(context, 0.9 * MediaQuery.of(context).size.width);
    final h = AppSizes.responsiveHeight(context, isLandscape ? 0.1 * MediaQuery.of(context).size.height : 0.06 * MediaQuery.of(context).size.height );
final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
    return Container(   
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
         boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: AppSizes.r12,
          ),
        ],
      ),
      margin: EdgeInsets.only(top : AppSizes.responsiveHeight(context, 0.03 * size.height)),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: size.width * 0.08,)
           
          ),
        ),
      )
    );
  }
}
