import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../widgets/add_article_sheet.dart';
import '../widgets/article_list_tile.dart';
import '../widgets/library_empty_state.dart';

final class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  Future<void> _showAddArticle(BuildContext context) async {
    final id = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const AddArticleSheet(),
    );
    if (id != null && context.mounted) {
      context.push('/article/$id');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articleListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Read It Later')),
      body: articles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            _ErrorState(onRetry: () => ref.invalidate(articleListProvider)),
        data: (items) {
          if (items.isEmpty) {
            return LibraryEmptyState(
              onAddArticle: () => _showAddArticle(context),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(articleListProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final article = items[index];
                return ArticleListTile(
                  article: article,
                  onTap: () => context.push('/article/${article.id}'),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddArticle(context),
        icon: const Icon(Icons.add),
        label: const Text('Add article'),
      ),
    );
  }
}

final class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 16),
            const Text(
              'The library could not be loaded.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
