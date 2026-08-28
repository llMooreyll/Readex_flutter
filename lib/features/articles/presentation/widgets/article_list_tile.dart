import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:read_it_later/features/articles/domain/article_list_item.dart';

import '../../../../app/motion.dart';

final class ArticleListTile extends StatelessWidget {
  const ArticleListTile({
    required this.article,
    required this.onTap,
    required this.onEdit,
    required this.onMarkRead,
    required this.onMarkUnread,
    required this.onDelete,
    super.key,
  });

  final ArticleListItem article;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onMarkRead;
  final VoidCallback onMarkUnread;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final host = Uri.tryParse(article.sourceUrl)?.host;
    final source = article.siteName?.trim().isNotEmpty == true
        ? article.siteName!
        : host ?? 'Saved webpage';
    final author = article.author?.trim();
    final readOpacity = article.isRead
        ? (theme.brightness == Brightness.dark ? 0.46 : 0.58)
        : 1.0;
    final excerpt = article.excerpt?.trim();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EventLine(
                    savedAt: article.savedAt,
                    readingTime: article.isLinkOnly
                        ? 'Link'
                        : '${article.estimatedReadingMinutes} min',
                    muted: article.isRead,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: scheme.onSurface.withValues(alpha: readOpacity),
                      height: 1.18,
                    ),
                  ),
                  if (excerpt != null && excerpt.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: readOpacity,
                        ),
                        height: 1.25,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  _SourceAndAuthorLine(
                    source: source,
                    author: author,
                    muted: article.isRead,
                  ),
                ],
              ),
            ),
            PopupMenuButton<_ArticleAction>(
              tooltip: 'Article actions',
              popUpAnimationStyle: AppMotion.popupMenu,
              onSelected: (action) {
                switch (action) {
                  case _ArticleAction.edit:
                    onEdit();
                  case _ArticleAction.markRead:
                    onMarkRead();
                  case _ArticleAction.markUnread:
                    onMarkUnread();
                  case _ArticleAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _ArticleAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit details'),
                  ),
                ),
                if (!article.isRead)
                  const PopupMenuItem(
                    value: _ArticleAction.markRead,
                    child: ListTile(
                      leading: Icon(Icons.mark_email_read_outlined),
                      title: Text('Mark as read'),
                    ),
                  ),
                if (article.isRead)
                  const PopupMenuItem(
                    value: _ArticleAction.markUnread,
                    child: ListTile(
                      leading: Icon(Icons.mark_email_unread_outlined),
                      title: Text('Mark as unread'),
                    ),
                  ),
                const PopupMenuItem(
                  value: _ArticleAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _EventLine extends StatelessWidget {
  const _EventLine({
    required this.savedAt,
    required this.readingTime,
    required this.muted,
  });

  final DateTime savedAt;
  final String readingTime;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opacity = muted
        ? (theme.brightness == Brightness.dark ? 0.54 : 0.7)
        : 1.0;
    return Text(
      '${DateFormat('MMM d, yyyy').format(savedAt)}  •  $readingTime',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelMedium?.copyWith(
        fontSize: 10,
        color: theme.colorScheme.primary.withValues(alpha: opacity),
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

final class _SourceAndAuthorLine extends StatelessWidget {
  const _SourceAndAuthorLine({
    required this.source,
    required this.author,
    required this.muted,
  });

  final String source;
  final String? author;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final opacity = muted
        ? (theme.brightness == Brightness.dark ? 0.54 : 0.7)
        : 1.0;
    final style = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 12,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: source,
            style: style?.copyWith(
              color: scheme.tertiary.withValues(alpha: opacity),
            ),
          ),
          if (author != null && author!.isNotEmpty) ...[
            TextSpan(
              text: '  •  ',
              style: style?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: opacity),
              ),
            ),
            TextSpan(
              text: author!,
              style: style?.copyWith(
                color: scheme.secondary.withValues(alpha: opacity),
              ),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

enum _ArticleAction { edit, markRead, markUnread, delete }
