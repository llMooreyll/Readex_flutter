import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:read_it_later/app/responsive.dart';
import 'package:read_it_later/app/providers.dart';
import 'package:read_it_later/features/articles/domain/article.dart';
import 'package:url_launcher/url_launcher.dart';

final class ReaderPage extends ConsumerWidget {
  const ReaderPage({required this.id, super.key});

  const ReaderPage.invalidId({super.key}) : id = null;

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleId = id;
    if (articleId == null) {
      return const _NotFoundPage();
    }

    final article = ref.watch(articleByIdProvider(articleId));
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: article.when(
        loading: () => const Scaffold(
          key: ValueKey('loading'),
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) =>
            const _NotFoundPage(key: ValueKey('error')),
        data: (value) => value == null
            ? const _NotFoundPage(key: ValueKey('not-found'))
            : _ReaderContent(key: ValueKey(value.id), article: value),
      ),
    );
  }
}

final class _ReaderContent extends ConsumerWidget {
  const _ReaderContent({required this.article, super.key});

  final Article article;

  Future<bool> _openUrl(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme.toLowerCase() != 'https') {
      return true;
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _deleteArticle(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete article?'),
        content: const Text(
          'This saved article will be removed from your library.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(deleteArticleUseCaseProvider).execute(article.id);
    if (context.mounted) {
      context.go('/');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Article deleted.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailSpec = context.layoutType(ResponsivePageType.detail);
    final metadata = [
      if (article.siteName?.trim().isNotEmpty == true) article.siteName!,
      if (article.author?.trim().isNotEmpty == true) article.author!,
      if (article.publishedAt != null)
        DateFormat('MMM d, yyyy').format(article.publishedAt!),
      '${article.estimatedReadingMinutes} min read',
    ].join('  •  ');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () => launchUrl(
              Uri.parse(article.resolvedUrl),
              mode: LaunchMode.externalApplication,
            ),
            tooltip: 'Open original',
            icon: const Icon(Icons.open_in_new),
          ),
          PopupMenuButton<_ReaderAction>(
            tooltip: 'Article actions',
            onSelected: (action) {
              switch (action) {
                case _ReaderAction.delete:
                  _deleteArticle(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _ReaderAction.delete,
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            detailSpec.horizontalPadding,
            24,
            detailSpec.horizontalPadding,
            48,
          ),
          child: ResponsivePageContainer(
            pageType: ResponsivePageType.detail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (metadata.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    metadata,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                if (article.isLinkOnly)
                  _LinkOnlyArticle(article: article)
                else
                  HtmlWidget(
                    article.contentHtml,
                    baseUrl: Uri.parse(article.resolvedUrl),
                    factoryBuilder: () => _ArticleHtmlWidgetFactory(
                      referrer: article.resolvedUrl,
                    ),
                    customStylesBuilder: (element) =>
                        _articleStyles(element, theme),
                    onTapImage: (image) {
                      final source = image.sources.firstOrNull;
                      if (source != null) {
                        launchUrl(
                          Uri.parse(source.url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    onErrorBuilder: (context, element, error) => Container(
                      constraints: const BoxConstraints(minHeight: 80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onTapUrl: _openUrl,
                    renderMode: RenderMode.column,
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.65,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ReaderAction { delete }

final class _LinkOnlyArticle extends StatelessWidget {
  const _LinkOnlyArticle({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.bookmark_added_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Saved link',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Readable article content was not available, so this item was saved as a link.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => launchUrl(
                Uri.parse(article.resolvedUrl),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in browser'),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ArticleHtmlWidgetFactory extends WidgetFactory {
  _ArticleHtmlWidgetFactory({required this.referrer});

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
        'User-Agent': 'ReadItLater/1.0 (Flutter; Android) AppleWebKit/537.36',
      },
    );
  }
}

Map<String, String>? _articleStyles(dom.Element element, ThemeData theme) {
  final scheme = theme.colorScheme;
  final primary = _cssColor(scheme.primary);
  final onSurface = _cssColor(scheme.onSurface);
  final muted = _cssColor(scheme.onSurfaceVariant);
  final lowSurface = _cssColor(scheme.surfaceContainerLow);
  final highestSurface = _cssColor(scheme.surfaceContainerHighest);
  final outline = _cssColor(scheme.outlineVariant);

  switch (element.localName) {
    case 'p':
      return {'margin-bottom': '14px'};
    case 'h1':
      return {
        'margin-top': '28px',
        'margin-bottom': '14px',
        'font-weight': '800',
      };
    case 'h2':
      return {
        'margin-top': '26px',
        'margin-bottom': '12px',
        'font-weight': '800',
      };
    case 'h3':
      return {
        'margin-top': '22px',
        'margin-bottom': '10px',
        'font-weight': '750',
      };
    case 'h4':
    case 'h5':
    case 'h6':
      return {
        'margin-top': '18px',
        'margin-bottom': '8px',
        'font-weight': '700',
      };
    case 'a':
      return {'color': primary, 'text-decoration': 'underline'};
    case 'blockquote':
      return {
        'margin': '18px 0',
        'padding': '12px 16px',
        'border-left': '4px solid $primary',
        'background-color': lowSurface,
        'color': muted,
      };
    case 'pre':
      return {
        'margin': '18px 0',
        'padding': '16px',
        'background-color': highestSurface,
        'border': '1px solid $outline',
        'border-radius': '10px',
        'white-space': 'pre-wrap',
      };
    case 'code':
      return {
        'font-family': 'monospace',
        'background-color': highestSurface,
        'color': onSurface,
      };
    case 'figure':
      return {'margin': '20px 0'};
    case 'figcaption':
      return {
        'margin-top': '8px',
        'color': muted,
        'font-size': '0.9em',
        'text-align': 'center',
      };
    case 'img':
      return {'max-width': '100%', 'height': 'auto'};
    case 'table':
      return {'margin': '18px 0', 'border': '1px solid $outline'};
    case 'th':
      return {
        'padding': '8px',
        'background-color': lowSurface,
        'border': '1px solid $outline',
        'font-weight': '700',
      };
    case 'td':
      return {'padding': '8px', 'border': '1px solid $outline'};
    case 'ul':
    case 'ol':
      return {'margin-bottom': '14px'};
    case 'hr':
      return {'margin': '24px 0', 'border-color': outline};
  }
  return null;
}

String _cssColor(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

final class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.article_outlined, size: 48),
              const SizedBox(height: 16),
              const Text('Article not found.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
