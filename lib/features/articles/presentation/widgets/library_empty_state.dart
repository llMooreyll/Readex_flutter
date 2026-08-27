import 'package:flutter/material.dart';

final class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({required this.onAddArticle, super.key});

  final VoidCallback onAddArticle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Your library is empty',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Save an article to read it later, even when you are offline.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddArticle,
              icon: const Icon(Icons.add),
              label: const Text('Add your first article'),
            ),
          ],
        ),
      ),
    );
  }
}
