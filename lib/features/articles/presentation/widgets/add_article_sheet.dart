import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';

final class AddArticleSheet extends ConsumerStatefulWidget {
  const AddArticleSheet({super.key});

  @override
  ConsumerState<AddArticleSheet> createState() => _AddArticleSheetState();
}

final class _AddArticleSheetState extends ConsumerState<AddArticleSheet> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pasteUrl() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      return;
    }
    _urlController
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    setState(() {});
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    final id = await ref
        .read(saveArticleControllerProvider.notifier)
        .save(_urlController.text);
    if (id != null && mounted) {
      Navigator.of(context).pop(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saveArticleControllerProvider);
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
              'Add article',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a webpage URL to extract and save its readable content.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _urlController,
              enabled: !state.isSaving,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              enableSuggestions: false,
              onFieldSubmitted: (_) => _save(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a URL.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Article URL',
                hintText: 'https://example.com/article',
                suffixIcon: IconButton(
                  onPressed: state.isSaving ? null : _pasteUrl,
                  tooltip: 'Paste URL',
                  icon: const Icon(Icons.content_paste),
                ),
              ),
            ),
            if (state.failure != null) ...[
              const SizedBox(height: 12),
              Text(
                state.failure!.message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (state.isSaving) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.progressLabel)),
                ],
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: state.isSaving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save article'),
            ),
          ],
        ),
      ),
    );
  }
}
