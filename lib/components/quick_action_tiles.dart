/// Asymmetric quick-action tiles for Dashboard
/// 60/40 split: dominant "Start New" (with Playfair A glyph) + "Templates" tile.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

class QuickActionTiles extends StatelessWidget {
  final VoidCallback onStartNew;
  final VoidCallback onExploreTemplates;

  const QuickActionTiles({
    Key? key,
    required this.onStartNew,
    required this.onExploreTemplates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(RaqimSpacing.space4),
      child: Row(
        gap: RaqimSpacing.space4,
        children: [
          // Start New (60%)
          Expanded(
            flex: 3,
            child: _StartNewTile(onTap: onStartNew, isDark: isDark),
          ),
          // Templates (40%)
          Expanded(
            flex: 2,
            child: _TemplatesTile(onTap: onExploreTemplates, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _StartNewTile extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _StartNewTile({required this.onTap, required this.isDark});

  @override
  State<_StartNewTile> createState() => _StartNewTileState();
}

class _StartNewTileState extends State<_StartNewTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: RaqimAnimation.durationMicro,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                RaqimColors.coral500,
                RaqimColors.coral600,
              ],
            ),
            borderRadius: BorderRadius.circular(RaqimRadius.radiusLg),
            boxShadow: RaqimShadows.floatShadow,
          ),
          child: Stack(
            children: [
              // Decorative glyph (Playfair A)
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Text(
                    'A',
                    style: RaqimTypography.display.copyWith(
                      fontSize: 140,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(RaqimSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start New',
                          style: RaqimTypography.h2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: RaqimSpacing.space2),
                        Text(
                          'Blank document',
                          style: RaqimTypography.bodyUI.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RaqimSpacing.space3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplatesTile extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _TemplatesTile({required this.onTap, required this.isDark});

  @override
  State<_TemplatesTile> createState() => _TemplatesTileState();
}

class _TemplatesTileState extends State<_TemplatesTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: RaqimAnimation.durationMicro,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark
                ? RaqimColors.charcoal800
                : RaqimColors.paper,
            borderRadius: BorderRadius.circular(RaqimRadius.radiusLg),
            boxShadow: widget.isDark
                ? RaqimShadows.darkCardShadow
                : RaqimShadows.cardShadow,
            border: widget.isDark
                ? Border.all(
                    color: Colors.white.withOpacity(0.06),
                    width: 1,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(RaqimSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Templates',
                      style: RaqimTypography.h2.copyWith(
                        color: widget.isDark
                            ? RaqimColors.ivory900
                            : RaqimColors.slate900,
                      ),
                    ),
                    const SizedBox(height: RaqimSpacing.space2),
                    Text(
                      '12 available',
                      style: RaqimTypography.bodyUI.copyWith(
                        color: widget.isDark
                            ? RaqimColors.ivory600
                            : RaqimColors.slate600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
