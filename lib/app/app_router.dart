import 'package:go_router/go_router.dart';

import '../features/articles/presentation/pages/library_page.dart';
import '../features/articles/presentation/pages/reader_page.dart';
import 'app_transitions.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          AppTransitions.fade(state: state, child: const LibraryPage()),
    ),
    GoRoute(
      path: '/article/:id',
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        final child = id == null
            ? const ReaderPage.invalidId()
            : ReaderPage(id: id);
        return AppTransitions.sharedAxis(state: state, child: child);
      },
    ),
  ],
);
