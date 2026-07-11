/// Recent Document Card for the Dashboard carousel.
/// Shows: status indicator, title, rich preview, word count, status label.
/// Tappable with scale animation. Long-press for context menu.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';
import '../models/document_model.dart';
import '../models/sync_status_model.dart';

class RecentDocumentCard extends StatefulWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double? width;

  const RecentDocumentCard({
    Key? key,
    required this.document,
    required this.onTap,
    this.onLongPress,
    this.width = 280,
  }) : super(key: key);

  @override
  State<RecentDocumentCard> createState() => _RecentDocumentCardState();
}

class _RecentDocumentCardState extends State<RecentDocumentCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final syncStatus = SyncStatusInfo.fromType(
      _convertSyncStatus(widget.document.syncStatus),
    );
    final textColor =
        isDark ? RaqimColors.ivory900 : RaqimColors.slate900;
    final secondaryTextColor =
        isDark ? RaqimColors.ivory600 : RaqimColors.slate600;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onLongPress: widget.onLongPress,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: isDark ? RaqimColors.charcoal800 : RaqimColors.paper,
            borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
            boxShadow: isDark
                ? RaqimShadows.darkCardShadow
                : RaqimShadows.cardShadow,
            border: isDark
                ? Border.all(
                    color: Colors.white.withOpacity(0.06),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status + Time
              Padding(
                padding: const EdgeInsets.all(RaqimSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status dot + label
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: syncStatus.dotColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (syncStatus.isPulsing)
                                BoxShadow(
                                  color: syncStatus.dotColor.withOpacity(0.4),
                                  blurRadius: 8,
                                )
                            ],
                          ),
                        ),
                        const SizedBox(width: RaqimSpacing.space2),
                        Text(
                          syncStatus.label,
                          style: RaqimTypography.caption.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    // Time
                    Text(
                      widget.document.getLastModifiedDisplay(),
                      style: RaqimTypography.caption.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Title + Preview
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: RaqimSpacing.space4,
                  vertical: RaqimSpacing.space2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.document.title,
                      style: RaqimTypography.h2.copyWith(
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: RaqimSpacing.space2),
                    Text(
                      widget.document.preview ??
                          widget.document.generatePreview(),
                      style: RaqimTypography.bodyUI.copyWith(
                        color: secondaryTextColor,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Footer: Word count + Status
              Padding(
                padding: const EdgeInsets.all(RaqimSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.document.wordCount} words',
                      style: RaqimTypography.caption.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RaqimSpacing.space2,
                        vertical: RaqimSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: RaqimColors.coral50,
                        borderRadius:
                            BorderRadius.circular(RaqimRadius.radiusSm),
                      ),
                      child: Text(
                        'Draft',
                        style: RaqimTypography.caption.copyWith(
                          color: RaqimColors.coral600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SyncStatusType _convertSyncStatus(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return SyncStatusType.synced;
      case SyncStatus.syncing:
        return SyncStatusType.syncing;
      case SyncStatus.offline:
        return SyncStatusType.offline;
      case SyncStatus.conflict:
        return SyncStatusType.conflict;
    }
  }
}
