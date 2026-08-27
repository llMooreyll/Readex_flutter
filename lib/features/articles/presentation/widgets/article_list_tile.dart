import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:read_it_later/features/articles/domain/article_list_item.dart';

final class ArticleListTile extends StatelessWidget {
  const ArticleListTile({
    required this.article,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final ArticleListItem article;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final host = Uri.tryParse(article.sourceUrl)?.host;
    final source = article.siteName?.trim().isNotEmpty == true
        ? article.siteName!
        : host ?? 'Saved webpage';
    final byline = article.author?.trim();
    final details = [
      source,
      if (byline != null && byline.isNotEmpty) byline,
      DateFormat('MMM d, yyyy').format(article.savedAt),
      article.isLinkOnly
          ? 'Saved link'
          : '${article.estimatedReadingMinutes} min read',
    ].join('  •  ');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
      title: Text(
        article.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (article.excerpt?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(
                article.excerpt!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      trailing: PopupMenuButton<_ArticleAction>(
        tooltip: 'Article actions',
        onSelected: (action) {
          switch (action) {
            case _ArticleAction.delete:
              onDelete();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _ArticleAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ArticleAction { delete }
