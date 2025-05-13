import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DialogType {
  success,
  error,
  confirm,
  info,
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final DialogType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.type = DialogType.info,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  IconData _getIcon() {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.confirm:
        return Icons.help_outline;
      case DialogType.info:
        return Icons.info_outline;
    }
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case DialogType.success:
        return theme.colorScheme.primary;
      case DialogType.error:
        return theme.colorScheme.error;
      case DialogType.confirm:
        return theme.colorScheme.secondary;
      case DialogType.info:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              color: color,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: type == DialogType.confirm
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (type == DialogType.confirm)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancel?.call();
                      },
                      child: Text(
                        cancelText ?? 'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                if (type == DialogType.confirm) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      confirmText ?? 'OK',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the dialog
Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  DialogType type = DialogType.info,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? confirmText,
  String? cancelText,
}) {
  return showDialog(
    context: context,
    barrierDismissible: type != DialogType.confirm,
    builder: (BuildContext context) => CustomAlertDialog(
      title: title,
      message: message,
      type: type,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
} 