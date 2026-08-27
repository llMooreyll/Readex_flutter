import 'package:go_router/go_router.dart';

import '../features/articles/presentation/pages/library_page.dart';
import '../features/articles/presentation/pages/reader_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LibraryPage()),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const ReaderPage.invalidId();
        }
        return ReaderPage(id: id);
      },
    ),
  ],
);
