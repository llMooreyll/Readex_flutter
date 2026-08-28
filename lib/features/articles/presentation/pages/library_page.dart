import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/responsive.dart';
import '../../../../app/responsive_navigation.dart';
import '../../../../app/motion.dart';
import '../../../../app/haptics.dart';
import '../../../../app/snackbar.dart';
import '../../../../app/theme_mode_menu.dart';
import '../../domain/article_list_item.dart';
import '../widgets/add_article_sheet.dart';
import '../widgets/article_list_tile.dart';
import '../widgets/edit_article_metadata_sheet.dart';
import '../widgets/library_empty_state.dart';

enum LibraryView { active, archived }

final class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

final class _LibraryPageState extends ConsumerState<LibraryPage> {
  LibraryView _view = LibraryView.active;

  Future<void> _showAddArticle() async {
    await ResponsiveNavigation.showAdaptiveModalPage<void>(
      context: context,
      child: const AddArticleSheet(),
    );
  }

  Future<void> _editArticle(int id) async {
    final article = await ref.read(articleRepositoryProvider).getById(id);
    if (article == null || !mounted) {
      return;
    }

    final saved = await ResponsiveNavigation.showAdaptiveModalPage<bool>(
      context: context,
      child: EditArticleMetadataSheet(article: article),
    );
    if (saved == true && mounted) {
      ref.invalidate(articleByIdProvider(id));
      showAutoDismissSnackBar(context, message: 'Article details updated.');
    }
  }

  Future<bool> _archiveArticle(ArticleListItem article) async {
    final archiveUseCase = ref.read(archiveArticleUseCaseProvider);
    if (article.isArchived) {
      await archiveUseCase.unarchive(article.id);
      if (mounted) {
        _showUndoSnackBar(
          message: 'Article restored to library.',
          actionLabel: 'Undo',
          onUndo: () => archiveUseCase.archive(article.id),
        );
      }
      return true;
    } else {
      await archiveUseCase.archive(article.id);
      if (mounted) {
        _showUndoSnackBar(
          message: 'Article archived.',
          actionLabel: 'Undo',
          onUndo: () => archiveUseCase.unarchive(article.id),
        );
      }
      return true;
    }
  }

  Future<bool> _deleteArticle(ArticleListItem article) async {
    final deleteUseCase = ref.read(deleteArticleUseCaseProvider);
    final deleted = await deleteUseCase.execute(article.id);
    if (deleted != null && mounted) {
      _showUndoSnackBar(
        message: 'Article deleted.',
        actionLabel: 'Undo',
        onUndo: () => deleteUseCase.undo(deleted),
      );
    }
    return deleted != null;
  }

  Future<void> _markArticleUnread(ArticleListItem article) async {
    await ref.read(markArticleReadUseCaseProvider).markAsUnread(article.id);
    ref.invalidate(articleByIdProvider(article.id));
    if (!mounted) {
      return;
    }

    showAutoDismissSnackBar(context, message: 'Article marked as unread.');
  }

  Future<void> _markArticleRead(ArticleListItem article) async {
    await ref.read(markArticleReadUseCaseProvider).markAsRead(article.id);
    ref.invalidate(articleByIdProvider(article.id));
    if (!mounted) {
      return;
    }

    showAutoDismissSnackBar(context, message: 'Article marked as read.');
  }

