import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/responsive.dart';
import '../../../../app/responsive_navigation.dart';
import '../../../../app/providers.dart';
import '../widgets/add_article_sheet.dart';
import '../widgets/article_list_tile.dart';
import '../widgets/library_empty_state.dart';

final class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  Future<void> _showAddArticle(BuildContext context) async {
    final id = await ResponsiveNavigation.showAdaptiveModalPage<int>(
      context: context,
      child: const AddArticleSheet(),
    );
    if (id != null && context.mounted) {
      context.push('/article/$id');
    }
  }

  Future<void> _deleteArticle(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
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

    await ref.read(deleteArticleUseCaseProvider).execute(id);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Article deleted.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articleListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Read It Later')),
      body: ResponsivePageContainer(
        pageType: ResponsivePageType.browse,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context
                .layoutType(ResponsivePageType.browse)
                .horizontalPadding,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: articles.when(
              loading: () => const Center(
                key: ValueKey('loading'),
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _ErrorState(
                key: const ValueKey('error'),
                onRetry: () => ref.invalidate(articleListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return LibraryEmptyState(
                    key: const ValueKey('empty'),
                    onAddArticle: () => _showAddArticle(context),
                  );
                }
                return RefreshIndicator(
                  key: const ValueKey('data'),
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
                        onDelete: () =>
                            _deleteArticle(context, ref, article.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
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
  const _ErrorState({required this.onRetry, super.key});

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
