/// Editor Screen (Mobile) - Minimal canvas, distraction-free writing.
/// Edge-to-edge text input. Contextual toolbar on selection.
/// Minimal "+" block inserter above keyboard.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import 'editor_header.dart';
import 'contextual_formatting_toolbar.dart';

class EditorScreen extends StatefulWidget {
  final String documentId;
  final String initialTitle;
  final String initialContent;

  const EditorScreen({
    Key? key,
    required this.documentId,
    this.initialTitle = 'Untitled',
    this.initialContent = '',
  }) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late FocusNode _contentFocusNode;
  Offset? _toolbarPosition;
  bool _showToolbar = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    _contentFocusNode = FocusNode();
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Detect selection changes and update toolbar position
    final selection = _contentController.selection;
    if (selection.baseOffset != selection.extentOffset) {
      // Text is selected
      _updateToolbarPosition();
      setState(() => _showToolbar = true);
    } else {
      setState(() => _showToolbar = false);
    }
  }

  void _updateToolbarPosition() {
    // Calculate position above the selection
    // This would integrate with the text rendering metrics
    final size = MediaQuery.of(context).size;
    setState(() {
      _toolbarPosition = Offset(
        size.width / 2 - 80, // Center the toolbar
        100, // Approximate position (would use RenderObject metrics in real impl)
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
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
            child: Column(
              children: [
                // Header
                EditorHeader(
                  title: _titleController.text,
                  onTitleChanged: (newTitle) {
                    _titleController.text = newTitle;
                  },
                  onMoreOptions: () {
                    // Show options menu
                    _showOptionsMenu();
                  },
                ),
                // Canvas
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RaqimSpacing.space5,
                    vertical: RaqimSpacing.space5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Document Title Display
                      Text(
                        widget.initialTitle,
                        style: RaqimTypography.display.copyWith(
                          color: isDark
                              ? RaqimColors.ivory900
                              : RaqimColors.slate900,
                        ),
                      ),
                      const SizedBox(height: RaqimSpacing.space6),
                      // Editable Content
                      TextField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        maxLines: null,
                        expands: false,
                        style: RaqimTypography.bodyDoc.copyWith(
                          color: isDark
                              ? RaqimColors.ivory900
                              : RaqimColors.slate900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start writing...',
                          hintStyle: RaqimTypography.bodyDoc.copyWith(
                            color: isDark
                                ? RaqimColors.ivory600
                                : RaqimColors.slate400,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: RaqimSpacing.space8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contextual Formatting Toolbar
          ContextualFormattingToolbar(
            position: _toolbarPosition,
            isVisible: _showToolbar,
            onFormatApplied: (format) {
              // Apply text formatting
            },
            onDismiss: () {
              setState(() => _showToolbar = false);
            },
          ),
          // Minimal "+" Block Inserter
          Positioned(
            bottom: 16,
            right: 16,
            child: _BlockInserterButton(
              onTap: _showBlockInserterMenu,
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockInserterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _BlockInserterSheet(),
    );
  }

  void _showOptionsMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 100, 0, 0),
      items: [
        PopupMenuItem(
          child: const Text('Undo'),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Text('Redo'),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Text('Share'),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Text('Export'),
          onTap: () {},
        ),
      ],
    );
  }
}

class _BlockInserterButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BlockInserterButton({required this.onTap});

  @override
  State<_BlockInserterButton> createState() => _BlockInserterButtonState();
}

class _BlockInserterButtonState extends State<_BlockInserterButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: RaqimColors.coral500,
            borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
            boxShadow: RaqimShadows.floatShadow,
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockInserterSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RaqimSpacing.space5),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          _BlockOption(icon: Icons.image, label: 'Image', onTap: () {}),
          _BlockOption(icon: Icons.list, label: 'List', onTap: () {}),
          _BlockOption(
            icon: Icons.checklist,
            label: 'Checklist',
            onTap: () {},
          ),
          _BlockOption(icon: Icons.horizontal_rule, label: 'Divider', onTap: () {}),
          _BlockOption(icon: Icons.table_chart, label: 'Table', onTap: () {}),
          _BlockOption(icon: Icons.code, label: 'Code', onTap: () {}),
        ],
      ),
    );
  }
}

class _BlockOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BlockOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: RaqimColors.coral500),
          const SizedBox(height: RaqimSpacing.space2),
          Text(
            label,
            style: RaqimTypography.caption,
          ),
        ],
      ),
    );
  }
}