  void _showUndoSnackBar({
    required String message,
    required String actionLabel,
    required FutureOr<void> Function() onUndo,
  }) {
    showAutoDismissSnackBar(
      context,
      message: message,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () {
          unawaited(Future<void>.sync(onUndo));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = _view == LibraryView.active
        ? articleListProvider
        : archivedArticleListProvider;
    final articles = ref.watch(provider);
    final spec = context.layoutType(ResponsivePageType.browse);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 104,
        title: Text(
          'Read It Later',
          style: Theme.of(context).textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0),
        ),
        actions: const [ThemeModeMenu()],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ResponsivePageContainer(
              pageType: ResponsivePageType.browse,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  spec.horizontalPadding,
                  0,
                  spec.horizontalPadding,
                  0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: articles.when(
                          loading: () => const Center(
                            key: ValueKey('loading'),
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) => _ErrorState(
                            key: const ValueKey('error'),
                            onRetry: () => ref.invalidate(provider),
                          ),
                          data: (items) {
                            if (items.isEmpty) {
                              return LibraryEmptyState(
                                key: ValueKey('empty-${_view.name}'),
                                title: _view == LibraryView.active
                                    ? 'Your library is empty'
                                    : 'No archived articles',
                                message: _view == LibraryView.active
                                    ? 'Save an article to read it later, even when you are offline.'
                                    : 'Archived articles will appear here.',
                                actionLabel: _view == LibraryView.active
                                    ? 'Add your first article'
                                    : null,
                                onAddArticle: _view == LibraryView.active
                                    ? _showAddArticle
                                    : null,
                              );
                            }
                            return _AnimatedArticleList(
                              key: ValueKey('data-${_view.name}'),
                              articles: items,
                              view: _view,
                              bottomSpacerHeight:
                                  MediaQuery.paddingOf(context).bottom + 124,
                              onTap: (article) =>
                                  context.push('/article/${article.id}'),
                              onEdit: (article) => _editArticle(article.id),
                              onMarkRead: _markArticleRead,
                              onMarkUnread: _markArticleUnread,
                              onArchive: _archiveArticle,
                              onDelete: _deleteArticle,
                              onRefresh: () async => ref.invalidate(provider),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _LibraryBottomBar(
              view: _view,
              onViewChanged: (view) => setState(() => _view = view),
              onAddArticle: _showAddArticle,
            ),
          ),
        ],
      ),
    );
  }
}

final class _AnimatedArticleList extends StatefulWidget {
  const _AnimatedArticleList({
    required this.articles,
    required this.view,
    required this.bottomSpacerHeight,
    required this.onTap,
    required this.onEdit,
    required this.onMarkRead,
    required this.onMarkUnread,
    required this.onArchive,
    required this.onDelete,
    required this.onRefresh,
    super.key,
  });

  final List<ArticleListItem> articles;
  final LibraryView view;
  final double bottomSpacerHeight;
  final void Function(ArticleListItem article) onTap;
  final void Function(ArticleListItem article) onEdit;
  final Future<void> Function(ArticleListItem article) onMarkRead;
  final Future<void> Function(ArticleListItem article) onMarkUnread;
  final Future<bool> Function(ArticleListItem article) onArchive;
  final Future<bool> Function(ArticleListItem article) onDelete;
  final Future<void> Function() onRefresh;

