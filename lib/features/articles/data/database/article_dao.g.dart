// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dao.dart';

// ignore_for_file: type=lint
mixin _$ArticleDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArticlesTable get articles => attachedDatabase.articles;
  ArticleDaoManager get managers => ArticleDaoManager(this);
}

class ArticleDaoManager {
  final _$ArticleDaoMixin _db;
  ArticleDaoManager(this._db);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db.attachedDatabase, _db.articles);
}
