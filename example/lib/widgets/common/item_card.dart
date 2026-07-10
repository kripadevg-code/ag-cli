import 'package:flutter/material.dart';

/// A generic, reusable card widget for list items.
///
/// Customize fields and styling to match your design system.
class ItemCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;
  final String? trailingText;
  final Color? accentColor;
  final EdgeInsetsGeometry? margin;

  const ItemCard({super.key, this.onTap, this.title, this.subtitle, this.trailingText, this.accentColor, this.margin});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        border: accentColor != null ? Border(left: BorderSide(color: accentColor!, width: 4)) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ],
            ),
          ),
          if (trailingText != null) Text(trailingText!, style: TextStyle(color: accentColor ?? Colors.grey, fontSize: 12)),
        ],
      ),
    ),
  );
}
