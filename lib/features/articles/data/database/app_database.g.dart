// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ArticlesTable extends Articles
    with TableInfo<$ArticlesTable, ArticleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _resolvedUrlMeta = const VerificationMeta(
    'resolvedUrl',
  );
  @override
  late final GeneratedColumn<String> resolvedUrl = GeneratedColumn<String>(
    'resolved_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalUrlMeta = const VerificationMeta(
    'canonicalUrl',
  );
  @override
  late final GeneratedColumn<String> canonicalUrl = GeneratedColumn<String>(
    'canonical_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _excerptMeta = const VerificationMeta(
    'excerpt',
  );
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
    'excerpt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _siteNameMeta = const VerificationMeta(
    'siteName',
  );
  @override
  late final GeneratedColumn<String> siteName = GeneratedColumn<String>(
    'site_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentHtmlMeta = const VerificationMeta(
    'contentHtml',
  );
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
    'content_html',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedReadingMinutesMeta =
      const VerificationMeta('estimatedReadingMinutes');
  @override
  late final GeneratedColumn<int> estimatedReadingMinutes =
      GeneratedColumn<int>(
        'estimated_reading_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _extractorVersionMeta = const VerificationMeta(
    'extractorVersion',
  );
  @override
  late final GeneratedColumn<String> extractorVersion = GeneratedColumn<String>(
    'extractor_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceUrl,
    resolvedUrl,
    canonicalUrl,
    title,
    excerpt,
    author,
    siteName,
    language,
    publishedAt,
    readAt,
    archivedAt,
    contentHtml,
    contentText,
    estimatedReadingMinutes,
    extractorVersion,
    savedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArticleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('resolved_url')) {
      context.handle(
        _resolvedUrlMeta,
        resolvedUrl.isAcceptableOrUnknown(
          data['resolved_url']!,
          _resolvedUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resolvedUrlMeta);
    }
    if (data.containsKey('canonical_url')) {
      context.handle(
        _canonicalUrlMeta,
        canonicalUrl.isAcceptableOrUnknown(
          data['canonical_url']!,
          _canonicalUrlMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('excerpt')) {
      context.handle(
        _excerptMeta,
        excerpt.isAcceptableOrUnknown(data['excerpt']!, _excerptMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('site_name')) {
      context.handle(
        _siteNameMeta,
        siteName.isAcceptableOrUnknown(data['site_name']!, _siteNameMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('content_html')) {
      context.handle(
        _contentHtmlMeta,
        contentHtml.isAcceptableOrUnknown(
          data['content_html']!,
          _contentHtmlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHtmlMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('estimated_reading_minutes')) {
      context.handle(
        _estimatedReadingMinutesMeta,
        estimatedReadingMinutes.isAcceptableOrUnknown(
          data['estimated_reading_minutes']!,
          _estimatedReadingMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedReadingMinutesMeta);
    }
    if (data.containsKey('extractor_version')) {
      context.handle(
        _extractorVersionMeta,
        extractorVersion.isAcceptableOrUnknown(
          data['extractor_version']!,
          _extractorVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractorVersionMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArticleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      resolvedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolved_url'],
      )!,
      canonicalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_url'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      excerpt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}excerpt'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      siteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_name'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      contentHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_html'],
      )!,
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
      estimatedReadingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_reading_minutes'],
      )!,
      extractorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extractor_version'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }
}

class ArticleRow extends DataClass implements Insertable<ArticleRow> {
  final int id;
  final String sourceUrl;
  final String resolvedUrl;
  final String? canonicalUrl;
  final String title;
  final String? excerpt;
  final String? author;
  final String? siteName;
  final String? language;
  final DateTime? publishedAt;
  final DateTime? readAt;
  final DateTime? archivedAt;
  final String contentHtml;
  final String contentText;
  final int estimatedReadingMinutes;
  final String extractorVersion;
  final DateTime savedAt;
  final DateTime updatedAt;
  const ArticleRow({
    required this.id,
    required this.sourceUrl,
    required this.resolvedUrl,
    this.canonicalUrl,
    required this.title,
    this.excerpt,
    this.author,
    this.siteName,
    this.language,
    this.publishedAt,
    this.readAt,
    this.archivedAt,
    required this.contentHtml,
    required this.contentText,
    required this.estimatedReadingMinutes,
    required this.extractorVersion,
    required this.savedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_url'] = Variable<String>(sourceUrl);
    map['resolved_url'] = Variable<String>(resolvedUrl);
    if (!nullToAbsent || canonicalUrl != null) {
      map['canonical_url'] = Variable<String>(canonicalUrl);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || siteName != null) {
      map['site_name'] = Variable<String>(siteName);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['content_html'] = Variable<String>(contentHtml);
    map['content_text'] = Variable<String>(contentText);
    map['estimated_reading_minutes'] = Variable<int>(estimatedReadingMinutes);
    map['extractor_version'] = Variable<String>(extractorVersion);
    map['saved_at'] = Variable<DateTime>(savedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: Value(id),
      sourceUrl: Value(sourceUrl),
      resolvedUrl: Value(resolvedUrl),
      canonicalUrl: canonicalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalUrl),
      title: Value(title),
      excerpt: excerpt == null && nullToAbsent
          ? const Value.absent()
          : Value(excerpt),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      siteName: siteName == null && nullToAbsent
          ? const Value.absent()
          : Value(siteName),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      contentHtml: Value(contentHtml),
      contentText: Value(contentText),
      estimatedReadingMinutes: Value(estimatedReadingMinutes),
      extractorVersion: Value(extractorVersion),
      savedAt: Value(savedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ArticleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleRow(
      id: serializer.fromJson<int>(json['id']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      resolvedUrl: serializer.fromJson<String>(json['resolvedUrl']),
      canonicalUrl: serializer.fromJson<String?>(json['canonicalUrl']),
      title: serializer.fromJson<String>(json['title']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      author: serializer.fromJson<String?>(json['author']),
      siteName: serializer.fromJson<String?>(json['siteName']),
      language: serializer.fromJson<String?>(json['language']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      contentHtml: serializer.fromJson<String>(json['contentHtml']),
      contentText: serializer.fromJson<String>(json['contentText']),
      estimatedReadingMinutes: serializer.fromJson<int>(
        json['estimatedReadingMinutes'],
      ),
      extractorVersion: serializer.fromJson<String>(json['extractorVersion']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'resolvedUrl': serializer.toJson<String>(resolvedUrl),
      'canonicalUrl': serializer.toJson<String?>(canonicalUrl),
      'title': serializer.toJson<String>(title),
      'excerpt': serializer.toJson<String?>(excerpt),
      'author': serializer.toJson<String?>(author),
      'siteName': serializer.toJson<String?>(siteName),
      'language': serializer.toJson<String?>(language),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'contentHtml': serializer.toJson<String>(contentHtml),
      'contentText': serializer.toJson<String>(contentText),
      'estimatedReadingMinutes': serializer.toJson<int>(
        estimatedReadingMinutes,
      ),
      'extractorVersion': serializer.toJson<String>(extractorVersion),
      'savedAt': serializer.toJson<DateTime>(savedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ArticleRow copyWith({
    int? id,
    String? sourceUrl,
    String? resolvedUrl,
    Value<String?> canonicalUrl = const Value.absent(),
    String? title,
    Value<String?> excerpt = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> siteName = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<DateTime?> readAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    String? contentHtml,
    String? contentText,
    int? estimatedReadingMinutes,
    String? extractorVersion,
    DateTime? savedAt,
    DateTime? updatedAt,
  }) => ArticleRow(
    id: id ?? this.id,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    resolvedUrl: resolvedUrl ?? this.resolvedUrl,
    canonicalUrl: canonicalUrl.present ? canonicalUrl.value : this.canonicalUrl,
    title: title ?? this.title,
    excerpt: excerpt.present ? excerpt.value : this.excerpt,
    author: author.present ? author.value : this.author,
    siteName: siteName.present ? siteName.value : this.siteName,
    language: language.present ? language.value : this.language,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    readAt: readAt.present ? readAt.value : this.readAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    contentHtml: contentHtml ?? this.contentHtml,
    contentText: contentText ?? this.contentText,
    estimatedReadingMinutes:
        estimatedReadingMinutes ?? this.estimatedReadingMinutes,
    extractorVersion: extractorVersion ?? this.extractorVersion,
    savedAt: savedAt ?? this.savedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ArticleRow copyWithCompanion(ArticlesCompanion data) {
    return ArticleRow(
      id: data.id.present ? data.id.value : this.id,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      resolvedUrl: data.resolvedUrl.present
          ? data.resolvedUrl.value
          : this.resolvedUrl,
      canonicalUrl: data.canonicalUrl.present
          ? data.canonicalUrl.value
          : this.canonicalUrl,
      title: data.title.present ? data.title.value : this.title,
      excerpt: data.excerpt.present ? data.excerpt.value : this.excerpt,
      author: data.author.present ? data.author.value : this.author,
      siteName: data.siteName.present ? data.siteName.value : this.siteName,
      language: data.language.present ? data.language.value : this.language,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      contentHtml: data.contentHtml.present
          ? data.contentHtml.value
          : this.contentHtml,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
      estimatedReadingMinutes: data.estimatedReadingMinutes.present
          ? data.estimatedReadingMinutes.value
          : this.estimatedReadingMinutes,
      extractorVersion: data.extractorVersion.present
          ? data.extractorVersion.value
          : this.extractorVersion,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArticleRow(')
          ..write('id: $id, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('resolvedUrl: $resolvedUrl, ')
          ..write('canonicalUrl: $canonicalUrl, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('author: $author, ')
          ..write('siteName: $siteName, ')
          ..write('language: $language, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('readAt: $readAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentText: $contentText, ')
          ..write('estimatedReadingMinutes: $estimatedReadingMinutes, ')
          ..write('extractorVersion: $extractorVersion, ')
          ..write('savedAt: $savedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceUrl,
    resolvedUrl,
    canonicalUrl,
    title,
    excerpt,
    author,
    siteName,
    language,
    publishedAt,
    readAt,
    archivedAt,
    contentHtml,
    contentText,
    estimatedReadingMinutes,
    extractorVersion,
    savedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleRow &&
          other.id == this.id &&
          other.sourceUrl == this.sourceUrl &&
          other.resolvedUrl == this.resolvedUrl &&
          other.canonicalUrl == this.canonicalUrl &&
          other.title == this.title &&
          other.excerpt == this.excerpt &&
          other.author == this.author &&
          other.siteName == this.siteName &&
          other.language == this.language &&
          other.publishedAt == this.publishedAt &&
          other.readAt == this.readAt &&
          other.archivedAt == this.archivedAt &&
          other.contentHtml == this.contentHtml &&
          other.contentText == this.contentText &&
          other.estimatedReadingMinutes == this.estimatedReadingMinutes &&
          other.extractorVersion == this.extractorVersion &&
          other.savedAt == this.savedAt &&
          other.updatedAt == this.updatedAt);
}

class ArticlesCompanion extends UpdateCompanion<ArticleRow> {
  final Value<int> id;
  final Value<String> sourceUrl;
  final Value<String> resolvedUrl;
  final Value<String?> canonicalUrl;
  final Value<String> title;
  final Value<String?> excerpt;
  final Value<String?> author;
  final Value<String?> siteName;
  final Value<String?> language;
  final Value<DateTime?> publishedAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> archivedAt;
  final Value<String> contentHtml;
  final Value<String> contentText;
  final Value<int> estimatedReadingMinutes;
  final Value<String> extractorVersion;
  final Value<DateTime> savedAt;
  final Value<DateTime> updatedAt;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.resolvedUrl = const Value.absent(),
    this.canonicalUrl = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.author = const Value.absent(),
    this.siteName = const Value.absent(),
    this.language = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.contentText = const Value.absent(),
    this.estimatedReadingMinutes = const Value.absent(),
    this.extractorVersion = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ArticlesCompanion.insert({
    this.id = const Value.absent(),
    required String sourceUrl,
    required String resolvedUrl,
    this.canonicalUrl = const Value.absent(),
    required String title,
    this.excerpt = const Value.absent(),
    this.author = const Value.absent(),
    this.siteName = const Value.absent(),
    this.language = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String contentHtml,
    required String contentText,
    required int estimatedReadingMinutes,
    required String extractorVersion,
    required DateTime savedAt,
    required DateTime updatedAt,
  }) : sourceUrl = Value(sourceUrl),
       resolvedUrl = Value(resolvedUrl),
       title = Value(title),
       contentHtml = Value(contentHtml),
       contentText = Value(contentText),
       estimatedReadingMinutes = Value(estimatedReadingMinutes),
       extractorVersion = Value(extractorVersion),
       savedAt = Value(savedAt),
       updatedAt = Value(updatedAt);
  static Insertable<ArticleRow> custom({
    Expression<int>? id,
    Expression<String>? sourceUrl,
    Expression<String>? resolvedUrl,
    Expression<String>? canonicalUrl,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<String>? author,
    Expression<String>? siteName,
    Expression<String>? language,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? contentHtml,
    Expression<String>? contentText,
    Expression<int>? estimatedReadingMinutes,
    Expression<String>? extractorVersion,
    Expression<DateTime>? savedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (resolvedUrl != null) 'resolved_url': resolvedUrl,
      if (canonicalUrl != null) 'canonical_url': canonicalUrl,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (author != null) 'author': author,
      if (siteName != null) 'site_name': siteName,
      if (language != null) 'language': language,
      if (publishedAt != null) 'published_at': publishedAt,
      if (readAt != null) 'read_at': readAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (contentHtml != null) 'content_html': contentHtml,
      if (contentText != null) 'content_text': contentText,
      if (estimatedReadingMinutes != null)
        'estimated_reading_minutes': estimatedReadingMinutes,
      if (extractorVersion != null) 'extractor_version': extractorVersion,
      if (savedAt != null) 'saved_at': savedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ArticlesCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceUrl,
    Value<String>? resolvedUrl,
    Value<String?>? canonicalUrl,
    Value<String>? title,
    Value<String?>? excerpt,
    Value<String?>? author,
    Value<String?>? siteName,
    Value<String?>? language,
    Value<DateTime?>? publishedAt,
    Value<DateTime?>? readAt,
    Value<DateTime?>? archivedAt,
    Value<String>? contentHtml,
    Value<String>? contentText,
    Value<int>? estimatedReadingMinutes,
    Value<String>? extractorVersion,
    Value<DateTime>? savedAt,
    Value<DateTime>? updatedAt,
  }) {
    return ArticlesCompanion(
      id: id ?? this.id,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      resolvedUrl: resolvedUrl ?? this.resolvedUrl,
      canonicalUrl: canonicalUrl ?? this.canonicalUrl,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      author: author ?? this.author,
      siteName: siteName ?? this.siteName,
      language: language ?? this.language,
      publishedAt: publishedAt ?? this.publishedAt,
      readAt: readAt ?? this.readAt,
      archivedAt: archivedAt ?? this.archivedAt,
      contentHtml: contentHtml ?? this.contentHtml,
      contentText: contentText ?? this.contentText,
      estimatedReadingMinutes:
          estimatedReadingMinutes ?? this.estimatedReadingMinutes,
      extractorVersion: extractorVersion ?? this.extractorVersion,
      savedAt: savedAt ?? this.savedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (resolvedUrl.present) {
      map['resolved_url'] = Variable<String>(resolvedUrl.value);
    }
    if (canonicalUrl.present) {
      map['canonical_url'] = Variable<String>(canonicalUrl.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (siteName.present) {
      map['site_name'] = Variable<String>(siteName.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (estimatedReadingMinutes.present) {
      map['estimated_reading_minutes'] = Variable<int>(
        estimatedReadingMinutes.value,
      );
    }
    if (extractorVersion.present) {
      map['extractor_version'] = Variable<String>(extractorVersion.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('resolvedUrl: $resolvedUrl, ')
          ..write('canonicalUrl: $canonicalUrl, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('author: $author, ')
          ..write('siteName: $siteName, ')
          ..write('language: $language, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('readAt: $readAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentText: $contentText, ')
          ..write('estimatedReadingMinutes: $estimatedReadingMinutes, ')
          ..write('extractorVersion: $extractorVersion, ')
          ..write('savedAt: $savedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final ArticleDao articleDao = ArticleDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [articles];
}

typedef $$ArticlesTableCreateCompanionBuilder = ArticlesCompanion Function({
  Value<int> id,
  required String sourceUrl,
  required String resolvedUrl,
  Value<String?> canonicalUrl,
  required String title,
  Value<String?> excerpt,
  Value<String?> author,
  Value<String?> siteName,
  Value<String?> language,
  Value<DateTime?> publishedAt,
  Value<DateTime?> readAt,
  Value<DateTime?> archivedAt,
  required String contentHtml,
  required String contentText,
  required int estimatedReadingMinutes,
  required String extractorVersion,
  required DateTime savedAt,
  required DateTime updatedAt,
});
typedef $$ArticlesTableUpdateCompanionBuilder = ArticlesCompanion Function({
  Value<int> id,
  Value<String> sourceUrl,
  Value<String> resolvedUrl,
  Value<String?> canonicalUrl,
  Value<String> title,
  Value<String?> excerpt,
  Value<String?> author,
  Value<String?> siteName,
  Value<String?> language,
  Value<DateTime?> publishedAt,
  Value<DateTime?> readAt,
  Value<DateTime?> archivedAt,
  Value<String> contentHtml,
  Value<String> contentText,
  Value<int> estimatedReadingMinutes,
  Value<String> extractorVersion,
  Value<DateTime> savedAt,
  Value<DateTime> updatedAt,
});

class $$ArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolvedUrl => $composableBuilder(
    column: $table.resolvedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalUrl => $composableBuilder(
    column: $table.canonicalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get excerpt => $composableBuilder(
    column: $table.excerpt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractorVersion => $composableBuilder(
    column: $table.extractorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolvedUrl => $composableBuilder(
    column: $table.resolvedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalUrl => $composableBuilder(
    column: $table.canonicalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get excerpt => $composableBuilder(
    column: $table.excerpt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractorVersion => $composableBuilder(
    column: $table.extractorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get resolvedUrl => $composableBuilder(
    column: $table.resolvedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalUrl => $composableBuilder(
    column: $table.canonicalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get excerpt =>
      $composableBuilder(column: $table.excerpt, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get siteName =>
      $composableBuilder(column: $table.siteName, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractorVersion => $composableBuilder(
    column: $table.extractorVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ArticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArticlesTable,
          ArticleRow,
          $$ArticlesTableFilterComposer,
          $$ArticlesTableOrderingComposer,
          $$ArticlesTableAnnotationComposer,
          $$ArticlesTableCreateCompanionBuilder,
          $$ArticlesTableUpdateCompanionBuilder,
          (
            ArticleRow,
            BaseReferences<_$AppDatabase, $ArticlesTable, ArticleRow>,
          ),
          ArticleRow,
          PrefetchHooks Function()
        > {
  $$ArticlesTableTableManager(_$AppDatabase db, $ArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> resolvedUrl = const Value.absent(),
                Value<String?> canonicalUrl = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> excerpt = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> siteName = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> contentHtml = const Value.absent(),
                Value<String> contentText = const Value.absent(),
                Value<int> estimatedReadingMinutes = const Value.absent(),
                Value<String> extractorVersion = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ArticlesCompanion(
                id: id,
                sourceUrl: sourceUrl,
                resolvedUrl: resolvedUrl,
                canonicalUrl: canonicalUrl,
                title: title,
                excerpt: excerpt,
                author: author,
                siteName: siteName,
                language: language,
                publishedAt: publishedAt,
                readAt: readAt,
                archivedAt: archivedAt,
                contentHtml: contentHtml,
                contentText: contentText,
                estimatedReadingMinutes: estimatedReadingMinutes,
                extractorVersion: extractorVersion,
                savedAt: savedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceUrl,
                required String resolvedUrl,
                Value<String?> canonicalUrl = const Value.absent(),
                required String title,
                Value<String?> excerpt = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> siteName = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String contentHtml,
                required String contentText,
                required int estimatedReadingMinutes,
                required String extractorVersion,
                required DateTime savedAt,
                required DateTime updatedAt,
              }) => ArticlesCompanion.insert(
                id: id,
                sourceUrl: sourceUrl,
                resolvedUrl: resolvedUrl,
                canonicalUrl: canonicalUrl,
                title: title,
                excerpt: excerpt,
                author: author,
                siteName: siteName,
                language: language,
                publishedAt: publishedAt,
                readAt: readAt,
                archivedAt: archivedAt,
                contentHtml: contentHtml,
                contentText: contentText,
                estimatedReadingMinutes: estimatedReadingMinutes,
                extractorVersion: extractorVersion,
                savedAt: savedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArticlesTable,
      ArticleRow,
      $$ArticlesTableFilterComposer,
      $$ArticlesTableOrderingComposer,
      $$ArticlesTableAnnotationComposer,
      $$ArticlesTableCreateCompanionBuilder,
      $$ArticlesTableUpdateCompanionBuilder,
      (ArticleRow, BaseReferences<_$AppDatabase, $ArticlesTable, ArticleRow>),
      ArticleRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db, _db.articles);
}
