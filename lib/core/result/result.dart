import '../errors/app_failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    final current = this;
    if (current is Success<T>) {
      return onSuccess(current.value);
    }
    return onFailure((current as Failure<T>).failure);
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;
}