  @override
  State<_AnimatedArticleList> createState() => _AnimatedArticleListState();
}

final class _AnimatedArticleListState extends State<_AnimatedArticleList> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _pendingRemovalEffects = <int, _RemovalEffectDetails>{};
  final _removingIds = <int>{};
  late List<ArticleListItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.articles);
  }

  @override
  void didUpdateWidget(covariant _AnimatedArticleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncItems(widget.articles);
  }

  void _syncItems(List<ArticleListItem> nextItems) {
    final nextIds = nextItems.map((item) => item.id).toSet();
    for (var index = _items.length - 1; index >= 0; index--) {
      final item = _items[index];
      if (!nextIds.contains(item.id)) {
        // A swipe owns the removal animation after its repository action
        // completes. Do not let the repository stream remove the same row
        // while the swipe callback is still running.
        if (_pendingRemovalEffects.containsKey(item.id)) {
          continue;
        }
        _removeItemAt(index, item.id);
      }
    }

    // Keep the pending row at its current index until the action callback
    // removes it. Reordering the remaining rows here would reuse the
    // pending row's swipe state for a different article and remove the wrong
    // AnimatedList index later.
    if (_pendingRemovalEffects.isNotEmpty) {
      for (final next in nextItems) {
        final currentIndex = _items.indexWhere((item) => item.id == next.id);
        if (currentIndex != -1) {
          _items[currentIndex] = next;
        }
      }
      return;
    }

    for (var index = 0; index < nextItems.length; index++) {
      final next = nextItems[index];
      final currentIndex = _items.indexWhere((item) => item.id == next.id);
      if (currentIndex == -1) {
        _removingIds.remove(next.id);
        _items.insert(index, next);
        _listKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 260),
        );
        continue;
      }

      _items[currentIndex] = next;
      if (currentIndex != index) {
        final moved = _items.removeAt(currentIndex);
        _items.insert(index, moved);
      }
    }
  }

  void _removeItemAt(int index, int id) {
    if (_removingIds.contains(id) ||
        index < 0 ||
        index >= _items.length ||
        _items[index].id != id) {
      return;
    }
    _removingIds.add(id);
    _items.removeAt(index);
    final effect =
        _pendingRemovalEffects.remove(id) ??
        const _RemovalEffectDetails(effect: _RemovalEffect.delete, height: 104);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _RemovedArticleListItem(
        effect: effect.effect,
        height: effect.height,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 340),
    );
  }

  void _removeItemAfterAction(int id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _removeItemAt(index, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: AnimatedList.separated(
        key: _listKey,
        initialItemCount: _items.length,
        padding: EdgeInsets.only(bottom: widget.bottomSpacerHeight),
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index, animation) =>
            const Divider(height: 1),
        removedSeparatorBuilder: (context, index, animation) => SizeTransition(
          sizeFactor: animation,
          child: const Divider(height: 1),
        ),
        itemBuilder: (context, index, animation) {
          final article = _items[index];
          return SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: FadeTransition(
              opacity: animation,
              child: _DismissibleArticleListItem(
                article: article,
                view: widget.view,
                onTap: () => widget.onTap(article),
                onEdit: () => widget.onEdit(article),
                onMarkRead: () => unawaited(widget.onMarkRead(article)),
                onMarkUnread: () => unawaited(widget.onMarkUnread(article)),
                onArchive: () async {
                  final confirmed = await widget.onArchive(article);
                  if (confirmed && mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _removeItemAfterAction(article.id);
                      }
                    });
                  }
                  return confirmed;
                },
                onDelete: () async {
                  final confirmed = await widget.onDelete(article);
                  if (confirmed && mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _removeItemAfterAction(article.id);
                      }
                    });
                  }
                  return confirmed;
                },
                onDismissStarted: (effect, height) {
                  _pendingRemovalEffects[article.id] = _RemovalEffectDetails(
                    effect: effect,
                    height: height,
                  );
                },
                onDismissCancelled: () {
                  _pendingRemovalEffects.remove(article.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _LibraryBottomBar extends StatelessWidget {
  const _LibraryBottomBar({
    required this.view,
    required this.onViewChanged,
    required this.onAddArticle,
  });

  final LibraryView view;
  final ValueChanged<LibraryView> onViewChanged;
  final VoidCallback onAddArticle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const navigationRadius = 36.0;
    const addButtonRadius = 22.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Material(
              color: scheme.surfaceContainerHigh,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(navigationRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LibraryNavigationButton(
                      selected: view == LibraryView.active,
                      borderRadius: navigationRadius,
                      icon: Icons.inbox_outlined,
                      selectedIcon: Icons.inbox,
                      tooltip: 'Library',
                      onPressed: () => onViewChanged(LibraryView.active),
                    ),
                    _LibraryNavigationButton(
                      selected: view == LibraryView.archived,
                      borderRadius: navigationRadius,
                      icon: Icons.archive_outlined,
                      selectedIcon: Icons.archive,
                      tooltip: 'Archived',
                      onPressed: () => onViewChanged(LibraryView.archived),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _PressScale(
            pressedScale: 1.07,
            child: Material(
              color: scheme.primaryContainer,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(addButtonRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(addButtonRadius),
                onTap: () {
                  Haptics.light();
                  onAddArticle();
                },
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: Icon(
                    Icons.add,
                    size: 34,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _LibraryNavigationButton extends StatefulWidget {
  const _LibraryNavigationButton({
    required this.selected,
    required this.borderRadius,
    required this.icon,
    required this.selectedIcon,
    required this.tooltip,
    required this.onPressed,
  });

  final bool selected;
  final double borderRadius;
  final IconData icon;
  final IconData selectedIcon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_LibraryNavigationButton> createState() =>
      _LibraryNavigationButtonState();
}

final class _LibraryNavigationButtonState
    extends State<_LibraryNavigationButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController = AnimationController(
    duration: const Duration(milliseconds: 240),
    vsync: this,
  );
  late final Animation<double> _pressProgress = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 42,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 1,
        end: 0,
      ).chain(CurveTween(curve: Curves.easeInOutCubic)),
      weight: 58,
    ),
  ]).animate(_pressController);

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _playPressAnimation() {
    Haptics.selection();
    _pressController
      ..stop()
      ..forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: widget.tooltip,
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _playPressAnimation,
          child: SizedBox(
            width: 72,
            height: 56,
            child: Center(
              child: AnimatedBuilder(
                animation: _pressProgress,
                builder: (context, child) {
                  final progress = _pressProgress.value;
                  return Container(
                    width: 68 + (4 * progress),
                    height: 52 + (4 * progress),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.selected
                          ? Color.lerp(
                              scheme.secondaryContainer,
                              scheme.onSecondaryContainer,
                              0.08 * progress,
                            )
                          : Color.lerp(
                              Colors.transparent,
                              scheme.onSurface.withValues(alpha: 0.12),
                              progress,
                            ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Transform.scale(
                      scale: 1 - (0.06 * progress),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  widget.selected ? widget.selectedIcon : widget.icon,
                  size: 28,
                  color: widget.selected
                      ? scheme.onSecondaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _PressScale extends StatefulWidget {
  const _PressScale({required this.child, required this.pressedScale});

  final Widget child;
  final double pressedScale;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

final class _PressScaleState extends State<_PressScale> {
  var _pressed = false;

  void _setPressed(bool pressed) {
    if (mounted && _pressed != pressed) {
      setState(() => _pressed = pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

enum _RemovalEffect { archive, delete }

final class _RemovalEffectDetails {
  const _RemovalEffectDetails({required this.effect, required this.height});

  final _RemovalEffect effect;
  final double height;
}

final class _DismissibleArticleListItem extends StatefulWidget {
  const _DismissibleArticleListItem({
    required this.article,
    required this.view,
    required this.onTap,
    required this.onEdit,
    required this.onMarkRead,
    required this.onMarkUnread,
    required this.onArchive,
    required this.onDelete,
    required this.onDismissStarted,
    required this.onDismissCancelled,
  });

  final ArticleListItem article;
  final LibraryView view;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onMarkRead;
  final VoidCallback onMarkUnread;
  final Future<bool> Function() onArchive;
  final Future<bool> Function() onDelete;
  final void Function(_RemovalEffect effect, double height) onDismissStarted;
  final VoidCallback onDismissCancelled;

  @override
  State<_DismissibleArticleListItem> createState() =>
      _DismissibleArticleListItemState();
}

final class _DismissibleArticleListItemState
    extends State<_DismissibleArticleListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 360),
    vsync: this,
  );

  Animation<double>? _offsetAnimation;
  double _offset = 0;
  double _width = 1;
  bool _busy = false;
  bool _swipeHapticTriggered = false;
  var _animationGeneration = 0;

  double get _animatedOffset => _offsetAnimation?.value ?? _offset;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _animateTo(double target, {required Curve curve}) async {
    final begin = _animatedOffset;
    if ((begin - target).abs() < 0.5) {
      if (mounted) {
        setState(() {
          _offset = target;
          _offsetAnimation = null;
        });
      }
      return true;
    }

    _controller
      ..stop()
      ..value = 0;
    final generation = ++_animationGeneration;
    _offsetAnimation = Tween<double>(
      begin: begin,
      end: target,
    ).chain(CurveTween(curve: curve)).animate(_controller);
    setState(() {});
    try {
      await _controller.forward();
    } on TickerCanceled {
      return false;
    }
    if (!mounted || generation != _animationGeneration) {
      return false;
    }
    setState(() {
      _offset = target;
      _offsetAnimation = null;
    });
    return true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_busy) {
      return;
    }
    _animationGeneration++;
    _controller.stop();
    final next = _animatedOffset + details.delta.dx;
    final threshold = _width * 0.4;
    if (!_swipeHapticTriggered &&
        next.abs() >= threshold &&
        _animatedOffset.abs() < threshold) {
      _swipeHapticTriggered = true;
      if (next > 0) {
        Haptics.light();
      } else {
        Haptics.medium();
      }
    }
    setState(() {
      _offset = next.clamp(-_width * 1.04, _width * 1.04).toDouble();
      _offsetAnimation = null;
    });
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    if (_busy) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dx;
    final current = _animatedOffset;
    final velocityDismisses =
        velocity.abs() > 900 && current != 0 && velocity.sign == current.sign;
    final shouldDismiss = current.abs() >= _width * 0.4 || velocityDismisses;

    if (!shouldDismiss) {
      _swipeHapticTriggered = false;
      await _animateTo(0, curve: AppMotion.swipeReturn);
      return;
    }

    final effect = current.sign > 0
        ? _RemovalEffect.archive
        : _RemovalEffect.delete;
    // Capture the laid-out height before _animateTo calls setState. Reading
    // context.size after that state change can fail because layout is dirty.
    final removalHeight = context.size?.height ?? 104;
    if (!_swipeHapticTriggered) {
      _swipeHapticTriggered = true;
      if (effect == _RemovalEffect.archive) {
        Haptics.light();
      } else {
        Haptics.medium();
      }
    }
    _busy = true;
    final slideCompleted = await _animateTo(
      current.sign * _width * 1.04,
      curve: AppMotion.swipe,
    );
    if (!mounted || !slideCompleted) {
      if (mounted) {
        _busy = false;
      }
      return;
    }

    widget.onDismissStarted(effect, removalHeight);
    bool confirmed;
    try {
      confirmed = effect == _RemovalEffect.archive
          ? await widget.onArchive()
          : await widget.onDelete();
    } catch (error) {
      debugPrint('Dismiss action failed: $error');
      confirmed = false;
    }
    if (!mounted) {
      return;
    }
    if (!confirmed) {
      widget.onDismissCancelled();
      _swipeHapticTriggered = false;
      _busy = false;
      await _animateTo(0, curve: AppMotion.swipeReturn);
    } else {
      // The parent removes the item after the repository action succeeds.
      // Keep the completed swipe in place until that removal animation starts.
      _busy = false;
    }
  }

  void _handleDragCancel() {
    if (!_busy) {
      _swipeHapticTriggered = false;
      unawaited(_animateTo(0, curve: AppMotion.swipeReturn));
    }
  }

  @override
  Widget build(BuildContext context) {
    final archiveBackground = _SwipeBackground(
      alignment: Alignment.centerLeft,
      color: _archiveBackgroundColor(context),
      foregroundColor: _archiveForegroundColor(context),
      icon: widget.view == LibraryView.archived
          ? Icons.unarchive_outlined
          : Icons.archive_outlined,
      label: widget.view == LibraryView.archived ? 'Unarchive' : 'Archive',
    );
    final deleteBackground = _SwipeBackground(
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      icon: Icons.delete_outline,
      label: 'Delete',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: _animatedOffset > 0
                    ? archiveBackground
                    : _animatedOffset < 0
                    ? deleteBackground
                    : const SizedBox.shrink(),
              ),
              Transform.translate(
                offset: Offset(_animatedOffset, 0),
                child: child,
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              onHorizontalDragCancel: _handleDragCancel,
              child: ArticleListTile(
                article: widget.article,
                onTap: widget.onTap,
                onEdit: widget.onEdit,
                onMarkRead: widget.onMarkRead,
                onMarkUnread: widget.onMarkUnread,
                onDelete: () => unawaited(widget.onDelete()),
              ),
            ),
          ),
        );
      },
    );
  }
}

Color _archiveBackgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1B5E20)
      : const Color(0xFFC8E6C9);
}

Color _archiveForegroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFC8E6C9)
      : const Color(0xFF1B5E20);
}

final class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.foregroundColor,
    required this.icon,
    required this.label,
  });

  final Alignment alignment;
  final Color color;
  final Color foregroundColor;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isStart = alignment == Alignment.centerLeft;
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isStart ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RemovedArticleListItem extends StatelessWidget {
  const _RemovedArticleListItem({
    required this.effect,
    required this.height,
    required this.animation,
  });

  final _RemovalEffect effect;
  final double height;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final isArchive = effect == _RemovalEffect.archive;
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor = isArchive
        ? _archiveBackgroundColor(context)
        : scheme.errorContainer;
    final foregroundColor = isArchive
        ? _archiveForegroundColor(context)
        : scheme.onErrorContainer;

    return ClipRect(
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        ),
        alignment: Alignment.topCenter,
        child: ColoredBox(
          color: backgroundColor,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Align(
              alignment: isArchive
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: isArchive
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    Icon(
                      isArchive ? Icons.archive_outlined : Icons.delete_outline,
                      color: foregroundColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArchive ? 'Archive' : 'Delete',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
              onPressed: () {
                Haptics.light();
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
