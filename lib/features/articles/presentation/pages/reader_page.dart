import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
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
    return article.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const _NotFoundPage(),
      data: (value) => value == null
          ? const _NotFoundPage()
          : _ReaderContent(article: value),
    );
  }
}

final class _ReaderContent extends StatelessWidget {
  const _ReaderContent({required this.article});

  final Article article;

  Future<bool> _openUrl(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme.toLowerCase() != 'https') {
      return true;
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        ],
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
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
                  HtmlWidget(
                    article.contentHtml,
                    baseUrl: Uri.parse(article.resolvedUrl),
                    factoryBuilder: () => _ArticleHtmlWidgetFactory(
                      referrer: article.resolvedUrl,
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

final class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

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
