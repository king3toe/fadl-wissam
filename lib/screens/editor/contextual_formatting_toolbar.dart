/// Contextual Floating Toolbar
/// Appears only when text is selected. Positioned above selection.
/// Contains: B, I, U, -, H1. Active states use coral-500.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../components/glass_surface.dart';

class ContextualFormattingToolbar extends StatefulWidget {
  final Offset? position;
  final bool isVisible;
  final Function(String) onFormatApplied;
  final VoidCallback onDismiss;

  const ContextualFormattingToolbar({
    Key? key,
    this.position,
    this.isVisible = false,
    required this.onFormatApplied,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<ContextualFormattingToolbar> createState() =>
      _ContextualFormattingToolbarState();
}

class _ContextualFormattingToolbarState
    extends State<ContextualFormattingToolbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: RaqimAnimation.durationReveal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ContextualFormattingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse().then((_) {
        widget.onDismiss();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && widget.position == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: widget.position?.dx ?? 0,
      top: widget.position?.dy ?? 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: GlassSurface(
            radius: RaqimRadius.radiusPill,
            padding: const EdgeInsets.symmetric(
              horizontal: RaqimSpacing.space4,
              vertical: RaqimSpacing.space2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FormatButton(
                  icon: 'B',
                  isText: true,
                  onTap: () => widget.onFormatApplied('bold'),
                ),
                const SizedBox(width: RaqimSpacing.space3),
                _FormatButton(
                  icon: 'I',
                  isText: true,
                  onTap: () => widget.onFormatApplied('italic'),
                ),
                const SizedBox(width: RaqimSpacing.space3),
                _FormatButton(
                  icon: 'U',
                  isText: true,
                  onTap: () => widget.onFormatApplied('underline'),
                ),
                const SizedBox(width: RaqimSpacing.space3),
                _FormatButton(
                  icon: 'align_left',
                  onTap: () => widget.onFormatApplied('align_left'),
                ),
                const SizedBox(width: RaqimSpacing.space3),
                _FormatButton(
                  icon: 'H1',
                  isText: true,
                  onTap: () => widget.onFormatApplied('h1'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormatButton extends StatefulWidget {
  final String icon;
  final bool isText;
  final VoidCallback onTap;
  final bool isActive;

  const _FormatButton({
    required this.icon,
    required this.onTap,
    this.isText = false,
    this.isActive = false,
  });

  @override
  State<_FormatButton> createState() => _FormatButtonState();
}

class _FormatButtonState extends State<_FormatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: RaqimAnimation.durationMicro,
      vsync: this,
    );
    _colorAnimation =
        ColorTween(begin: Colors.transparent, end: RaqimColors.coral500)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _controller.forward().then((_) => _controller.reverse());
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: widget.isText
                  ? Text(
                      widget.icon,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value?.withOpacity(0) != null
                            ? Colors.white
                            : RaqimColors.slate600,
                      ),
                    )
                  : Icon(
                      _getIcon(widget.icon),
                      size: 16,
                      color: _colorAnimation.value?.withOpacity(0) != null
                          ? Colors.white
                          : RaqimColors.slate600,
                    ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'align_left':
        return Icons.format_align_left;
      default:
        return Icons.more_horiz;
    }
  }
}
