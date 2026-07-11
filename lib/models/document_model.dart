/// Document model representing a user's written document.
/// RTL-safe, supports metadata, sync status, and collaboration.

import 'package:flutter/foundation.dart';

enum SyncStatus {
  synced,
  syncing,
  offline,
  conflict,
}

class Document {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final int wordCount;
  final SyncStatus syncStatus;
  final String storageLocation; // 'raqim_drive', 'google_drive', 'local'
  final List<String> tags;
  final List<String> collaborators;
  final String? documentFormat; // '.raqim', '.docx', '.pdf', '.md'
  final String? preview; // Rich text snippet for carousel

  Document({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.wordCount,
    this.syncStatus = SyncStatus.synced,
    this.storageLocation = 'raqim_drive',
    this.tags = const [],
    this.collaborators = const [],
    this.documentFormat = '.raqim',
    this.preview,
  });

  /// Create a rich preview of the first 120 characters
  String generatePreview() {
    if (content.isEmpty) return 'No content yet';
    final text = content.replaceAll('\n', ' ').trim();
    if (text.length > 120) {
      return text.substring(0, 120) + '...';
    }
    return text;
  }

  /// Format last modified time to human-readable format
  String getLastModifiedDisplay() {
    final now = DateTime.now();
    final difference = now.difference(lastModifiedAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return 'Last modified ${lastModifiedAt.month}/${lastModifiedAt.day}';
  }

  /// Copy constructor for state mutations
  Document copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    int? wordCount,
    SyncStatus? syncStatus,
    String? storageLocation,
    List<String>? tags,
    List<String>? collaborators,
    String? documentFormat,
    String? preview,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      wordCount: wordCount ?? this.wordCount,
      syncStatus: syncStatus ?? this.syncStatus,
      storageLocation: storageLocation ?? this.storageLocation,
      tags: tags ?? this.tags,
      collaborators: collaborators ?? this.collaborators,
      documentFormat: documentFormat ?? this.documentFormat,
      preview: preview ?? this.preview,
    );
  }
}
