/// Dashboard Screen (Mobile)
/// Header + Recent carousel + Quick action tiles + Floating glass dock.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../models/document_model.dart';
import '../../components/recent_document_card.dart';
import '../../components/quick_action_tiles.dart';
import 'dashboard_header.dart';
import 'floating_glass_dock.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isHeaderScrolled = false;
  int _activeDockIndex = 0;
  late ScrollController _scrollController;

  // Mock data
  late List<Document> recentDocuments;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _initializeMockData();
  }

  void _initializeMockData() {
    recentDocuments = [
      Document(
        id: '1',
        title: 'Q3 Product Roadmap',
        content:
            'The next quarter focuses on three pillars: editor performance, collaborative review flows, and expanding template coverage for technical documentation...',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastModifiedAt: DateTime.now().subtract(const Duration(hours: 2)),
        wordCount: 1204,
        syncStatus: SyncStatus.synced,
        preview:
            'The next quarter focuses on three pillars: editor performance, collaborative review flows, and expanding template coverage...',
      ),
      Document(
        id: '2',
        title: 'Design System v2.0',
        content: 'Complete redesign of core components with glassmorphism...',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        lastModifiedAt: DateTime.now().subtract(const Duration(hours: 5)),
        wordCount: 856,
        syncStatus: SyncStatus.syncing,
      ),
      Document(
        id: '3',
        title: 'Meeting Notes - July',
        content: 'Stakeholder feedback and feature priorities...',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastModifiedAt: DateTime.now().subtract(const Duration(days: 1)),
        wordCount: 523,
        syncStatus: SyncStatus.offline,
      ),
      Document(
        id: '4',
        title: 'API Documentation',
        content: 'Complete endpoint reference and authentication flows...',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastModifiedAt: DateTime.now().subtract(const Duration(days: 2)),
        wordCount: 2341,
        syncStatus: SyncStatus.synced,
      ),
    ];
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 40;
    if (isScrolled != _isHeaderScrolled) {
      setState(() => _isHeaderScrolled = isScrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? RaqimColors.charcoal900 : RaqimColors.ivory,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header
                DashboardHeader(
                  isScrolled: _isHeaderScrolled,
                  onProfileTap: () {
                    setState(() => _activeDockIndex = 4);
                  },
                ),
                const SizedBox(height: RaqimSpacing.space5),
                // Recent Documents Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RaqimSpacing.space4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent',
                            style: RaqimTypography.h2.copyWith(
                              color: isDark
                                  ? RaqimColors.ivory900
                                  : RaqimColors.slate900,
                            ),
                          ),
                          Text(
                            'See all',
                            style: RaqimTypography.bodyUI.copyWith(
                              color: RaqimColors.coral500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RaqimSpacing.space4),
                      // Carousel
                      SizedBox(
                        height: 320,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recentDocuments.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: RaqimSpacing.space3),
                          itemBuilder: (context, index) {
                            return RecentDocumentCard(
                              document: recentDocuments[index],
                              onTap: () {
                                // Navigate to editor
                              },
                              onLongPress: () {
                                // Show context menu
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RaqimSpacing.space7),
                // Quick Action Tiles
                QuickActionTiles(
                  onStartNew: () {
                    setState(() => _activeDockIndex = 2);
                  },
                  onExploreTemplates: () {
                    setState(() => _activeDockIndex = 3);
                  },
                ),
                const SizedBox(height: 100), // Bottom spacing for dock
              ],
            ),
          ),
          // Floating Dock
          FloatingGlassDock(
            activeIndex: _activeDockIndex,
            onItemTap: (index) {
              setState(() => _activeDockIndex = index);
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }
}
