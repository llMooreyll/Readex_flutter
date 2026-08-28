import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_it_later/app/providers.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';

final class ArticlePreviewSheet extends ConsumerStatefulWidget {
  const ArticlePreviewSheet({required this.draft, super.key});

  final ArticleDraft draft;

  @override
  ConsumerState<ArticlePreviewSheet> createState() =>
      _ArticlePreviewSheetState();
}

final class _ArticlePreviewSheetState
    extends ConsumerState<ArticlePreviewSheet> {
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
    final draft = widget.draft;
    _titleController = TextEditingController(text: draft.title);
    _excerptController = TextEditingController(text: draft.excerpt ?? '');
    _authorController = TextEditingController(text: draft.author ?? '');
    _siteNameController = TextEditingController(text: draft.siteName ?? '');
    _languageController = TextEditingController(text: draft.language ?? '');
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
    setState(() => _saving = true);
    final draft = widget.draft.withMetadata(
      title: _titleController.text,
      excerpt: _excerptController.text,
      author: _authorController.text,
      siteName: _siteNameController.text,
      language: _languageController.text,
    );
    final id = await ref
        .read(saveArticleControllerProvider.notifier)
        .saveDraft(draft);
    if (!mounted) {
      return;
    }
    if (id != null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saveArticleControllerProvider);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final draft = widget.draft;
    final availableHeight = MediaQuery.sizeOf(context).height - bottomInset;

    return SizedBox(
      height: availableHeight.clamp(320.0, 760.0).toDouble() * 0.86,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Review article',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Edit the saved metadata before adding this article to your library.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MetadataField(
                        controller: _titleController,
                        label: 'Title',
                        enabled: !_saving,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter a title.'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      _MetadataField(
                        controller: _excerptController,
                        label: 'Excerpt',
                        enabled: !_saving,
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10),
                      _MetadataField(
                        controller: _authorController,
                        label: 'Author',
                        enabled: !_saving,
                      ),
                      const SizedBox(height: 10),
                      _MetadataField(
                        controller: _siteNameController,
                        label: 'Site name',
                        enabled: !_saving,
                      ),
                      const SizedBox(height: 10),
                      _MetadataField(
                        controller: _languageController,
                        label: 'Language',
                        enabled: !_saving,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Content preview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: draft.contentHtml.isEmpty
                              ? Text(
                                  'This will be saved as a link-only article.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : HtmlWidget(
                                  draft.contentHtml,
                                  baseUrl: Uri.tryParse(draft.resolvedUrl),
                                  factoryBuilder: () =>
                                      _PreviewHtmlWidgetFactory(
                                        referrer: draft.resolvedUrl,
                                      ),
                                  renderMode: RenderMode.column,
                                  buildAsync: true,
                                  textStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(height: 1.55),
                                  onLoadingBuilder:
                                      (context, element, progress) =>
                                          const Padding(
                                            padding: EdgeInsets.all(24),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                  onErrorBuilder: (context, element, error) =>
                                      const _PreviewPlaceholder(),
                                ),
                        ),
                      ),
                      if (state.failure != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.failure!.message,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: bottomInset + 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saving
                              ? null
                              : () => Navigator.of(context).pop(false),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Discard'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PreviewHtmlWidgetFactory extends WidgetFactory {
  _PreviewHtmlWidgetFactory({required this.referrer});

  final String referrer;

  @override
  ImageProvider? imageProviderFromNetwork(String url) {
    if (url.isEmpty) {
      return null;
    }
    return NetworkImage(
      url,
      headers: {
        'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*',
        'Referer': referrer,
        'User-Agent': 'Readex/1.0 (Flutter; Android) AppleWebKit/537.36',
      },
    );
  }
}

final class _MetadataField extends StatelessWidget {
  const _MetadataField({
    required this.controller,
    required this.label,
    required this.enabled,
    this.minLines,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final int? minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}

final class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
