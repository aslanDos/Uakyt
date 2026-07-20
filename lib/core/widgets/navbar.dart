import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';

class NavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const NavBar({super.key, this.activeIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(left: 64, right: 64),
          decoration: BoxDecoration(
            color: context.c.surfaceContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavBarButton(
                activeIndex: activeIndex,
                buttonIndex: 0,
                icon: HeroIcons.clock,
                onTap: onTap,
              ),
              NavBarButton(
                activeIndex: activeIndex,
                buttonIndex: 1,
                icon: HeroIcons.chartPie,
                onTap: onTap,
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavBarButton extends StatelessWidget {
  final int buttonIndex;
  final int activeIndex;
  final HeroIcons icon;
  final ValueChanged<int> onTap;

  const NavBarButton({
    super.key,
    required this.buttonIndex,
    required this.activeIndex,
    required this.icon,
    required this.onTap,
  });

  bool get isActive => buttonIndex == activeIndex;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.c.onSurface : context.c.outline;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(buttonIndex),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: HeroIcon(
            icon,
            style: isActive ? .solid : .outline,
            size: 28,
            key: ValueKey('$buttonIndex-$activeIndex'),
            color: color,
          ),
        ),
      ),
    );
  }
}
