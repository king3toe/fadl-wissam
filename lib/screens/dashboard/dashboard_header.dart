/// Dashboard Header - Clean, minimal, time-aware greeting.
/// Transparent initially, cross-fades to ivory on scroll.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

class DashboardHeader extends StatefulWidget {
  final bool isScrolled;
  final VoidCallback onProfileTap;

  const DashboardHeader({
    Key? key,
    this.isScrolled = false,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<double> _bgOpacity;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: RaqimAnimation.durationAmbient,
      vsync: this,
    );
    _bgOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: RaqimAnimation.curveAmbient),
    );
  }

  @override
  void didUpdateWidget(DashboardHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrolled && !oldWidget.isScrolled) {
      _bgController.forward();
    } else if (!widget.isScrolled && oldWidget.isScrolled) {
      _bgController.reverse();
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _bgOpacity,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: (isDark ? RaqimColors.charcoal900 : RaqimColors.ivory)
                .withOpacity(_bgOpacity.value * 0.8),
            backdropFilter: _bgOpacity.value > 0
                ? ImageFilter.blur(sigmaX: 20 * _bgOpacity.value, sigmaY: 20 * _bgOpacity.value)
                : null,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RaqimSpacing.space4,
                vertical: RaqimSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Logo + Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Raqim',
                        style: RaqimTypography.h1.copyWith(
                          color: isDark
                              ? RaqimColors.ivory900
                              : RaqimColors.slate900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onProfileTap,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: RaqimColors.coral500.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              RaqimRadius.radiusMd,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: RaqimColors.coral500,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RaqimSpacing.space3),
                  // Greeting
                  Text(
                    '${_getGreeting()}, Layla',
                    style: RaqimTypography.bodyUI.copyWith(
                      color: isDark
                          ? RaqimColors.ivory600
                          : RaqimColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:ui';
