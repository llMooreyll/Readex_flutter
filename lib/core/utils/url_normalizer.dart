import '../errors/app_failure.dart';
import '../result/result.dart';

final class UrlNormalizer {
  const UrlNormalizer._();

  static Result<Uri> normalize(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Failure(InvalidUrlFailure());
    }

    final withScheme = trimmed.contains('://') ? trimmed : 'https://$trimmed';

    final parsed = Uri.tryParse(withScheme);
    if (parsed == null ||
        parsed.scheme.toLowerCase() != 'https' ||
        parsed.host.isEmpty ||
        parsed.userInfo.isNotEmpty) {
      return const Failure(InvalidUrlFailure());
    }

    final normalized = Uri(
      scheme: 'https',
      userInfo: parsed.userInfo,
      host: parsed.host.toLowerCase(),
      port: parsed.hasPort ? parsed.port : null,
      path: parsed.path,
      query: parsed.query,
    );

    return Success(normalized);
  }
}
