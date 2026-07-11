/// Floating Glass Dock - Bottom navigation with Create emphasis.
/// 5 icons: Library, Recent, Create (+), Templates, Profile.
/// Create is slightly lifted and larger for emphasis without fragmentation.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../components/glass_surface.dart';

class FloatingGlassDock extends StatelessWidget {
  final int activeIndex;
  final Function(int) onItemTap;
  final EdgeInsets padding;

  const FloatingGlassDock({
    Key? key,
    this.activeIndex = 0,
    required this.onItemTap,
    this.padding = const EdgeInsets.only(
      bottom: RaqimSpacing.space4,
      left: RaqimSpacing.space4,
      right: RaqimSpacing.space4,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: padding,
        child: Center(
          child: GlassSurface(
            radius: RaqimRadius.radiusPill,
            padding: const EdgeInsets.symmetric(
              horizontal: RaqimSpacing.space5,
              vertical: RaqimSpacing.space3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DockItem(
                  icon: Icons.menu_book,
                  label: 'Library',
                  index: 0,
                  isActive: activeIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                const SizedBox(width: RaqimSpacing.space5),
                _DockItem(
                  icon: Icons.history,
                  label: 'Recent',
                  index: 1,
                  isActive: activeIndex == 1,
                  onTap: () => onItemTap(1),
                ),
                const SizedBox(width: RaqimSpacing.space5),
                // Create button - lifted and larger
                Transform.translate(
                  offset: const Offset(0, -4),
                  child: _DockItem(
                    icon: Icons.add,
                    label: 'Create',
                    index: 2,
                    isActive: activeIndex == 2,
                    isCreateButton: true,
                    onTap: () => onItemTap(2),
                  ),
                ),
                const SizedBox(width: RaqimSpacing.space5),
                _DockItem(
                  icon: Icons.palette,
                  label: 'Templates',
                  index: 3,
                  isActive: activeIndex == 3,
                  onTap: () => onItemTap(3),
                ),
                const SizedBox(width: RaqimSpacing.space5),
                _DockItem(
                  icon: Icons.person,
                  label: 'Profile',
                  index: 4,
                  isActive: activeIndex == 4,
                  onTap: () => onItemTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final bool isCreateButton;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
    this.isCreateButton = false,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: RaqimAnimation.durationMicro,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widget.isCreateButton ? 28.0 : 24.0;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) {
          _scaleController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _scaleController.reverse(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: widget.isActive ? RaqimColors.coral500 : Colors.transparent,
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Icon(
                widget.icon,
                size: size * 0.6,
                color: widget.isActive
                    ? Colors.white
                    : (isDark ? RaqimColors.ivory600 : RaqimColors.slate600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
