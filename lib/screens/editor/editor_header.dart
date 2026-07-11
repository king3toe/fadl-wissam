/// Editor Screen Header - Minimal, editable title + options menu.
/// Title taps to expand for editing. Options menu contains Undo, Redo, Share, Export, etc.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

class EditorHeader extends StatefulWidget {
  final String title;
  final Function(String) onTitleChanged;
  final VoidCallback onMoreOptions;

  const EditorHeader({
    Key? key,
    required this.title,
    required this.onTitleChanged,
    required this.onMoreOptions,
  }) : super(key: key);

  @override
  State<EditorHeader> createState() => _EditorHeaderState();
}

class _EditorHeaderState extends State<EditorHeader> {
  late TextEditingController _titleController;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RaqimSpacing.space4,
          vertical: RaqimSpacing.space4,
        ),
        child: Row(
          children: [
            // Editable Title
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEditingTitle = true),
                child: _isEditingTitle
                    ? TextField(
                        controller: _titleController,
                        style: RaqimTypography.h2.copyWith(
                          color: isDark
                              ? RaqimColors.ivory900
                              : RaqimColors.slate900,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: RaqimColors.coral500,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (value) {
                          widget.onTitleChanged(value);
                          setState(() => _isEditingTitle = false);
                        },
                        onEditingComplete: () {
                          widget.onTitleChanged(_titleController.text);
                          setState(() => _isEditingTitle = false);
                        },
                      )
                    : Text(
                        widget.title,
                        style: RaqimTypography.h2.copyWith(
                          color: isDark
                              ? RaqimColors.ivory900
                              : RaqimColors.slate900,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: RaqimSpacing.space3),
            // More Options Menu
            GestureDetector(
              onTap: widget.onMoreOptions,
              child: Padding(
                padding: const EdgeInsets.all(RaqimSpacing.space2),
                child: Icon(
                  Icons.more_vert,
                  size: 24,
                  color: isDark
                      ? RaqimColors.ivory600
                      : RaqimColors.slate600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
