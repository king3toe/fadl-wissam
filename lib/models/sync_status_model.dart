/// Sync status vocabulary with colors and labels per design spec.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

enum SyncStatusType {
  synced,
  syncing,
  offline,
  conflict,
}

class SyncStatusInfo {
  final SyncStatusType type;
  final String label;
  final Color dotColor;
  final bool isPulsing; // for syncing state

  SyncStatusInfo({
    required this.type,
    required this.label,
    required this.dotColor,
    this.isPulsing = false,
  });

  factory SyncStatusInfo.fromType(SyncStatusType type) {
    switch (type) {
      case SyncStatusType.synced:
        return SyncStatusInfo(
          type: SyncStatusType.synced,
          label: 'Synced',
          dotColor: RaqimColors.success,
        );
      case SyncStatusType.syncing:
        return SyncStatusInfo(
          type: SyncStatusType.syncing,
          label: 'Syncing…',
          dotColor: RaqimColors.coral500,
          isPulsing: true,
        );
      case SyncStatusType.offline:
        return SyncStatusInfo(
          type: SyncStatusType.offline,
          label: 'Offline',
          dotColor: RaqimColors.warning,
        );
      case SyncStatusType.conflict:
        return SyncStatusInfo(
          type: SyncStatusType.conflict,
          label: 'Needs review',
          dotColor: RaqimColors.danger,
        );
    }
  }
}
