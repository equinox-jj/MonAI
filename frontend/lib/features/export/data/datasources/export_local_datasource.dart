import 'dart:convert';
import 'dart:io';

import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/transaction_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/storage/app_preferences.dart';
import 'package:path_provider/path_provider.dart';

abstract class ExportLocalDataSource {
  /// Caches [rows] of a fetched page.
  Future<void> cache(List<TransactionRow> rows);

  /// Every cached transaction dated from [from] to [to], both included.
  Future<List<TransactionRow>> between(DateTime from, DateTime to);

  /// Writes [content] as UTF-8 to `exports/[name]` in the temporary
  /// directory, after deleting earlier exports; gives the file's path.
  Future<String> writeExport(String name, String content);

  /// The name of the separator last exported with, or null.
  Future<String?> delimiter();

  Future<void> saveDelimiter(String name);
}

/// The directory exports are written to.
typedef ExportDirectory = Future<Directory> Function();

class ExportLocalDataSourceImpl extends ExportLocalDataSource
    with BaseLocalDataSource {
  /// [directory] replaces the platform's temporary directory in tests.
  ExportLocalDataSourceImpl({
    required this._dao,
    required this._preferences,
    ExportDirectory? directory,
  }) : _directory = directory ?? _exportsDirectory;

  final TransactionDao _dao;
  final AppPreferences _preferences;
  final ExportDirectory _directory;

  static Future<Directory> _exportsDirectory() async =>
      Directory('${(await getTemporaryDirectory()).path}/exports');

  @override
  Future<void> cache(List<TransactionRow> rows) =>
      safeCacheCall(() => _dao.upsertAll(rows));

  @override
  Future<List<TransactionRow>> between(DateTime from, DateTime to) =>
      safeCacheCall(() => _dao.between(from, to));

  @override
  Future<String> writeExport(String name, String content) =>
      safeCacheCall(() async {
        final directory = await _directory();
        // Only the latest export is kept; shared files are copies.
        if (directory.existsSync()) await directory.delete(recursive: true);
        await directory.create(recursive: true);
        final file = File('${directory.path}/$name');
        await file.writeAsString(content, encoding: utf8, flush: true);
        return file.path;
      });

  @override
  Future<String?> delimiter() => safeCacheCall(_preferences.csvDelimiter);

  @override
  Future<void> saveDelimiter(String name) =>
      safeCacheCall(() => _preferences.setCsvDelimiter(name));
}
