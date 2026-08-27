import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';

final class SanitizedArticle {
  const SanitizedArticle({required this.html, required this.text});

  final String html;
  final String text;
}

final class ArticleHtmlSanitizer {
  static const _imageCandidateAttributes = [
    'src',
    'data-src',
    'data-original',
    'data-actualsrc',
    'data-lazy-src',
    'data-original-src',
    'data-url',
    'data-image',
  ];

  static const _imageSrcsetAttributes = ['srcset', 'data-srcset'];

  static const _allowedTags = {
    'a',
    'blockquote',
    'br',
    'code',
    'del',
    'em',
    'figcaption',
    'figure',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'hr',
    'img',
    'li',
    'ol',
    'p',
    'pre',
    's',
    'strong',
    'sub',
    'sup',
    'table',
    'tbody',
    'td',
    'tfoot',
    'th',
    'thead',
    'tr',
    'u',
    'ul',
  };

  static const _removedTags = {
    'audio',
    'button',
    'embed',
    'form',
    'iframe',
    'input',
    'link',
    'meta',
    'object',
    'script',
    'select',
    'style',
    'textarea',
    'video',
  };

  Result<SanitizedArticle> sanitize({
    required String html,
    required Uri baseUri,
  }) {
    try {
      final fragment = html_parser.parseFragment(html);
      final elements = List<Element>.from(fragment.querySelectorAll('*'));
      for (final element in elements.reversed) {
        final tag = element.localName?.toLowerCase() ?? '';
        if (_removedTags.contains(tag)) {
          element.remove();
          continue;
        }

        if (!_allowedTags.contains(tag)) {
          _unwrap(element);
          continue;
        }

        _sanitizeAttributes(element, baseUri);
      }

      final sanitizedHtml = fragment.outerHtml;
      final text = fragment.text?.trim() ?? '';
      if (sanitizedHtml.trim().isEmpty || text.length < 40) {
        return const Failure(ArticleNotReadableFailure());
      }
      return Success(SanitizedArticle(html: sanitizedHtml, text: text));
    } catch (error) {
      return Failure(
        UnexpectedFailure(technicalMessage: 'HTML sanitizer: $error'),
      );
    }
  }

  void _unwrap(Element element) {
    final parent = element.parentNode;
    if (parent == null) {
      element.remove();
      return;
    }
    final index = parent.nodes.indexOf(element);
    final children = List<Node>.from(element.nodes);
    element.remove();
    parent.nodes.insertAll(index, children);
  }

  void _sanitizeAttributes(Element element, Uri baseUri) {
    final original = Map<String, String>.from(element.attributes);
    element.attributes.clear();

    if (element.localName == 'a') {
      final href = _safeUrl(original['href'], baseUri);
      if (href != null) {
        element.attributes['href'] = href;
      }
    } else if (element.localName == 'img') {
      final src = _safeImageUrl(original, baseUri);
      if (src == null) {
        element.remove();
        return;
      }
      element.attributes['src'] = src;
      final alt = original['alt']?.trim();
      if (alt != null && alt.isNotEmpty) {
        element.attributes['alt'] = alt;
      }
    }
  }

  String? _safeImageUrl(Map<String, String> attributes, Uri baseUri) {
    for (final attribute in _imageCandidateAttributes) {
      final url = _safeUrl(attributes[attribute], baseUri);
      if (url != null && !_isLikelyPlaceholder(Uri.parse(url))) {
        return url;
      }
    }

    for (final attribute in _imageSrcsetAttributes) {
      for (final raw in _srcsetUrls(attributes[attribute]).toList().reversed) {
        final url = _safeUrl(raw, baseUri);
        if (url != null && !_isLikelyPlaceholder(Uri.parse(url))) {
          return url;
        }
      }
    }

    return null;
  }

  Iterable<String> _srcsetUrls(String? raw) sync* {
    if (raw == null || raw.trim().isEmpty) {
      return;
    }

    for (final candidate in raw.split(',')) {
      final url = candidate.trim().split(RegExp(r'\s+')).firstOrNull;
      if (url != null && url.isNotEmpty) {
        yield url;
      }
    }
  }

  String? _safeUrl(String? raw, Uri baseUri) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final resolved = baseUri.resolve(raw.trim());
      if (resolved.scheme.toLowerCase() != 'https' ||
          resolved.userInfo.isNotEmpty) {
        return null;
      }
      return resolved.toString();
    } on FormatException {
      return null;
    }
  }

  bool _isLikelyPlaceholder(Uri uri) {
    final lowerPath = uri.path.toLowerCase();
    final fileName = lowerPath.split('/').last;
    if (lowerPath.contains('placeholder')) {
      return true;
    }
    return fileName == 'blank.gif' ||
        fileName == 'spacer.gif' ||
        fileName == 'transparent.gif';
  }
}
