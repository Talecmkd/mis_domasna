import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double? rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;
  final int maxRating;

  const StarRating({
    Key? key,
    required this.rating,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.isInteractive = false,
    this.onRatingChanged,
    this.maxRating = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeStarColor = activeColor ?? theme.colorScheme.primary;
    final inactiveStarColor = inactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.2);
    final currentRating = rating ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final value = index + 1;
        final starFillPercentage = (currentRating - index).clamp(0.0, 1.0);

        return GestureDetector(
          onTap: isInteractive
              ? () => onRatingChanged?.call(value.toDouble())
              : null,
          child: Stack(
            children: [
              // Empty star (background)
              Icon(
                Icons.star_rounded,
                size: size,
                color: inactiveStarColor,
              ),
              // Filled star (foreground)
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: starFillPercentage,
                  child: Icon(
                    Icons.star_rounded,
                    size: size,
                    color: activeStarColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
} 