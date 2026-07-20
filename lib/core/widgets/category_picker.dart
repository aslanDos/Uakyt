import 'package:flutter/material.dart';
import 'package:uakyt/core/constants/app_icons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    super.key,
    required this.icons,
    required this.selectedIcon,
    required this.onChanged,
  });

  final List<AppIcon> icons;
  final AppIcon selectedIcon;
  final ValueChanged<AppIcon> onChanged;

  static const double _iconTileSize = 40;
  static const int _rowCount = 3;
  static const double _rowSpacing = 14;
  static const double _columnSpacing = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: SizedBox(
        height: _rowCount * _iconTileSize + (_rowCount - 1) * _rowSpacing,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: (icons.length / _rowCount).ceil(),
          separatorBuilder: (_, _) => const SizedBox(width: _columnSpacing),
          itemBuilder: (context, columnIndex) {
            final startIndex = columnIndex * _rowCount;
            final columnIcons = icons.skip(startIndex).take(_rowCount).toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final appIcon in columnIcons) ...[
                  _CategoryIconButton(
                    appIcon: appIcon,
                    selected: appIcon == selectedIcon,
                    onTap: () => onChanged(appIcon),
                  ),
                  if (appIcon != columnIcons.last)
                    const SizedBox(height: _rowSpacing),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryIconButton extends StatelessWidget {
  const _CategoryIconButton({
    required this.appIcon,
    required this.selected,
    required this.onTap,
  });

  final AppIcon appIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: appIcon.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: AnimatedContainer(
            width: CategoryPicker._iconTileSize,
            height: CategoryPicker._iconTileSize,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: selected ? context.c.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              appIcon.icon,
              size: 18,
              color: selected ? context.c.onPrimary : context.c.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
