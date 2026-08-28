import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/features/articles/application/save_article_use_case.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';

class SaveArticleState {
  const SaveArticleState({this.stage, this.failure});

  final SaveArticleStage? stage;
  final AppFailure? failure;

  bool get isSaving => stage != null;

  String get progressLabel {
    switch (stage) {
      case SaveArticleStage.validating:
        return 'Validating URL...';
      case SaveArticleStage.checkingDuplicate:
        return 'Checking saved articles...';
      case SaveArticleStage.downloading:
        return 'Downloading webpage...';
      case SaveArticleStage.extracting:
        return 'Extracting article...';
      case SaveArticleStage.saving:
        return 'Saving article...';
      case null:
        return '';
    }
  }
}

final class SaveArticleController extends StateNotifier<SaveArticleState> {
  SaveArticleController(this._useCase) : super(const SaveArticleState());

  final SaveArticleUseCase _useCase;

  Future<ArticleDraft?> prepare(String rawUrl) async {
    if (state.isSaving) {
      return null;
    }
    state = const SaveArticleState(stage: SaveArticleStage.validating);
    final result = await _useCase.prepare(
      rawUrl,
      onStage: (stage) => state = SaveArticleState(stage: stage),
    );
    return result.fold(
      onSuccess: (draft) {
        state = const SaveArticleState();
        return draft;
      },
      onFailure: (failure) {
        state = SaveArticleState(failure: failure);
        return null;
      },
    );
  }

  Future<int?> saveDraft(ArticleDraft draft) async {
    state = const SaveArticleState(stage: SaveArticleStage.saving);
    final result = await _useCase.saveDraft(draft);
    return result.fold(
      onSuccess: (id) {
        state = const SaveArticleState();
        return id;
      },
      onFailure: (failure) {
        state = SaveArticleState(failure: failure);
        return null;
      },
    );
  }

  void clearFailure() {
    if (state.failure != null) {
      state = const SaveArticleState();
    }
  }
}
