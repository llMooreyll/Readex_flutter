sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.technicalMessage});

  final String message;
  final String? technicalMessage;

  @override
  String toString() => technicalMessage == null
      ? '$runtimeType: $message'
      : '$runtimeType: $message ($technicalMessage)';
}

final class InvalidUrlFailure extends AppFailure {
  const InvalidUrlFailure() : super('Enter a valid HTTPS URL.');
}

final class InsecureRedirectFailure extends AppFailure {
  const InsecureRedirectFailure()
    : super('The webpage redirected to an insecure URL.');
}

final class DuplicateArticleFailure extends AppFailure {
  const DuplicateArticleFailure() : super('This article is already saved.');
}

final class NetworkUnavailableFailure extends AppFailure {
  const NetworkUnavailableFailure({super.technicalMessage})
    : super('The network is unavailable. Check your connection and try again.');
}

final class NetworkTimeoutFailure extends AppFailure {
  const NetworkTimeoutFailure()
    : super('The webpage took too long to respond.');
}

final class HttpStatusFailure extends AppFailure {
  const HttpStatusFailure(this.statusCode)
    : super('The webpage returned an error (HTTP $statusCode).');

  final int statusCode;
}

final class UnsupportedContentFailure extends AppFailure {
  const UnsupportedContentFailure()
    : super('This URL does not point to a readable HTML webpage.');
}

final class VerificationRequiredFailure extends AppFailure {
  const VerificationRequiredFailure()
    : super(
        'This website requires verification before the article can be downloaded.',
      );
}

final class DynamicContentFailure extends AppFailure {
  const DynamicContentFailure()
    : super(
        'This webpage loads its article content dynamically and cannot be imported yet.',
      );
}

final class ContentTooLargeFailure extends AppFailure {
  const ContentTooLargeFailure() : super('This webpage is too large to save.');
}

final class ArticleNotReadableFailure extends AppFailure {
  const ArticleNotReadableFailure()
    : super('No readable article content was found.');
}

final class StorageFailure extends AppFailure {
  const StorageFailure({super.technicalMessage})
    : super('The article could not be saved. Please try again.');
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.technicalMessage})
    : super('Something went wrong while processing the webpage.');
}
