import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/haptics.dart';
import '../../domain/article.dart';

final class EditArticleMetadataSheet extends ConsumerStatefulWidget {
  const EditArticleMetadataSheet({required this.article, super.key});

  final Article article;

  @override
  ConsumerState<EditArticleMetadataSheet> createState() =>
      _EditArticleMetadataSheetState();
}

final class _EditArticleMetadataSheetState
    extends ConsumerState<EditArticleMetadataSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _excerptController;
  late final TextEditingController _authorController;
  late final TextEditingController _siteNameController;
  late final TextEditingController _languageController;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final article = widget.article;
    _titleController = TextEditingController(text: article.title);
    _excerptController = TextEditingController(text: article.excerpt ?? '');
    _authorController = TextEditingController(text: article.author ?? '');
    _siteNameController = TextEditingController(text: article.siteName ?? '');
    _languageController = TextEditingController(text: article.language ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _authorController.dispose();
    _siteNameController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Haptics.medium();
    setState(() => _saving = true);
    final result = await ref
        .read(updateArticleMetadataUseCaseProvider)
        .execute(
          id: widget.article.id,
          title: _titleController.text,
          excerpt: _excerptController.text,
          author: _authorController.text,
          siteName: _siteNameController.text,
          language: _languageController.text,
        );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    result.fold(
      onSuccess: (_) => Navigator.of(context).pop(true),
      onFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            duration: const Duration(seconds: 4),
            dismissDirection: DismissDirection.horizontal,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Edit saved metadata. Article content remains unchanged.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              enabled: !_saving,
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a title.'
                  : null,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _excerptController,
              enabled: !_saving,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Excerpt'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _authorController,
              enabled: !_saving,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _siteNameController,
              enabled: !_saving,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Site name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _languageController,
              enabled: !_saving,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _saving ? null : _save(),
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
