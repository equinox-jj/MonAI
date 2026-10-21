// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monai_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toWalletIdMeta = const VerificationMeta(
    'toWalletId',
  );
  @override
  late final GeneratedColumn<String> toWalletId = GeneratedColumn<String>(
    'to_wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($TransactionsTable.$converterdate);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptUrlMeta = const VerificationMeta(
    'receiptUrl',
  );
  @override
  late final GeneratedColumn<String> receiptUrl = GeneratedColumn<String>(
    'receipt_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionSource, String>
  source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionSource>($TransactionsTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
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
    type,
    amount,
    walletId,
    toWalletId,
    categoryId,
    date,
    note,
    merchant,
    receiptUrl,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('to_wallet_id')) {
      context.handle(
        _toWalletIdMeta,
        toWalletId.isAcceptableOrUnknown(
          data['to_wallet_id']!,
          _toWalletIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('receipt_url')) {
      context.handle(
        _receiptUrlMeta,
        receiptUrl.isAcceptableOrUnknown(data['receipt_url']!, _receiptUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      )!,
      toWalletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_wallet_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      date: $TransactionsTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      receiptUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_url'],
      ),
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static TypeConverter<DateTime, String> $converterdate =
      const DateOnlyConverter();
  static JsonTypeConverter2<TransactionSource, String, String>
  $convertersource = const EnumNameConverter<TransactionSource>(
    TransactionSource.values,
  );
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final TransactionType type;

  /// Rupiah, always positive; [type] gives the direction.
  final int amount;
  final String walletId;
  final String? toWalletId;
  final String? categoryId;
  final DateTime date;
  final String? note;
  final String? merchant;
  final String? receiptUrl;
  final TransactionSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionRow({
    required this.id,
    required this.type,
    required this.amount,
    required this.walletId,
    this.toWalletId,
    this.categoryId,
    required this.date,
    this.note,
    this.merchant,
    this.receiptUrl,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount'] = Variable<int>(amount);
    map['wallet_id'] = Variable<String>(walletId);
    if (!nullToAbsent || toWalletId != null) {
      map['to_wallet_id'] = Variable<String>(toWalletId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    {
      map['date'] = Variable<String>(
        $TransactionsTable.$converterdate.toSql(date),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || receiptUrl != null) {
      map['receipt_url'] = Variable<String>(receiptUrl);
    }
    {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      walletId: Value(walletId),
      toWalletId: toWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(toWalletId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      receiptUrl: receiptUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptUrl),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      amount: serializer.fromJson<int>(json['amount']),
      walletId: serializer.fromJson<String>(json['walletId']),
      toWalletId: serializer.fromJson<String?>(json['toWalletId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      receiptUrl: serializer.fromJson<String?>(json['receiptUrl']),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'amount': serializer.toJson<int>(amount),
      'walletId': serializer.toJson<String>(walletId),
      'toWalletId': serializer.toJson<String?>(toWalletId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'merchant': serializer.toJson<String?>(merchant),
      'receiptUrl': serializer.toJson<String?>(receiptUrl),
      'source': serializer.toJson<String>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    TransactionType? type,
    int? amount,
    String? walletId,
    Value<String?> toWalletId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    DateTime? date,
    Value<String?> note = const Value.absent(),
    Value<String?> merchant = const Value.absent(),
    Value<String?> receiptUrl = const Value.absent(),
    TransactionSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionRow(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    walletId: walletId ?? this.walletId,
    toWalletId: toWalletId.present ? toWalletId.value : this.toWalletId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    merchant: merchant.present ? merchant.value : this.merchant,
    receiptUrl: receiptUrl.present ? receiptUrl.value : this.receiptUrl,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      toWalletId: data.toWalletId.present
          ? data.toWalletId.value
          : this.toWalletId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      receiptUrl: data.receiptUrl.present
          ? data.receiptUrl.value
          : this.receiptUrl,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('walletId: $walletId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('merchant: $merchant, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    walletId,
    toWalletId,
    categoryId,
    date,
    note,
    merchant,
    receiptUrl,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.walletId == this.walletId &&
          other.toWalletId == this.toWalletId &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.note == this.note &&
          other.merchant == this.merchant &&
          other.receiptUrl == this.receiptUrl &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<TransactionType> type;
  final Value<int> amount;
  final Value<String> walletId;
  final Value<String?> toWalletId;
  final Value<String?> categoryId;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> merchant;
  final Value<String?> receiptUrl;
  final Value<TransactionSource> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.walletId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.merchant = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required TransactionType type,
    required int amount,
    required String walletId,
    this.toWalletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required DateTime date,
    this.note = const Value.absent(),
    this.merchant = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    required TransactionSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       amount = Value(amount),
       walletId = Value(walletId),
       date = Value(date),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? walletId,
    Expression<String>? toWalletId,
    Expression<String>? categoryId,
    Expression<String>? date,
    Expression<String>? note,
    Expression<String>? merchant,
    Expression<String>? receiptUrl,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (walletId != null) 'wallet_id': walletId,
      if (toWalletId != null) 'to_wallet_id': toWalletId,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (merchant != null) 'merchant': merchant,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<TransactionType>? type,
    Value<int>? amount,
    Value<String>? walletId,
    Value<String?>? toWalletId,
    Value<String?>? categoryId,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<String?>? merchant,
    Value<String?>? receiptUrl,
    Value<TransactionSource>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      walletId: walletId ?? this.walletId,
      toWalletId: toWalletId ?? this.toWalletId,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      merchant: merchant ?? this.merchant,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (toWalletId.present) {
      map['to_wallet_id'] = Variable<String>(toWalletId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $TransactionsTable.$converterdate.toSql(date.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (receiptUrl.present) {
      map['receipt_url'] = Variable<String>(receiptUrl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('walletId: $walletId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('merchant: $merchant, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TransactionsFts extends Table
    with
        TableInfo<TransactionsFts, TransactionsFt>,
        VirtualTableInfo<TransactionsFts, TransactionsFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TransactionsFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [note, merchant];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TransactionsFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsFt(
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
    );
  }

  @override
  TransactionsFts createAlias(String alias) {
    return TransactionsFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(note, merchant, content=\'transactions\', content_rowid=\'rowid\', tokenize=\'unicode61\')';
}

class TransactionsFt extends DataClass implements Insertable<TransactionsFt> {
  final String note;
  final String merchant;
  const TransactionsFt({required this.note, required this.merchant});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note'] = Variable<String>(note);
    map['merchant'] = Variable<String>(merchant);
    return map;
  }

  TransactionsFtsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsFtsCompanion(
      note: Value(note),
      merchant: Value(merchant),
    );
  }

  factory TransactionsFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsFt(
      note: serializer.fromJson<String>(json['note']),
      merchant: serializer.fromJson<String>(json['merchant']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'note': serializer.toJson<String>(note),
      'merchant': serializer.toJson<String>(merchant),
    };
  }

  TransactionsFt copyWith({String? note, String? merchant}) => TransactionsFt(
    note: note ?? this.note,
    merchant: merchant ?? this.merchant,
  );
  TransactionsFt copyWithCompanion(TransactionsFtsCompanion data) {
    return TransactionsFt(
      note: data.note.present ? data.note.value : this.note,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsFt(')
          ..write('note: $note, ')
          ..write('merchant: $merchant')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(note, merchant);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsFt &&
          other.note == this.note &&
          other.merchant == this.merchant);
}

class TransactionsFtsCompanion extends UpdateCompanion<TransactionsFt> {
  final Value<String> note;
  final Value<String> merchant;
  final Value<int> rowid;
  const TransactionsFtsCompanion({
    this.note = const Value.absent(),
    this.merchant = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsFtsCompanion.insert({
    required String note,
    required String merchant,
    this.rowid = const Value.absent(),
  }) : note = Value(note),
       merchant = Value(merchant);
  static Insertable<TransactionsFt> custom({
    Expression<String>? note,
    Expression<String>? merchant,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (note != null) 'note': note,
      if (merchant != null) 'merchant': merchant,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsFtsCompanion copyWith({
    Value<String>? note,
    Value<String>? merchant,
    Value<int>? rowid,
  }) {
    return TransactionsFtsCompanion(
      note: note ?? this.note,
      merchant: merchant ?? this.merchant,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsFtsCompanion(')
          ..write('note: $note, ')
          ..write('merchant: $merchant, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, WalletRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletType>($WalletsTable.$convertertype);
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialBalanceMeta = const VerificationMeta(
    'initialBalance',
  );
  @override
  late final GeneratedColumn<int> initialBalance = GeneratedColumn<int>(
    'initial_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<int> currentBalance = GeneratedColumn<int>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
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
    providerId,
    name,
    type,
    logoUrl,
    initialBalance,
    currentBalance,
    icon,
    color,
    isDefault,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
        _initialBalanceMeta,
        initialBalance.isAcceptableOrUnknown(
          data['initial_balance']!,
          _initialBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialBalanceMeta);
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentBalanceMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    } else if (isInserting) {
      context.missing(_isArchivedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  WalletRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $WalletsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      initialBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_balance'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_balance'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletType, String, String> $convertertype =
      const EnumNameConverter<WalletType>(WalletType.values);
}

class WalletRow extends DataClass implements Insertable<WalletRow> {
  final String id;
  final String? providerId;
  final String name;
  final WalletType type;
  final String? logoUrl;

  /// Rupiah.
  final int initialBalance;

  /// Rupiah.
  final int currentBalance;
  final String? icon;
  final String? color;
  final bool isDefault;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletRow({
    required this.id,
    this.providerId,
    required this.name,
    required this.type,
    this.logoUrl,
    required this.initialBalance,
    required this.currentBalance,
    this.icon,
    this.color,
    required this.isDefault,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || providerId != null) {
      map['provider_id'] = Variable<String>(providerId);
    }
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($WalletsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['initial_balance'] = Variable<int>(initialBalance);
    map['current_balance'] = Variable<int>(currentBalance);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      providerId: providerId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerId),
      name: Value(name),
      type: Value(type),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      initialBalance: Value(initialBalance),
      currentBalance: Value(currentBalance),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      isDefault: Value(isDefault),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletRow(
      id: serializer.fromJson<String>(json['id']),
      providerId: serializer.fromJson<String?>(json['providerId']),
      name: serializer.fromJson<String>(json['name']),
      type: $WalletsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      initialBalance: serializer.fromJson<int>(json['initialBalance']),
      currentBalance: serializer.fromJson<int>(json['currentBalance']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'providerId': serializer.toJson<String?>(providerId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $WalletsTable.$convertertype.toJson(type),
      ),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'initialBalance': serializer.toJson<int>(initialBalance),
      'currentBalance': serializer.toJson<int>(currentBalance),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletRow copyWith({
    String? id,
    Value<String?> providerId = const Value.absent(),
    String? name,
    WalletType? type,
    Value<String?> logoUrl = const Value.absent(),
    int? initialBalance,
    int? currentBalance,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletRow(
    id: id ?? this.id,
    providerId: providerId.present ? providerId.value : this.providerId,
    name: name ?? this.name,
    type: type ?? this.type,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    initialBalance: initialBalance ?? this.initialBalance,
    currentBalance: currentBalance ?? this.currentBalance,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    isDefault: isDefault ?? this.isDefault,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletRow copyWithCompanion(WalletsCompanion data) {
    return WalletRow(
      id: data.id.present ? data.id.value : this.id,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletRow(')
          ..write('id: $id, ')
          ..write('providerId: $providerId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    providerId,
    name,
    type,
    logoUrl,
    initialBalance,
    currentBalance,
    icon,
    color,
    isDefault,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletRow &&
          other.id == this.id &&
          other.providerId == this.providerId &&
          other.name == this.name &&
          other.type == this.type &&
          other.logoUrl == this.logoUrl &&
          other.initialBalance == this.initialBalance &&
          other.currentBalance == this.currentBalance &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletsCompanion extends UpdateCompanion<WalletRow> {
  final Value<String> id;
  final Value<String?> providerId;
  final Value<String> name;
  final Value<WalletType> type;
  final Value<String?> logoUrl;
  final Value<int> initialBalance;
  final Value<int> currentBalance;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<bool> isDefault;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.providerId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletsCompanion.insert({
    required String id,
    this.providerId = const Value.absent(),
    required String name,
    required WalletType type,
    this.logoUrl = const Value.absent(),
    required int initialBalance,
    required int currentBalance,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required bool isDefault,
    required bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       initialBalance = Value(initialBalance),
       currentBalance = Value(currentBalance),
       isDefault = Value(isDefault),
       isArchived = Value(isArchived),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WalletRow> custom({
    Expression<String>? id,
    Expression<String>? providerId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? logoUrl,
    Expression<int>? initialBalance,
    Expression<int>? currentBalance,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (providerId != null) 'provider_id': providerId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletsCompanion copyWith({
    Value<String>? id,
    Value<String?>? providerId,
    Value<String>? name,
    Value<WalletType>? type,
    Value<String?>? logoUrl,
    Value<int>? initialBalance,
    Value<int>? currentBalance,
    Value<String?>? icon,
    Value<String?>? color,
    Value<bool>? isDefault,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      type: type ?? this.type,
      logoUrl: logoUrl ?? this.logoUrl,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $WalletsTable.$convertertype.toSql(type.value),
      );
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<int>(initialBalance.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<int>(currentBalance.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('providerId: $providerId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryType>($CategoriesTable.$convertertype);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hidden" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
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
    name,
    type,
    icon,
    color,
    isDefault,
    isSystem,
    isHidden,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    } else if (isInserting) {
      context.missing(_isSystemMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    } else if (isInserting) {
      context.missing(_isHiddenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $CategoriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryType, String, String> $convertertype =
      const EnumNameConverter<CategoryType>(CategoryType.values);
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final CategoryType type;
  final String? icon;
  final String? color;
  final bool isDefault;
  final bool isSystem;
  final bool isHidden;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    required this.isDefault,
    required this.isSystem,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $CategoriesTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      isDefault: Value(isDefault),
      isSystem: Value(isSystem),
      isHidden: Value(isHidden),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $CategoriesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $CategoriesTable.$convertertype.toJson(type),
      ),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isHidden': serializer.toJson<bool>(isHidden),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    CategoryType? type,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
    bool? isSystem,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    isDefault: isDefault ?? this.isDefault,
    isSystem: isSystem ?? this.isSystem,
    isHidden: isHidden ?? this.isHidden,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isSystem: $isSystem, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    icon,
    color,
    isDefault,
    isSystem,
    isHidden,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.isSystem == this.isSystem &&
          other.isHidden == this.isHidden &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<CategoryType> type;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<bool> isDefault;
  final Value<bool> isSystem;
  final Value<bool> isHidden;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required CategoryType type,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required bool isDefault,
    required bool isSystem,
    required bool isHidden,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       isDefault = Value(isDefault),
       isSystem = Value(isSystem),
       isHidden = Value(isHidden),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<bool>? isSystem,
    Expression<bool>? isHidden,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (isSystem != null) 'is_system': isSystem,
      if (isHidden != null) 'is_hidden': isHidden,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<CategoryType>? type,
    Value<String?>? icon,
    Value<String?>? color,
    Value<bool>? isDefault,
    Value<bool>? isSystem,
    Value<bool>? isHidden,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      isSystem: isSystem ?? this.isSystem,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CategoriesTable.$convertertype.toSql(type.value),
      );
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isSystem: $isSystem, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionRemoteKeysTable extends TransactionRemoteKeys
    with TableInfo<$TransactionRemoteKeysTable, TransactionRemoteKeyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionRemoteKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryKeyMeta = const VerificationMeta(
    'queryKey',
  );
  @override
  late final GeneratedColumn<String> queryKey = GeneratedColumn<String>(
    'query_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextCursorMeta = const VerificationMeta(
    'nextCursor',
  );
  @override
  late final GeneratedColumn<String> nextCursor = GeneratedColumn<String>(
    'next_cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [queryKey, nextCursor, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_remote_keys';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRemoteKeyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_key')) {
      context.handle(
        _queryKeyMeta,
        queryKey.isAcceptableOrUnknown(data['query_key']!, _queryKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_queryKeyMeta);
    }
    if (data.containsKey('next_cursor')) {
      context.handle(
        _nextCursorMeta,
        nextCursor.isAcceptableOrUnknown(data['next_cursor']!, _nextCursorMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {queryKey};
  @override
  TransactionRemoteKeyRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRemoteKeyRow(
      queryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query_key'],
      )!,
      nextCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_cursor'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionRemoteKeysTable createAlias(String alias) {
    return $TransactionRemoteKeysTable(attachedDatabase, alias);
  }
}

class TransactionRemoteKeyRow extends DataClass
    implements Insertable<TransactionRemoteKeyRow> {
  final String queryKey;
  final String? nextCursor;
  final DateTime updatedAt;
  const TransactionRemoteKeyRow({
    required this.queryKey,
    this.nextCursor,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query_key'] = Variable<String>(queryKey);
    if (!nullToAbsent || nextCursor != null) {
      map['next_cursor'] = Variable<String>(nextCursor);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionRemoteKeysCompanion toCompanion(bool nullToAbsent) {
    return TransactionRemoteKeysCompanion(
      queryKey: Value(queryKey),
      nextCursor: nextCursor == null && nullToAbsent
          ? const Value.absent()
          : Value(nextCursor),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRemoteKeyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRemoteKeyRow(
      queryKey: serializer.fromJson<String>(json['queryKey']),
      nextCursor: serializer.fromJson<String?>(json['nextCursor']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryKey': serializer.toJson<String>(queryKey),
      'nextCursor': serializer.toJson<String?>(nextCursor),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRemoteKeyRow copyWith({
    String? queryKey,
    Value<String?> nextCursor = const Value.absent(),
    DateTime? updatedAt,
  }) => TransactionRemoteKeyRow(
    queryKey: queryKey ?? this.queryKey,
    nextCursor: nextCursor.present ? nextCursor.value : this.nextCursor,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionRemoteKeyRow copyWithCompanion(
    TransactionRemoteKeysCompanion data,
  ) {
    return TransactionRemoteKeyRow(
      queryKey: data.queryKey.present ? data.queryKey.value : this.queryKey,
      nextCursor: data.nextCursor.present
          ? data.nextCursor.value
          : this.nextCursor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRemoteKeyRow(')
          ..write('queryKey: $queryKey, ')
          ..write('nextCursor: $nextCursor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queryKey, nextCursor, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRemoteKeyRow &&
          other.queryKey == this.queryKey &&
          other.nextCursor == this.nextCursor &&
          other.updatedAt == this.updatedAt);
}

class TransactionRemoteKeysCompanion
    extends UpdateCompanion<TransactionRemoteKeyRow> {
  final Value<String> queryKey;
  final Value<String?> nextCursor;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionRemoteKeysCompanion({
    this.queryKey = const Value.absent(),
    this.nextCursor = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionRemoteKeysCompanion.insert({
    required String queryKey,
    this.nextCursor = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : queryKey = Value(queryKey),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRemoteKeyRow> custom({
    Expression<String>? queryKey,
    Expression<String>? nextCursor,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queryKey != null) 'query_key': queryKey,
      if (nextCursor != null) 'next_cursor': nextCursor,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionRemoteKeysCompanion copyWith({
    Value<String>? queryKey,
    Value<String?>? nextCursor,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionRemoteKeysCompanion(
      queryKey: queryKey ?? this.queryKey,
      nextCursor: nextCursor ?? this.nextCursor,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queryKey.present) {
      map['query_key'] = Variable<String>(queryKey.value);
    }
    if (nextCursor.present) {
      map['next_cursor'] = Variable<String>(nextCursor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRemoteKeysCompanion(')
          ..write('queryKey: $queryKey, ')
          ..write('nextCursor: $nextCursor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> month =
      GeneratedColumn<String>(
        'month',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($BudgetsTable.$convertermonth);
  static const VerificationMeta _limitAmountMeta = const VerificationMeta(
    'limitAmount',
  );
  @override
  late final GeneratedColumn<int> limitAmount = GeneratedColumn<int>(
    'limit_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentMeta = const VerificationMeta('spent');
  @override
  late final GeneratedColumn<int> spent = GeneratedColumn<int>(
    'spent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingMeta = const VerificationMeta(
    'remaining',
  );
  @override
  late final GeneratedColumn<int> remaining = GeneratedColumn<int>(
    'remaining',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressPercentMeta = const VerificationMeta(
    'progressPercent',
  );
  @override
  late final GeneratedColumn<double> progressPercent = GeneratedColumn<double>(
    'progress_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BudgetStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BudgetStatus>($BudgetsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    month,
    limitAmount,
    spent,
    remaining,
    progressPercent,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('limit_amount')) {
      context.handle(
        _limitAmountMeta,
        limitAmount.isAcceptableOrUnknown(
          data['limit_amount']!,
          _limitAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('spent')) {
      context.handle(
        _spentMeta,
        spent.isAcceptableOrUnknown(data['spent']!, _spentMeta),
      );
    } else if (isInserting) {
      context.missing(_spentMeta);
    }
    if (data.containsKey('remaining')) {
      context.handle(
        _remainingMeta,
        remaining.isAcceptableOrUnknown(data['remaining']!, _remainingMeta),
      );
    } else if (isInserting) {
      context.missing(_remainingMeta);
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
        _progressPercentMeta,
        progressPercent.isAcceptableOrUnknown(
          data['progress_percent']!,
          _progressPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressPercentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      month: $BudgetsTable.$convertermonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}month'],
        )!,
      ),
      limitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_amount'],
      )!,
      spent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spent'],
      )!,
      remaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining'],
      )!,
      progressPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress_percent'],
      )!,
      status: $BudgetsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $convertermonth =
      const YearMonthConverter();
  static JsonTypeConverter2<BudgetStatus, String, String> $converterstatus =
      const EnumNameConverter<BudgetStatus>(BudgetStatus.values);
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final DateTime month;

  /// Rupiah.
  final int limitAmount;

  /// Rupiah, the month's expenses.
  final int spent;

  /// Rupiah; negative when over budget.
  final int remaining;
  final double progressPercent;
  final BudgetStatus status;
  const BudgetRow({
    required this.month,
    required this.limitAmount,
    required this.spent,
    required this.remaining,
    required this.progressPercent,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['month'] = Variable<String>(
        $BudgetsTable.$convertermonth.toSql(month),
      );
    }
    map['limit_amount'] = Variable<int>(limitAmount);
    map['spent'] = Variable<int>(spent);
    map['remaining'] = Variable<int>(remaining);
    map['progress_percent'] = Variable<double>(progressPercent);
    {
      map['status'] = Variable<String>(
        $BudgetsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      month: Value(month),
      limitAmount: Value(limitAmount),
      spent: Value(spent),
      remaining: Value(remaining),
      progressPercent: Value(progressPercent),
      status: Value(status),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      month: serializer.fromJson<DateTime>(json['month']),
      limitAmount: serializer.fromJson<int>(json['limitAmount']),
      spent: serializer.fromJson<int>(json['spent']),
      remaining: serializer.fromJson<int>(json['remaining']),
      progressPercent: serializer.fromJson<double>(json['progressPercent']),
      status: $BudgetsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<DateTime>(month),
      'limitAmount': serializer.toJson<int>(limitAmount),
      'spent': serializer.toJson<int>(spent),
      'remaining': serializer.toJson<int>(remaining),
      'progressPercent': serializer.toJson<double>(progressPercent),
      'status': serializer.toJson<String>(
        $BudgetsTable.$converterstatus.toJson(status),
      ),
    };
  }

  BudgetRow copyWith({
    DateTime? month,
    int? limitAmount,
    int? spent,
    int? remaining,
    double? progressPercent,
    BudgetStatus? status,
  }) => BudgetRow(
    month: month ?? this.month,
    limitAmount: limitAmount ?? this.limitAmount,
    spent: spent ?? this.spent,
    remaining: remaining ?? this.remaining,
    progressPercent: progressPercent ?? this.progressPercent,
    status: status ?? this.status,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      month: data.month.present ? data.month.value : this.month,
      limitAmount: data.limitAmount.present
          ? data.limitAmount.value
          : this.limitAmount,
      spent: data.spent.present ? data.spent.value : this.spent,
      remaining: data.remaining.present ? data.remaining.value : this.remaining,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('month: $month, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spent: $spent, ')
          ..write('remaining: $remaining, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    month,
    limitAmount,
    spent,
    remaining,
    progressPercent,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.month == this.month &&
          other.limitAmount == this.limitAmount &&
          other.spent == this.spent &&
          other.remaining == this.remaining &&
          other.progressPercent == this.progressPercent &&
          other.status == this.status);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<DateTime> month;
  final Value<int> limitAmount;
  final Value<int> spent;
  final Value<int> remaining;
  final Value<double> progressPercent;
  final Value<BudgetStatus> status;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.month = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.spent = const Value.absent(),
    this.remaining = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required DateTime month,
    required int limitAmount,
    required int spent,
    required int remaining,
    required double progressPercent,
    required BudgetStatus status,
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       limitAmount = Value(limitAmount),
       spent = Value(spent),
       remaining = Value(remaining),
       progressPercent = Value(progressPercent),
       status = Value(status);
  static Insertable<BudgetRow> custom({
    Expression<String>? month,
    Expression<int>? limitAmount,
    Expression<int>? spent,
    Expression<int>? remaining,
    Expression<double>? progressPercent,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (spent != null) 'spent': spent,
      if (remaining != null) 'remaining': remaining,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<DateTime>? month,
    Value<int>? limitAmount,
    Value<int>? spent,
    Value<int>? remaining,
    Value<double>? progressPercent,
    Value<BudgetStatus>? status,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      month: month ?? this.month,
      limitAmount: limitAmount ?? this.limitAmount,
      spent: spent ?? this.spent,
      remaining: remaining ?? this.remaining,
      progressPercent: progressPercent ?? this.progressPercent,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(
        $BudgetsTable.$convertermonth.toSql(month.value),
      );
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<int>(limitAmount.value);
    }
    if (spent.present) {
      map['spent'] = Variable<int>(spent.value);
    }
    if (remaining.present) {
      map['remaining'] = Variable<int>(remaining.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<double>(progressPercent.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $BudgetsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('month: $month, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spent: $spent, ')
          ..write('remaining: $remaining, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentProvidersTable extends PaymentProviders
    with TableInfo<$PaymentProvidersTable, PaymentProviderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentProvidersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletType>($PaymentProvidersTable.$convertertype);
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> aliases =
      GeneratedColumn<String>(
        'aliases',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($PaymentProvidersTable.$converteraliases);
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    type,
    logoUrl,
    aliases,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_providers';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentProviderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentProviderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentProviderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $PaymentProvidersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      aliases: $PaymentProvidersTable.$converteraliases.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}aliases'],
        )!,
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PaymentProvidersTable createAlias(String alias) {
    return $PaymentProvidersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletType, String, String> $convertertype =
      const EnumNameConverter<WalletType>(WalletType.values);
  static TypeConverter<List<String>, String> $converteraliases =
      const StringListConverter();
}

class PaymentProviderRow extends DataClass
    implements Insertable<PaymentProviderRow> {
  final String id;
  final String slug;
  final String name;
  final WalletType type;
  final String? logoUrl;
  final List<String> aliases;
  final int sortOrder;
  const PaymentProviderRow({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    this.logoUrl,
    required this.aliases,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $PaymentProvidersTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    {
      map['aliases'] = Variable<String>(
        $PaymentProvidersTable.$converteraliases.toSql(aliases),
      );
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PaymentProvidersCompanion toCompanion(bool nullToAbsent) {
    return PaymentProvidersCompanion(
      id: Value(id),
      slug: Value(slug),
      name: Value(name),
      type: Value(type),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      aliases: Value(aliases),
      sortOrder: Value(sortOrder),
    );
  }

  factory PaymentProviderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentProviderRow(
      id: serializer.fromJson<String>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      type: $PaymentProvidersTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      aliases: serializer.fromJson<List<String>>(json['aliases']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $PaymentProvidersTable.$convertertype.toJson(type),
      ),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'aliases': serializer.toJson<List<String>>(aliases),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PaymentProviderRow copyWith({
    String? id,
    String? slug,
    String? name,
    WalletType? type,
    Value<String?> logoUrl = const Value.absent(),
    List<String>? aliases,
    int? sortOrder,
  }) => PaymentProviderRow(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    name: name ?? this.name,
    type: type ?? this.type,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    aliases: aliases ?? this.aliases,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  PaymentProviderRow copyWithCompanion(PaymentProvidersCompanion data) {
    return PaymentProviderRow(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentProviderRow(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('aliases: $aliases, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, slug, name, type, logoUrl, aliases, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentProviderRow &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.type == this.type &&
          other.logoUrl == this.logoUrl &&
          other.aliases == this.aliases &&
          other.sortOrder == this.sortOrder);
}

class PaymentProvidersCompanion extends UpdateCompanion<PaymentProviderRow> {
  final Value<String> id;
  final Value<String> slug;
  final Value<String> name;
  final Value<WalletType> type;
  final Value<String?> logoUrl;
  final Value<List<String>> aliases;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PaymentProvidersCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.aliases = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentProvidersCompanion.insert({
    required String id,
    required String slug,
    required String name,
    required WalletType type,
    this.logoUrl = const Value.absent(),
    required List<String> aliases,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       slug = Value(slug),
       name = Value(name),
       type = Value(type),
       aliases = Value(aliases),
       sortOrder = Value(sortOrder);
  static Insertable<PaymentProviderRow> custom({
    Expression<String>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? logoUrl,
    Expression<String>? aliases,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (aliases != null) 'aliases': aliases,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentProvidersCompanion copyWith({
    Value<String>? id,
    Value<String>? slug,
    Value<String>? name,
    Value<WalletType>? type,
    Value<String?>? logoUrl,
    Value<List<String>>? aliases,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return PaymentProvidersCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      type: type ?? this.type,
      logoUrl: logoUrl ?? this.logoUrl,
      aliases: aliases ?? this.aliases,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $PaymentProvidersTable.$convertertype.toSql(type.value),
      );
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(
        $PaymentProvidersTable.$converteraliases.toSql(aliases.value),
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentProvidersCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('aliases: $aliases, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentProviderCatalogTable extends PaymentProviderCatalog
    with TableInfo<$PaymentProviderCatalogTable, PaymentProviderCatalogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentProviderCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, etag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_provider_catalog';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentProviderCatalogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentProviderCatalogRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentProviderCatalogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
    );
  }

  @override
  $PaymentProviderCatalogTable createAlias(String alias) {
    return $PaymentProviderCatalogTable(attachedDatabase, alias);
  }
}

class PaymentProviderCatalogRow extends DataClass
    implements Insertable<PaymentProviderCatalogRow> {
  final int id;
  final int version;
  final String? etag;
  const PaymentProviderCatalogRow({
    required this.id,
    required this.version,
    this.etag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    return map;
  }

  PaymentProviderCatalogCompanion toCompanion(bool nullToAbsent) {
    return PaymentProviderCatalogCompanion(
      id: Value(id),
      version: Value(version),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
    );
  }

  factory PaymentProviderCatalogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentProviderCatalogRow(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      etag: serializer.fromJson<String?>(json['etag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<int>(version),
      'etag': serializer.toJson<String?>(etag),
    };
  }

  PaymentProviderCatalogRow copyWith({
    int? id,
    int? version,
    Value<String?> etag = const Value.absent(),
  }) => PaymentProviderCatalogRow(
    id: id ?? this.id,
    version: version ?? this.version,
    etag: etag.present ? etag.value : this.etag,
  );
  PaymentProviderCatalogRow copyWithCompanion(
    PaymentProviderCatalogCompanion data,
  ) {
    return PaymentProviderCatalogRow(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      etag: data.etag.present ? data.etag.value : this.etag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentProviderCatalogRow(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('etag: $etag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, etag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentProviderCatalogRow &&
          other.id == this.id &&
          other.version == this.version &&
          other.etag == this.etag);
}

class PaymentProviderCatalogCompanion
    extends UpdateCompanion<PaymentProviderCatalogRow> {
  final Value<int> id;
  final Value<int> version;
  final Value<String?> etag;
  const PaymentProviderCatalogCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.etag = const Value.absent(),
  });
  PaymentProviderCatalogCompanion.insert({
    this.id = const Value.absent(),
    required int version,
    this.etag = const Value.absent(),
  }) : version = Value(version);
  static Insertable<PaymentProviderCatalogRow> custom({
    Expression<int>? id,
    Expression<int>? version,
    Expression<String>? etag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (etag != null) 'etag': etag,
    });
  }

  PaymentProviderCatalogCompanion copyWith({
    Value<int>? id,
    Value<int>? version,
    Value<String?>? etag,
  }) {
    return PaymentProviderCatalogCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      etag: etag ?? this.etag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentProviderCatalogCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('etag: $etag')
          ..write(')'))
        .toString();
  }
}

class $MonthlyReportsTable extends MonthlyReports
    with TableInfo<$MonthlyReportsTable, MonthlyReportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyReportsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> month =
      GeneratedColumn<String>(
        'month',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($MonthlyReportsTable.$convertermonth);
  static const VerificationMeta _incomeTotalMeta = const VerificationMeta(
    'incomeTotal',
  );
  @override
  late final GeneratedColumn<int> incomeTotal = GeneratedColumn<int>(
    'income_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseTotalMeta = const VerificationMeta(
    'expenseTotal',
  );
  @override
  late final GeneratedColumn<int> expenseTotal = GeneratedColumn<int>(
    'expense_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netMeta = const VerificationMeta('net');
  @override
  late final GeneratedColumn<int> net = GeneratedColumn<int>(
    'net',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> previousMonth =
      GeneratedColumn<String>(
        'previous_month',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($MonthlyReportsTable.$converterpreviousMonth);
  static const VerificationMeta _previousIncomeTotalMeta =
      const VerificationMeta('previousIncomeTotal');
  @override
  late final GeneratedColumn<int> previousIncomeTotal = GeneratedColumn<int>(
    'previous_income_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousExpenseTotalMeta =
      const VerificationMeta('previousExpenseTotal');
  @override
  late final GeneratedColumn<int> previousExpenseTotal = GeneratedColumn<int>(
    'previous_expense_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseChangePercentMeta =
      const VerificationMeta('expenseChangePercent');
  @override
  late final GeneratedColumn<double> expenseChangePercent =
      GeneratedColumn<double>(
        'expense_change_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    month,
    incomeTotal,
    expenseTotal,
    net,
    previousMonth,
    previousIncomeTotal,
    previousExpenseTotal,
    expenseChangePercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyReportRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('income_total')) {
      context.handle(
        _incomeTotalMeta,
        incomeTotal.isAcceptableOrUnknown(
          data['income_total']!,
          _incomeTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeTotalMeta);
    }
    if (data.containsKey('expense_total')) {
      context.handle(
        _expenseTotalMeta,
        expenseTotal.isAcceptableOrUnknown(
          data['expense_total']!,
          _expenseTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseTotalMeta);
    }
    if (data.containsKey('net')) {
      context.handle(
        _netMeta,
        net.isAcceptableOrUnknown(data['net']!, _netMeta),
      );
    } else if (isInserting) {
      context.missing(_netMeta);
    }
    if (data.containsKey('previous_income_total')) {
      context.handle(
        _previousIncomeTotalMeta,
        previousIncomeTotal.isAcceptableOrUnknown(
          data['previous_income_total']!,
          _previousIncomeTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousIncomeTotalMeta);
    }
    if (data.containsKey('previous_expense_total')) {
      context.handle(
        _previousExpenseTotalMeta,
        previousExpenseTotal.isAcceptableOrUnknown(
          data['previous_expense_total']!,
          _previousExpenseTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousExpenseTotalMeta);
    }
    if (data.containsKey('expense_change_percent')) {
      context.handle(
        _expenseChangePercentMeta,
        expenseChangePercent.isAcceptableOrUnknown(
          data['expense_change_percent']!,
          _expenseChangePercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  MonthlyReportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyReportRow(
      month: $MonthlyReportsTable.$convertermonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}month'],
        )!,
      ),
      incomeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_total'],
      )!,
      expenseTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_total'],
      )!,
      net: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net'],
      )!,
      previousMonth: $MonthlyReportsTable.$converterpreviousMonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}previous_month'],
        )!,
      ),
      previousIncomeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_income_total'],
      )!,
      previousExpenseTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_expense_total'],
      )!,
      expenseChangePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense_change_percent'],
      ),
    );
  }

  @override
  $MonthlyReportsTable createAlias(String alias) {
    return $MonthlyReportsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $convertermonth =
      const YearMonthConverter();
  static TypeConverter<DateTime, String> $converterpreviousMonth =
      const YearMonthConverter();
}

class MonthlyReportRow extends DataClass
    implements Insertable<MonthlyReportRow> {
  final DateTime month;

  /// Rupiah.
  final int incomeTotal;

  /// Rupiah.
  final int expenseTotal;

  /// Rupiah, income minus expenses.
  final int net;
  final DateTime previousMonth;
  final int previousIncomeTotal;
  final int previousExpenseTotal;

  /// Null when the previous month had no expenses.
  final double? expenseChangePercent;
  const MonthlyReportRow({
    required this.month,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.net,
    required this.previousMonth,
    required this.previousIncomeTotal,
    required this.previousExpenseTotal,
    this.expenseChangePercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['month'] = Variable<String>(
        $MonthlyReportsTable.$convertermonth.toSql(month),
      );
    }
    map['income_total'] = Variable<int>(incomeTotal);
    map['expense_total'] = Variable<int>(expenseTotal);
    map['net'] = Variable<int>(net);
    {
      map['previous_month'] = Variable<String>(
        $MonthlyReportsTable.$converterpreviousMonth.toSql(previousMonth),
      );
    }
    map['previous_income_total'] = Variable<int>(previousIncomeTotal);
    map['previous_expense_total'] = Variable<int>(previousExpenseTotal);
    if (!nullToAbsent || expenseChangePercent != null) {
      map['expense_change_percent'] = Variable<double>(expenseChangePercent);
    }
    return map;
  }

  MonthlyReportsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyReportsCompanion(
      month: Value(month),
      incomeTotal: Value(incomeTotal),
      expenseTotal: Value(expenseTotal),
      net: Value(net),
      previousMonth: Value(previousMonth),
      previousIncomeTotal: Value(previousIncomeTotal),
      previousExpenseTotal: Value(previousExpenseTotal),
      expenseChangePercent: expenseChangePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseChangePercent),
    );
  }

  factory MonthlyReportRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyReportRow(
      month: serializer.fromJson<DateTime>(json['month']),
      incomeTotal: serializer.fromJson<int>(json['incomeTotal']),
      expenseTotal: serializer.fromJson<int>(json['expenseTotal']),
      net: serializer.fromJson<int>(json['net']),
      previousMonth: serializer.fromJson<DateTime>(json['previousMonth']),
      previousIncomeTotal: serializer.fromJson<int>(
        json['previousIncomeTotal'],
      ),
      previousExpenseTotal: serializer.fromJson<int>(
        json['previousExpenseTotal'],
      ),
      expenseChangePercent: serializer.fromJson<double?>(
        json['expenseChangePercent'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<DateTime>(month),
      'incomeTotal': serializer.toJson<int>(incomeTotal),
      'expenseTotal': serializer.toJson<int>(expenseTotal),
      'net': serializer.toJson<int>(net),
      'previousMonth': serializer.toJson<DateTime>(previousMonth),
      'previousIncomeTotal': serializer.toJson<int>(previousIncomeTotal),
      'previousExpenseTotal': serializer.toJson<int>(previousExpenseTotal),
      'expenseChangePercent': serializer.toJson<double?>(expenseChangePercent),
    };
  }

  MonthlyReportRow copyWith({
    DateTime? month,
    int? incomeTotal,
    int? expenseTotal,
    int? net,
    DateTime? previousMonth,
    int? previousIncomeTotal,
    int? previousExpenseTotal,
    Value<double?> expenseChangePercent = const Value.absent(),
  }) => MonthlyReportRow(
    month: month ?? this.month,
    incomeTotal: incomeTotal ?? this.incomeTotal,
    expenseTotal: expenseTotal ?? this.expenseTotal,
    net: net ?? this.net,
    previousMonth: previousMonth ?? this.previousMonth,
    previousIncomeTotal: previousIncomeTotal ?? this.previousIncomeTotal,
    previousExpenseTotal: previousExpenseTotal ?? this.previousExpenseTotal,
    expenseChangePercent: expenseChangePercent.present
        ? expenseChangePercent.value
        : this.expenseChangePercent,
  );
  MonthlyReportRow copyWithCompanion(MonthlyReportsCompanion data) {
    return MonthlyReportRow(
      month: data.month.present ? data.month.value : this.month,
      incomeTotal: data.incomeTotal.present
          ? data.incomeTotal.value
          : this.incomeTotal,
      expenseTotal: data.expenseTotal.present
          ? data.expenseTotal.value
          : this.expenseTotal,
      net: data.net.present ? data.net.value : this.net,
      previousMonth: data.previousMonth.present
          ? data.previousMonth.value
          : this.previousMonth,
      previousIncomeTotal: data.previousIncomeTotal.present
          ? data.previousIncomeTotal.value
          : this.previousIncomeTotal,
      previousExpenseTotal: data.previousExpenseTotal.present
          ? data.previousExpenseTotal.value
          : this.previousExpenseTotal,
      expenseChangePercent: data.expenseChangePercent.present
          ? data.expenseChangePercent.value
          : this.expenseChangePercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyReportRow(')
          ..write('month: $month, ')
          ..write('incomeTotal: $incomeTotal, ')
          ..write('expenseTotal: $expenseTotal, ')
          ..write('net: $net, ')
          ..write('previousMonth: $previousMonth, ')
          ..write('previousIncomeTotal: $previousIncomeTotal, ')
          ..write('previousExpenseTotal: $previousExpenseTotal, ')
          ..write('expenseChangePercent: $expenseChangePercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    month,
    incomeTotal,
    expenseTotal,
    net,
    previousMonth,
    previousIncomeTotal,
    previousExpenseTotal,
    expenseChangePercent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyReportRow &&
          other.month == this.month &&
          other.incomeTotal == this.incomeTotal &&
          other.expenseTotal == this.expenseTotal &&
          other.net == this.net &&
          other.previousMonth == this.previousMonth &&
          other.previousIncomeTotal == this.previousIncomeTotal &&
          other.previousExpenseTotal == this.previousExpenseTotal &&
          other.expenseChangePercent == this.expenseChangePercent);
}

class MonthlyReportsCompanion extends UpdateCompanion<MonthlyReportRow> {
  final Value<DateTime> month;
  final Value<int> incomeTotal;
  final Value<int> expenseTotal;
  final Value<int> net;
  final Value<DateTime> previousMonth;
  final Value<int> previousIncomeTotal;
  final Value<int> previousExpenseTotal;
  final Value<double?> expenseChangePercent;
  final Value<int> rowid;
  const MonthlyReportsCompanion({
    this.month = const Value.absent(),
    this.incomeTotal = const Value.absent(),
    this.expenseTotal = const Value.absent(),
    this.net = const Value.absent(),
    this.previousMonth = const Value.absent(),
    this.previousIncomeTotal = const Value.absent(),
    this.previousExpenseTotal = const Value.absent(),
    this.expenseChangePercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthlyReportsCompanion.insert({
    required DateTime month,
    required int incomeTotal,
    required int expenseTotal,
    required int net,
    required DateTime previousMonth,
    required int previousIncomeTotal,
    required int previousExpenseTotal,
    this.expenseChangePercent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       incomeTotal = Value(incomeTotal),
       expenseTotal = Value(expenseTotal),
       net = Value(net),
       previousMonth = Value(previousMonth),
       previousIncomeTotal = Value(previousIncomeTotal),
       previousExpenseTotal = Value(previousExpenseTotal);
  static Insertable<MonthlyReportRow> custom({
    Expression<String>? month,
    Expression<int>? incomeTotal,
    Expression<int>? expenseTotal,
    Expression<int>? net,
    Expression<String>? previousMonth,
    Expression<int>? previousIncomeTotal,
    Expression<int>? previousExpenseTotal,
    Expression<double>? expenseChangePercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (incomeTotal != null) 'income_total': incomeTotal,
      if (expenseTotal != null) 'expense_total': expenseTotal,
      if (net != null) 'net': net,
      if (previousMonth != null) 'previous_month': previousMonth,
      if (previousIncomeTotal != null)
        'previous_income_total': previousIncomeTotal,
      if (previousExpenseTotal != null)
        'previous_expense_total': previousExpenseTotal,
      if (expenseChangePercent != null)
        'expense_change_percent': expenseChangePercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthlyReportsCompanion copyWith({
    Value<DateTime>? month,
    Value<int>? incomeTotal,
    Value<int>? expenseTotal,
    Value<int>? net,
    Value<DateTime>? previousMonth,
    Value<int>? previousIncomeTotal,
    Value<int>? previousExpenseTotal,
    Value<double?>? expenseChangePercent,
    Value<int>? rowid,
  }) {
    return MonthlyReportsCompanion(
      month: month ?? this.month,
      incomeTotal: incomeTotal ?? this.incomeTotal,
      expenseTotal: expenseTotal ?? this.expenseTotal,
      net: net ?? this.net,
      previousMonth: previousMonth ?? this.previousMonth,
      previousIncomeTotal: previousIncomeTotal ?? this.previousIncomeTotal,
      previousExpenseTotal: previousExpenseTotal ?? this.previousExpenseTotal,
      expenseChangePercent: expenseChangePercent ?? this.expenseChangePercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(
        $MonthlyReportsTable.$convertermonth.toSql(month.value),
      );
    }
    if (incomeTotal.present) {
      map['income_total'] = Variable<int>(incomeTotal.value);
    }
    if (expenseTotal.present) {
      map['expense_total'] = Variable<int>(expenseTotal.value);
    }
    if (net.present) {
      map['net'] = Variable<int>(net.value);
    }
    if (previousMonth.present) {
      map['previous_month'] = Variable<String>(
        $MonthlyReportsTable.$converterpreviousMonth.toSql(previousMonth.value),
      );
    }
    if (previousIncomeTotal.present) {
      map['previous_income_total'] = Variable<int>(previousIncomeTotal.value);
    }
    if (previousExpenseTotal.present) {
      map['previous_expense_total'] = Variable<int>(previousExpenseTotal.value);
    }
    if (expenseChangePercent.present) {
      map['expense_change_percent'] = Variable<double>(
        expenseChangePercent.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyReportsCompanion(')
          ..write('month: $month, ')
          ..write('incomeTotal: $incomeTotal, ')
          ..write('expenseTotal: $expenseTotal, ')
          ..write('net: $net, ')
          ..write('previousMonth: $previousMonth, ')
          ..write('previousIncomeTotal: $previousIncomeTotal, ')
          ..write('previousExpenseTotal: $previousExpenseTotal, ')
          ..write('expenseChangePercent: $expenseChangePercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportCategoriesTable extends ReportCategories
    with TableInfo<$ReportCategoriesTable, ReportCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportCategoriesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> month =
      GeneratedColumn<String>(
        'month',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES monthly_reports (month) ON DELETE CASCADE',
        ),
      ).withConverter<DateTime>($ReportCategoriesTable.$convertermonth);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharePercentMeta = const VerificationMeta(
    'sharePercent',
  );
  @override
  late final GeneratedColumn<double> sharePercent = GeneratedColumn<double>(
    'share_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousAmountMeta = const VerificationMeta(
    'previousAmount',
  );
  @override
  late final GeneratedColumn<int> previousAmount = GeneratedColumn<int>(
    'previous_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changePercentMeta = const VerificationMeta(
    'changePercent',
  );
  @override
  late final GeneratedColumn<double> changePercent = GeneratedColumn<double>(
    'change_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    month,
    categoryId,
    position,
    name,
    icon,
    color,
    amount,
    sharePercent,
    previousAmount,
    changePercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('share_percent')) {
      context.handle(
        _sharePercentMeta,
        sharePercent.isAcceptableOrUnknown(
          data['share_percent']!,
          _sharePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sharePercentMeta);
    }
    if (data.containsKey('previous_amount')) {
      context.handle(
        _previousAmountMeta,
        previousAmount.isAcceptableOrUnknown(
          data['previous_amount']!,
          _previousAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousAmountMeta);
    }
    if (data.containsKey('change_percent')) {
      context.handle(
        _changePercentMeta,
        changePercent.isAcceptableOrUnknown(
          data['change_percent']!,
          _changePercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month, categoryId};
  @override
  ReportCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportCategoryRow(
      month: $ReportCategoriesTable.$convertermonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}month'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      sharePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}share_percent'],
      )!,
      previousAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_amount'],
      )!,
      changePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}change_percent'],
      ),
    );
  }

  @override
  $ReportCategoriesTable createAlias(String alias) {
    return $ReportCategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $convertermonth =
      const YearMonthConverter();
}

class ReportCategoryRow extends DataClass
    implements Insertable<ReportCategoryRow> {
  final DateTime month;
  final String categoryId;
  final int position;
  final String name;
  final String? icon;
  final String? color;

  /// Rupiah.
  final int amount;
  final double sharePercent;

  /// Rupiah.
  final int previousAmount;

  /// Null when the category had no expenses the previous month.
  final double? changePercent;
  const ReportCategoryRow({
    required this.month,
    required this.categoryId,
    required this.position,
    required this.name,
    this.icon,
    this.color,
    required this.amount,
    required this.sharePercent,
    required this.previousAmount,
    this.changePercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['month'] = Variable<String>(
        $ReportCategoriesTable.$convertermonth.toSql(month),
      );
    }
    map['category_id'] = Variable<String>(categoryId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['amount'] = Variable<int>(amount);
    map['share_percent'] = Variable<double>(sharePercent);
    map['previous_amount'] = Variable<int>(previousAmount);
    if (!nullToAbsent || changePercent != null) {
      map['change_percent'] = Variable<double>(changePercent);
    }
    return map;
  }

  ReportCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ReportCategoriesCompanion(
      month: Value(month),
      categoryId: Value(categoryId),
      position: Value(position),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      amount: Value(amount),
      sharePercent: Value(sharePercent),
      previousAmount: Value(previousAmount),
      changePercent: changePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(changePercent),
    );
  }

  factory ReportCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportCategoryRow(
      month: serializer.fromJson<DateTime>(json['month']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      amount: serializer.fromJson<int>(json['amount']),
      sharePercent: serializer.fromJson<double>(json['sharePercent']),
      previousAmount: serializer.fromJson<int>(json['previousAmount']),
      changePercent: serializer.fromJson<double?>(json['changePercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<DateTime>(month),
      'categoryId': serializer.toJson<String>(categoryId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'amount': serializer.toJson<int>(amount),
      'sharePercent': serializer.toJson<double>(sharePercent),
      'previousAmount': serializer.toJson<int>(previousAmount),
      'changePercent': serializer.toJson<double?>(changePercent),
    };
  }

  ReportCategoryRow copyWith({
    DateTime? month,
    String? categoryId,
    int? position,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    int? amount,
    double? sharePercent,
    int? previousAmount,
    Value<double?> changePercent = const Value.absent(),
  }) => ReportCategoryRow(
    month: month ?? this.month,
    categoryId: categoryId ?? this.categoryId,
    position: position ?? this.position,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    amount: amount ?? this.amount,
    sharePercent: sharePercent ?? this.sharePercent,
    previousAmount: previousAmount ?? this.previousAmount,
    changePercent: changePercent.present
        ? changePercent.value
        : this.changePercent,
  );
  ReportCategoryRow copyWithCompanion(ReportCategoriesCompanion data) {
    return ReportCategoryRow(
      month: data.month.present ? data.month.value : this.month,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      amount: data.amount.present ? data.amount.value : this.amount,
      sharePercent: data.sharePercent.present
          ? data.sharePercent.value
          : this.sharePercent,
      previousAmount: data.previousAmount.present
          ? data.previousAmount.value
          : this.previousAmount,
      changePercent: data.changePercent.present
          ? data.changePercent.value
          : this.changePercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportCategoryRow(')
          ..write('month: $month, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('amount: $amount, ')
          ..write('sharePercent: $sharePercent, ')
          ..write('previousAmount: $previousAmount, ')
          ..write('changePercent: $changePercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    month,
    categoryId,
    position,
    name,
    icon,
    color,
    amount,
    sharePercent,
    previousAmount,
    changePercent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportCategoryRow &&
          other.month == this.month &&
          other.categoryId == this.categoryId &&
          other.position == this.position &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.amount == this.amount &&
          other.sharePercent == this.sharePercent &&
          other.previousAmount == this.previousAmount &&
          other.changePercent == this.changePercent);
}

class ReportCategoriesCompanion extends UpdateCompanion<ReportCategoryRow> {
  final Value<DateTime> month;
  final Value<String> categoryId;
  final Value<int> position;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<int> amount;
  final Value<double> sharePercent;
  final Value<int> previousAmount;
  final Value<double?> changePercent;
  final Value<int> rowid;
  const ReportCategoriesCompanion({
    this.month = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.amount = const Value.absent(),
    this.sharePercent = const Value.absent(),
    this.previousAmount = const Value.absent(),
    this.changePercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportCategoriesCompanion.insert({
    required DateTime month,
    required String categoryId,
    required int position,
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required int amount,
    required double sharePercent,
    required int previousAmount,
    this.changePercent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       categoryId = Value(categoryId),
       position = Value(position),
       name = Value(name),
       amount = Value(amount),
       sharePercent = Value(sharePercent),
       previousAmount = Value(previousAmount);
  static Insertable<ReportCategoryRow> custom({
    Expression<String>? month,
    Expression<String>? categoryId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? amount,
    Expression<double>? sharePercent,
    Expression<int>? previousAmount,
    Expression<double>? changePercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (categoryId != null) 'category_id': categoryId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (amount != null) 'amount': amount,
      if (sharePercent != null) 'share_percent': sharePercent,
      if (previousAmount != null) 'previous_amount': previousAmount,
      if (changePercent != null) 'change_percent': changePercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportCategoriesCompanion copyWith({
    Value<DateTime>? month,
    Value<String>? categoryId,
    Value<int>? position,
    Value<String>? name,
    Value<String?>? icon,
    Value<String?>? color,
    Value<int>? amount,
    Value<double>? sharePercent,
    Value<int>? previousAmount,
    Value<double?>? changePercent,
    Value<int>? rowid,
  }) {
    return ReportCategoriesCompanion(
      month: month ?? this.month,
      categoryId: categoryId ?? this.categoryId,
      position: position ?? this.position,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      amount: amount ?? this.amount,
      sharePercent: sharePercent ?? this.sharePercent,
      previousAmount: previousAmount ?? this.previousAmount,
      changePercent: changePercent ?? this.changePercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(
        $ReportCategoriesTable.$convertermonth.toSql(month.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (sharePercent.present) {
      map['share_percent'] = Variable<double>(sharePercent.value);
    }
    if (previousAmount.present) {
      map['previous_amount'] = Variable<int>(previousAmount.value);
    }
    if (changePercent.present) {
      map['change_percent'] = Variable<double>(changePercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportCategoriesCompanion(')
          ..write('month: $month, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('amount: $amount, ')
          ..write('sharePercent: $sharePercent, ')
          ..write('previousAmount: $previousAmount, ')
          ..write('changePercent: $changePercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleSlugMeta = const VerificationMeta(
    'roleSlug',
  );
  @override
  late final GeneratedColumn<String> roleSlug = GeneratedColumn<String>(
    'role_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleNameMeta = const VerificationMeta(
    'roleName',
  );
  @override
  late final GeneratedColumn<String> roleName = GeneratedColumn<String>(
    'role_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($UsersTable.$converterpermissions);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    avatarUrl,
    timezone,
    roleSlug,
    roleName,
    permissions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('role_slug')) {
      context.handle(
        _roleSlugMeta,
        roleSlug.isAcceptableOrUnknown(data['role_slug']!, _roleSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_roleSlugMeta);
    }
    if (data.containsKey('role_name')) {
      context.handle(
        _roleNameMeta,
        roleName.isAcceptableOrUnknown(data['role_name']!, _roleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_roleNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      roleSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_slug'],
      )!,
      roleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_name'],
      )!,
      permissions: $UsersTable.$converterpermissions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}permissions'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterpermissions =
      const StringListConverter();
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String id;
  final String name;
  final String email;

  /// Presigned and short-lived, so a cached one may have expired; the UI
  /// falls back to initials.
  final String? avatarUrl;
  final String timezone;
  final String roleSlug;
  final String roleName;

  /// Sorted, so the stored value doesn't depend on the order received.
  final List<String> permissions;
  final DateTime createdAt;
  const UserRow({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.timezone,
    required this.roleSlug,
    required this.roleName,
    required this.permissions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['timezone'] = Variable<String>(timezone);
    map['role_slug'] = Variable<String>(roleSlug);
    map['role_name'] = Variable<String>(roleName);
    {
      map['permissions'] = Variable<String>(
        $UsersTable.$converterpermissions.toSql(permissions),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      timezone: Value(timezone),
      roleSlug: Value(roleSlug),
      roleName: Value(roleName),
      permissions: Value(permissions),
      createdAt: Value(createdAt),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      timezone: serializer.fromJson<String>(json['timezone']),
      roleSlug: serializer.fromJson<String>(json['roleSlug']),
      roleName: serializer.fromJson<String>(json['roleName']),
      permissions: serializer.fromJson<List<String>>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'timezone': serializer.toJson<String>(timezone),
      'roleSlug': serializer.toJson<String>(roleSlug),
      'roleName': serializer.toJson<String>(roleName),
      'permissions': serializer.toJson<List<String>>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserRow copyWith({
    String? id,
    String? name,
    String? email,
    Value<String?> avatarUrl = const Value.absent(),
    String? timezone,
    String? roleSlug,
    String? roleName,
    List<String>? permissions,
    DateTime? createdAt,
  }) => UserRow(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    timezone: timezone ?? this.timezone,
    roleSlug: roleSlug ?? this.roleSlug,
    roleName: roleName ?? this.roleName,
    permissions: permissions ?? this.permissions,
    createdAt: createdAt ?? this.createdAt,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      roleSlug: data.roleSlug.present ? data.roleSlug.value : this.roleSlug,
      roleName: data.roleName.present ? data.roleName.value : this.roleName,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('timezone: $timezone, ')
          ..write('roleSlug: $roleSlug, ')
          ..write('roleName: $roleName, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    avatarUrl,
    timezone,
    roleSlug,
    roleName,
    permissions,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.timezone == this.timezone &&
          other.roleSlug == this.roleSlug &&
          other.roleName == this.roleName &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> avatarUrl;
  final Value<String> timezone;
  final Value<String> roleSlug;
  final Value<String> roleName;
  final Value<List<String>> permissions;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.timezone = const Value.absent(),
    this.roleSlug = const Value.absent(),
    this.roleName = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.avatarUrl = const Value.absent(),
    required String timezone,
    required String roleSlug,
    required String roleName,
    required List<String> permissions,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       timezone = Value(timezone),
       roleSlug = Value(roleSlug),
       roleName = Value(roleName),
       permissions = Value(permissions),
       createdAt = Value(createdAt);
  static Insertable<UserRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<String>? timezone,
    Expression<String>? roleSlug,
    Expression<String>? roleName,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (timezone != null) 'timezone': timezone,
      if (roleSlug != null) 'role_slug': roleSlug,
      if (roleName != null) 'role_name': roleName,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? avatarUrl,
    Value<String>? timezone,
    Value<String>? roleSlug,
    Value<String>? roleName,
    Value<List<String>>? permissions,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timezone: timezone ?? this.timezone,
      roleSlug: roleSlug ?? this.roleSlug,
      roleName: roleName ?? this.roleName,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (roleSlug.present) {
      map['role_slug'] = Variable<String>(roleSlug.value);
    }
    if (roleName.present) {
      map['role_name'] = Variable<String>(roleName.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(
        $UsersTable.$converterpermissions.toSql(permissions.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('timezone: $timezone, ')
          ..write('roleSlug: $roleSlug, ')
          ..write('roleName: $roleName, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MonAIDatabase extends GeneratedDatabase {
  _$MonAIDatabase(QueryExecutor e) : super(e);
  $MonAIDatabaseManager get managers => $MonAIDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final TransactionsFts transactionsFts = TransactionsFts(this);
  late final Trigger transactionsFtsAfterInsert = Trigger(
    'CREATE TRIGGER transactions_fts_after_insert AFTER INSERT ON transactions BEGIN INSERT INTO transactions_fts ("rowid", note, merchant) VALUES (new."rowid", new.note, new.merchant);END',
    'transactions_fts_after_insert',
  );
  late final Trigger transactionsFtsAfterDelete = Trigger(
    'CREATE TRIGGER transactions_fts_after_delete AFTER DELETE ON transactions BEGIN INSERT INTO transactions_fts (transactions_fts, "rowid", note, merchant) VALUES (\'delete\', old."rowid", old.note, old.merchant);END',
    'transactions_fts_after_delete',
  );
  late final Trigger transactionsFtsAfterUpdate = Trigger(
    'CREATE TRIGGER transactions_fts_after_update AFTER UPDATE ON transactions BEGIN INSERT INTO transactions_fts (transactions_fts, "rowid", note, merchant) VALUES (\'delete\', old."rowid", old.note, old.merchant);INSERT INTO transactions_fts ("rowid", note, merchant) VALUES (new."rowid", new.note, new.merchant);END',
    'transactions_fts_after_update',
  );
  late final Index indexTransactionsDateId = Index(
    'index_transactions_date_id',
    'CREATE INDEX index_transactions_date_id ON transactions (date, id)',
  );
  late final Index indexTransactionsWalletId = Index(
    'index_transactions_wallet_id',
    'CREATE INDEX index_transactions_wallet_id ON transactions (wallet_id)',
  );
  late final Index indexTransactionsToWalletId = Index(
    'index_transactions_to_wallet_id',
    'CREATE INDEX index_transactions_to_wallet_id ON transactions (to_wallet_id)',
  );
  late final Index indexTransactionsCategoryId = Index(
    'index_transactions_category_id',
    'CREATE INDEX index_transactions_category_id ON transactions (category_id)',
  );
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionRemoteKeysTable transactionRemoteKeys =
      $TransactionRemoteKeysTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $PaymentProvidersTable paymentProviders = $PaymentProvidersTable(
    this,
  );
  late final $PaymentProviderCatalogTable paymentProviderCatalog =
      $PaymentProviderCatalogTable(this);
  late final $MonthlyReportsTable monthlyReports = $MonthlyReportsTable(this);
  late final $ReportCategoriesTable reportCategories = $ReportCategoriesTable(
    this,
  );
  late final $UsersTable users = $UsersTable(this);
  late final Index indexCategoriesType = Index(
    'index_categories_type',
    'CREATE INDEX index_categories_type ON categories (type)',
  );
  late final WalletDao walletDao = WalletDao(this as MonAIDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as MonAIDatabase);
  late final TransactionDao transactionDao = TransactionDao(
    this as MonAIDatabase,
  );
  late final BudgetDao budgetDao = BudgetDao(this as MonAIDatabase);
  late final PaymentProviderDao paymentProviderDao = PaymentProviderDao(
    this as MonAIDatabase,
  );
  late final MonthlyReportDao monthlyReportDao = MonthlyReportDao(
    this as MonAIDatabase,
  );
  late final UserDao userDao = UserDao(this as MonAIDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    transactionsFts,
    transactionsFtsAfterInsert,
    transactionsFtsAfterDelete,
    transactionsFtsAfterUpdate,
    indexTransactionsDateId,
    indexTransactionsWalletId,
    indexTransactionsToWalletId,
    indexTransactionsCategoryId,
    wallets,
    categories,
    transactionRemoteKeys,
    budgets,
    paymentProviders,
    paymentProviderCatalog,
    monthlyReports,
    reportCategories,
    users,
    indexCategoriesType,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('transactions_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('transactions_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'monthly_reports',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('report_categories', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required TransactionType type,
      required int amount,
      required String walletId,
      Value<String?> toWalletId,
      Value<String?> categoryId,
      required DateTime date,
      Value<String?> note,
      Value<String?> merchant,
      Value<String?> receiptUrl,
      required TransactionSource source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<TransactionType> type,
      Value<int> amount,
      Value<String> walletId,
      Value<String?> toWalletId,
      Value<String?> categoryId,
      Value<DateTime> date,
      Value<String?> note,
      Value<String?> merchant,
      Value<String?> receiptUrl,
      Value<TransactionSource> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$MonAIDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptUrl => $composableBuilder(
    column: $table.receiptUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionSource, TransactionSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$MonAIDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptUrl => $composableBuilder(
    column: $table.receiptUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get receiptUrl => $composableBuilder(
    column: $table.receiptUrl,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<_$MonAIDatabase, $TransactionsTable, TransactionRow>,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$MonAIDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<String?> toWalletId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> receiptUrl = const Value.absent(),
                Value<TransactionSource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                amount: amount,
                walletId: walletId,
                toWalletId: toWalletId,
                categoryId: categoryId,
                date: date,
                note: note,
                merchant: merchant,
                receiptUrl: receiptUrl,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required TransactionType type,
                required int amount,
                required String walletId,
                Value<String?> toWalletId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required DateTime date,
                Value<String?> note = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> receiptUrl = const Value.absent(),
                required TransactionSource source,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                walletId: walletId,
                toWalletId: toWalletId,
                categoryId: categoryId,
                date: date,
                note: note,
                merchant: merchant,
                receiptUrl: receiptUrl,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  BaseReferences<
                    _$MonAIDatabase,
                    $TransactionsTable,
                    TransactionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$MonAIDatabase, $TransactionsTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $TransactionsFtsCreateCompanionBuilder =
    TransactionsFtsCompanion Function({
      required String note,
      required String merchant,
      Value<int> rowid,
    });
typedef $TransactionsFtsUpdateCompanionBuilder =
    TransactionsFtsCompanion Function({
      Value<String> note,
      Value<String> merchant,
      Value<int> rowid,
    });

class $TransactionsFtsFilterComposer
    extends Composer<_$MonAIDatabase, TransactionsFts> {
  $TransactionsFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );
}

class $TransactionsFtsOrderingComposer
    extends Composer<_$MonAIDatabase, TransactionsFts> {
  $TransactionsFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TransactionsFtsAnnotationComposer
    extends Composer<_$MonAIDatabase, TransactionsFts> {
  $TransactionsFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);
}

class $TransactionsFtsTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          TransactionsFts,
          TransactionsFt,
          $TransactionsFtsFilterComposer,
          $TransactionsFtsOrderingComposer,
          $TransactionsFtsAnnotationComposer,
          $TransactionsFtsCreateCompanionBuilder,
          $TransactionsFtsUpdateCompanionBuilder,
          (
            TransactionsFt,
            BaseReferences<_$MonAIDatabase, TransactionsFts, TransactionsFt>,
          ),
          TransactionsFt,
          PrefetchHooks Function()
        > {
  $TransactionsFtsTableManager(_$MonAIDatabase db, TransactionsFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TransactionsFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TransactionsFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TransactionsFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> note = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsFtsCompanion(
                note: note,
                merchant: merchant,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String note,
                required String merchant,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsFtsCompanion.insert(
                note: note,
                merchant: merchant,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TransactionsFts, TransactionsFt>(table),
                  BaseReferences<
                    _$MonAIDatabase,
                    TransactionsFts,
                    TransactionsFt
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $TransactionsFtsProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      TransactionsFts,
      TransactionsFt,
      $TransactionsFtsFilterComposer,
      $TransactionsFtsOrderingComposer,
      $TransactionsFtsAnnotationComposer,
      $TransactionsFtsCreateCompanionBuilder,
      $TransactionsFtsUpdateCompanionBuilder,
      (
        TransactionsFt,
        BaseReferences<_$MonAIDatabase, TransactionsFts, TransactionsFt>,
      ),
      TransactionsFt,
      PrefetchHooks Function()
    >;
typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  required String id,
  Value<String?> providerId,
  required String name,
  required WalletType type,
  Value<String?> logoUrl,
  required int initialBalance,
  required int currentBalance,
  Value<String?> icon,
  Value<String?> color,
  required bool isDefault,
  required bool isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<String> id,
  Value<String?> providerId,
  Value<String> name,
  Value<WalletType> type,
  Value<String?> logoUrl,
  Value<int> initialBalance,
  Value<int> currentBalance,
  Value<String?> icon,
  Value<String?> color,
  Value<bool> isDefault,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WalletsTableFilterComposer
    extends Composer<_$MonAIDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalletType, WalletType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$MonAIDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $WalletsTable,
          WalletRow,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (
            WalletRow,
            BaseReferences<_$MonAIDatabase, $WalletsTable, WalletRow>,
          ),
          WalletRow,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$MonAIDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<WalletType> type = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<int> initialBalance = const Value.absent(),
                Value<int> currentBalance = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                providerId: providerId,
                name: name,
                type: type,
                logoUrl: logoUrl,
                initialBalance: initialBalance,
                currentBalance: currentBalance,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> providerId = const Value.absent(),
                required String name,
                required WalletType type,
                Value<String?> logoUrl = const Value.absent(),
                required int initialBalance,
                required int currentBalance,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                required bool isDefault,
                required bool isArchived,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                providerId: providerId,
                name: name,
                type: type,
                logoUrl: logoUrl,
                initialBalance: initialBalance,
                currentBalance: currentBalance,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletsTable, WalletRow>(table),
                  BaseReferences<_$MonAIDatabase, $WalletsTable, WalletRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $WalletsTable,
      WalletRow,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (WalletRow, BaseReferences<_$MonAIDatabase, $WalletsTable, WalletRow>),
      WalletRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  required CategoryType type,
  Value<String?> icon,
  Value<String?> color,
  required bool isDefault,
  required bool isSystem,
  required bool isHidden,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<CategoryType> type,
  Value<String?> icon,
  Value<String?> color,
  Value<bool> isDefault,
  Value<bool> isSystem,
  Value<bool> isHidden,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$MonAIDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryType, CategoryType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$MonAIDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$MonAIDatabase, $CategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$MonAIDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryType> type = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                type: type,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isSystem: isSystem,
                isHidden: isHidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required CategoryType type,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                required bool isDefault,
                required bool isSystem,
                required bool isHidden,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                type: type,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isSystem: isSystem,
                isHidden: isHidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  BaseReferences<
                    _$MonAIDatabase,
                    $CategoriesTable,
                    CategoryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$MonAIDatabase, $CategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionRemoteKeysTableCreateCompanionBuilder =
    TransactionRemoteKeysCompanion Function({
      required String queryKey,
      Value<String?> nextCursor,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionRemoteKeysTableUpdateCompanionBuilder =
    TransactionRemoteKeysCompanion Function({
      Value<String> queryKey,
      Value<String?> nextCursor,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TransactionRemoteKeysTableFilterComposer
    extends Composer<_$MonAIDatabase, $TransactionRemoteKeysTable> {
  $$TransactionRemoteKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextCursor => $composableBuilder(
    column: $table.nextCursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionRemoteKeysTableOrderingComposer
    extends Composer<_$MonAIDatabase, $TransactionRemoteKeysTable> {
  $$TransactionRemoteKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextCursor => $composableBuilder(
    column: $table.nextCursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionRemoteKeysTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $TransactionRemoteKeysTable> {
  $$TransactionRemoteKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queryKey =>
      $composableBuilder(column: $table.queryKey, builder: (column) => column);

  GeneratedColumn<String> get nextCursor => $composableBuilder(
    column: $table.nextCursor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionRemoteKeysTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $TransactionRemoteKeysTable,
          TransactionRemoteKeyRow,
          $$TransactionRemoteKeysTableFilterComposer,
          $$TransactionRemoteKeysTableOrderingComposer,
          $$TransactionRemoteKeysTableAnnotationComposer,
          $$TransactionRemoteKeysTableCreateCompanionBuilder,
          $$TransactionRemoteKeysTableUpdateCompanionBuilder,
          (
            TransactionRemoteKeyRow,
            BaseReferences<
              _$MonAIDatabase,
              $TransactionRemoteKeysTable,
              TransactionRemoteKeyRow
            >,
          ),
          TransactionRemoteKeyRow,
          PrefetchHooks Function()
        > {
  $$TransactionRemoteKeysTableTableManager(
    _$MonAIDatabase db,
    $TransactionRemoteKeysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionRemoteKeysTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionRemoteKeysTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionRemoteKeysTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> queryKey = const Value.absent(),
                Value<String?> nextCursor = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionRemoteKeysCompanion(
                queryKey: queryKey,
                nextCursor: nextCursor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String queryKey,
                Value<String?> nextCursor = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionRemoteKeysCompanion.insert(
                queryKey: queryKey,
                nextCursor: nextCursor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $TransactionRemoteKeysTable,
                    TransactionRemoteKeyRow
                  >(table),
                  BaseReferences<
                    _$MonAIDatabase,
                    $TransactionRemoteKeysTable,
                    TransactionRemoteKeyRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionRemoteKeysTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $TransactionRemoteKeysTable,
      TransactionRemoteKeyRow,
      $$TransactionRemoteKeysTableFilterComposer,
      $$TransactionRemoteKeysTableOrderingComposer,
      $$TransactionRemoteKeysTableAnnotationComposer,
      $$TransactionRemoteKeysTableCreateCompanionBuilder,
      $$TransactionRemoteKeysTableUpdateCompanionBuilder,
      (
        TransactionRemoteKeyRow,
        BaseReferences<
          _$MonAIDatabase,
          $TransactionRemoteKeysTable,
          TransactionRemoteKeyRow
        >,
      ),
      TransactionRemoteKeyRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required DateTime month,
  required int limitAmount,
  required int spent,
  required int remaining,
  required double progressPercent,
  required BudgetStatus status,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<DateTime> month,
  Value<int> limitAmount,
  Value<int> spent,
  Value<int> remaining,
  Value<double> progressPercent,
  Value<BudgetStatus> status,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$MonAIDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get month =>
      $composableBuilder(
        column: $table.month,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BudgetStatus, BudgetStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$MonAIDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DateTime, String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spent =>
      $composableBuilder(column: $table.spent, builder: (column) => column);

  GeneratedColumn<int> get remaining =>
      $composableBuilder(column: $table.remaining, builder: (column) => column);

  GeneratedColumn<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BudgetStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (
            BudgetRow,
            BaseReferences<_$MonAIDatabase, $BudgetsTable, BudgetRow>,
          ),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$MonAIDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> month = const Value.absent(),
                Value<int> limitAmount = const Value.absent(),
                Value<int> spent = const Value.absent(),
                Value<int> remaining = const Value.absent(),
                Value<double> progressPercent = const Value.absent(),
                Value<BudgetStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                month: month,
                limitAmount: limitAmount,
                spent: spent,
                remaining: remaining,
                progressPercent: progressPercent,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime month,
                required int limitAmount,
                required int spent,
                required int remaining,
                required double progressPercent,
                required BudgetStatus status,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                month: month,
                limitAmount: limitAmount,
                spent: spent,
                remaining: remaining,
                progressPercent: progressPercent,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  BaseReferences<_$MonAIDatabase, $BudgetsTable, BudgetRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$MonAIDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;
typedef $$PaymentProvidersTableCreateCompanionBuilder =
    PaymentProvidersCompanion Function({
      required String id,
      required String slug,
      required String name,
      required WalletType type,
      Value<String?> logoUrl,
      required List<String> aliases,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$PaymentProvidersTableUpdateCompanionBuilder =
    PaymentProvidersCompanion Function({
      Value<String> id,
      Value<String> slug,
      Value<String> name,
      Value<WalletType> type,
      Value<String?> logoUrl,
      Value<List<String>> aliases,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$PaymentProvidersTableFilterComposer
    extends Composer<_$MonAIDatabase, $PaymentProvidersTable> {
  $$PaymentProvidersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalletType, WalletType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentProvidersTableOrderingComposer
    extends Composer<_$MonAIDatabase, $PaymentProvidersTable> {
  $$PaymentProvidersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentProvidersTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $PaymentProvidersTable> {
  $$PaymentProvidersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$PaymentProvidersTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $PaymentProvidersTable,
          PaymentProviderRow,
          $$PaymentProvidersTableFilterComposer,
          $$PaymentProvidersTableOrderingComposer,
          $$PaymentProvidersTableAnnotationComposer,
          $$PaymentProvidersTableCreateCompanionBuilder,
          $$PaymentProvidersTableUpdateCompanionBuilder,
          (
            PaymentProviderRow,
            BaseReferences<
              _$MonAIDatabase,
              $PaymentProvidersTable,
              PaymentProviderRow
            >,
          ),
          PaymentProviderRow,
          PrefetchHooks Function()
        > {
  $$PaymentProvidersTableTableManager(
    _$MonAIDatabase db,
    $PaymentProvidersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentProvidersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentProvidersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentProvidersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<WalletType> type = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<List<String>> aliases = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentProvidersCompanion(
                id: id,
                slug: slug,
                name: name,
                type: type,
                logoUrl: logoUrl,
                aliases: aliases,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String slug,
                required String name,
                required WalletType type,
                Value<String?> logoUrl = const Value.absent(),
                required List<String> aliases,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => PaymentProvidersCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                type: type,
                logoUrl: logoUrl,
                aliases: aliases,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentProvidersTable, PaymentProviderRow>(
                    table,
                  ),
                  BaseReferences<
                    _$MonAIDatabase,
                    $PaymentProvidersTable,
                    PaymentProviderRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentProvidersTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $PaymentProvidersTable,
      PaymentProviderRow,
      $$PaymentProvidersTableFilterComposer,
      $$PaymentProvidersTableOrderingComposer,
      $$PaymentProvidersTableAnnotationComposer,
      $$PaymentProvidersTableCreateCompanionBuilder,
      $$PaymentProvidersTableUpdateCompanionBuilder,
      (
        PaymentProviderRow,
        BaseReferences<
          _$MonAIDatabase,
          $PaymentProvidersTable,
          PaymentProviderRow
        >,
      ),
      PaymentProviderRow,
      PrefetchHooks Function()
    >;
typedef $$PaymentProviderCatalogTableCreateCompanionBuilder =
    PaymentProviderCatalogCompanion Function({
      Value<int> id,
      required int version,
      Value<String?> etag,
    });
typedef $$PaymentProviderCatalogTableUpdateCompanionBuilder =
    PaymentProviderCatalogCompanion Function({
      Value<int> id,
      Value<int> version,
      Value<String?> etag,
    });

class $$PaymentProviderCatalogTableFilterComposer
    extends Composer<_$MonAIDatabase, $PaymentProviderCatalogTable> {
  $$PaymentProviderCatalogTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentProviderCatalogTableOrderingComposer
    extends Composer<_$MonAIDatabase, $PaymentProviderCatalogTable> {
  $$PaymentProviderCatalogTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentProviderCatalogTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $PaymentProviderCatalogTable> {
  $$PaymentProviderCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);
}

class $$PaymentProviderCatalogTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $PaymentProviderCatalogTable,
          PaymentProviderCatalogRow,
          $$PaymentProviderCatalogTableFilterComposer,
          $$PaymentProviderCatalogTableOrderingComposer,
          $$PaymentProviderCatalogTableAnnotationComposer,
          $$PaymentProviderCatalogTableCreateCompanionBuilder,
          $$PaymentProviderCatalogTableUpdateCompanionBuilder,
          (
            PaymentProviderCatalogRow,
            BaseReferences<
              _$MonAIDatabase,
              $PaymentProviderCatalogTable,
              PaymentProviderCatalogRow
            >,
          ),
          PaymentProviderCatalogRow,
          PrefetchHooks Function()
        > {
  $$PaymentProviderCatalogTableTableManager(
    _$MonAIDatabase db,
    $PaymentProviderCatalogTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentProviderCatalogTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PaymentProviderCatalogTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaymentProviderCatalogTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> etag = const Value.absent(),
              }) => PaymentProviderCatalogCompanion(
                id: id,
                version: version,
                etag: etag,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int version,
                Value<String?> etag = const Value.absent(),
              }) => PaymentProviderCatalogCompanion.insert(
                id: id,
                version: version,
                etag: etag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PaymentProviderCatalogTable,
                    PaymentProviderCatalogRow
                  >(table),
                  BaseReferences<
                    _$MonAIDatabase,
                    $PaymentProviderCatalogTable,
                    PaymentProviderCatalogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentProviderCatalogTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $PaymentProviderCatalogTable,
      PaymentProviderCatalogRow,
      $$PaymentProviderCatalogTableFilterComposer,
      $$PaymentProviderCatalogTableOrderingComposer,
      $$PaymentProviderCatalogTableAnnotationComposer,
      $$PaymentProviderCatalogTableCreateCompanionBuilder,
      $$PaymentProviderCatalogTableUpdateCompanionBuilder,
      (
        PaymentProviderCatalogRow,
        BaseReferences<
          _$MonAIDatabase,
          $PaymentProviderCatalogTable,
          PaymentProviderCatalogRow
        >,
      ),
      PaymentProviderCatalogRow,
      PrefetchHooks Function()
    >;
typedef $$MonthlyReportsTableCreateCompanionBuilder =
    MonthlyReportsCompanion Function({
      required DateTime month,
      required int incomeTotal,
      required int expenseTotal,
      required int net,
      required DateTime previousMonth,
      required int previousIncomeTotal,
      required int previousExpenseTotal,
      Value<double?> expenseChangePercent,
      Value<int> rowid,
    });
typedef $$MonthlyReportsTableUpdateCompanionBuilder =
    MonthlyReportsCompanion Function({
      Value<DateTime> month,
      Value<int> incomeTotal,
      Value<int> expenseTotal,
      Value<int> net,
      Value<DateTime> previousMonth,
      Value<int> previousIncomeTotal,
      Value<int> previousExpenseTotal,
      Value<double?> expenseChangePercent,
      Value<int> rowid,
    });

final class $$MonthlyReportsTableReferences
    extends
        BaseReferences<
          _$MonAIDatabase,
          $MonthlyReportsTable,
          MonthlyReportRow
        > {
  $$MonthlyReportsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ReportCategoriesTable, List<ReportCategoryRow>>
  _reportCategoriesRefsTable(_$MonAIDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reportCategories,
        aliasName: 'monthly_reports__month__report_categories__month',
      );

  $$ReportCategoriesTableProcessedTableManager get reportCategoriesRefs {
    final manager = $$ReportCategoriesTableTableManager(
      $_db,
      $_db.reportCategories,
    ).filter((f) => f.month.month.sqlEquals($_itemColumn<String>('month')!));

    final cache = $_typedResult.readTableOrNull(
      _reportCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MonthlyReportsTableFilterComposer
    extends Composer<_$MonAIDatabase, $MonthlyReportsTable> {
  $$MonthlyReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get month =>
      $composableBuilder(
        column: $table.month,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get net => $composableBuilder(
    column: $table.net,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String>
  get previousMonth => $composableBuilder(
    column: $table.previousMonth,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get previousIncomeTotal => $composableBuilder(
    column: $table.previousIncomeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousExpenseTotal => $composableBuilder(
    column: $table.previousExpenseTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expenseChangePercent => $composableBuilder(
    column: $table.expenseChangePercent,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reportCategoriesRefs(
    Expression<bool> Function($$ReportCategoriesTableFilterComposer f) f,
  ) {
    final $$ReportCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.month,
      referencedTable: $db.reportCategories,
      getReferencedColumn: (t) => t.month,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.reportCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyReportsTableOrderingComposer
    extends Composer<_$MonAIDatabase, $MonthlyReportsTable> {
  $$MonthlyReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get net => $composableBuilder(
    column: $table.net,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousMonth => $composableBuilder(
    column: $table.previousMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousIncomeTotal => $composableBuilder(
    column: $table.previousIncomeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousExpenseTotal => $composableBuilder(
    column: $table.previousExpenseTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expenseChangePercent => $composableBuilder(
    column: $table.expenseChangePercent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyReportsTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $MonthlyReportsTable> {
  $$MonthlyReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DateTime, String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get net =>
      $composableBuilder(column: $table.net, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get previousMonth =>
      $composableBuilder(
        column: $table.previousMonth,
        builder: (column) => column,
      );

  GeneratedColumn<int> get previousIncomeTotal => $composableBuilder(
    column: $table.previousIncomeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousExpenseTotal => $composableBuilder(
    column: $table.previousExpenseTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expenseChangePercent => $composableBuilder(
    column: $table.expenseChangePercent,
    builder: (column) => column,
  );

  Expression<T> reportCategoriesRefs<T extends Object>(
    Expression<T> Function($$ReportCategoriesTableAnnotationComposer a) f,
  ) {
    final $$ReportCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.month,
      referencedTable: $db.reportCategories,
      getReferencedColumn: (t) => t.month,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.reportCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyReportsTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $MonthlyReportsTable,
          MonthlyReportRow,
          $$MonthlyReportsTableFilterComposer,
          $$MonthlyReportsTableOrderingComposer,
          $$MonthlyReportsTableAnnotationComposer,
          $$MonthlyReportsTableCreateCompanionBuilder,
          $$MonthlyReportsTableUpdateCompanionBuilder,
          (MonthlyReportRow, $$MonthlyReportsTableReferences),
          MonthlyReportRow,
          PrefetchHooks Function({bool reportCategoriesRefs})
        > {
  $$MonthlyReportsTableTableManager(
    _$MonAIDatabase db,
    $MonthlyReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> month = const Value.absent(),
                Value<int> incomeTotal = const Value.absent(),
                Value<int> expenseTotal = const Value.absent(),
                Value<int> net = const Value.absent(),
                Value<DateTime> previousMonth = const Value.absent(),
                Value<int> previousIncomeTotal = const Value.absent(),
                Value<int> previousExpenseTotal = const Value.absent(),
                Value<double?> expenseChangePercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthlyReportsCompanion(
                month: month,
                incomeTotal: incomeTotal,
                expenseTotal: expenseTotal,
                net: net,
                previousMonth: previousMonth,
                previousIncomeTotal: previousIncomeTotal,
                previousExpenseTotal: previousExpenseTotal,
                expenseChangePercent: expenseChangePercent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime month,
                required int incomeTotal,
                required int expenseTotal,
                required int net,
                required DateTime previousMonth,
                required int previousIncomeTotal,
                required int previousExpenseTotal,
                Value<double?> expenseChangePercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthlyReportsCompanion.insert(
                month: month,
                incomeTotal: incomeTotal,
                expenseTotal: expenseTotal,
                net: net,
                previousMonth: previousMonth,
                previousIncomeTotal: previousIncomeTotal,
                previousExpenseTotal: previousExpenseTotal,
                expenseChangePercent: expenseChangePercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonthlyReportsTable, MonthlyReportRow>(table),
                  $$MonthlyReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportCategoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reportCategoriesRefs) db.reportCategories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reportCategoriesRefs)
                    await $_getPrefetchedData<
                      MonthlyReportRow,
                      $MonthlyReportsTable,
                      ReportCategoryRow
                    >(
                      currentTable: table,
                      referencedTable: $$MonthlyReportsTableReferences
                          ._reportCategoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MonthlyReportsTableReferences(
                            db,
                            table,
                            p0,
                          ).reportCategoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.month == item.month),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MonthlyReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $MonthlyReportsTable,
      MonthlyReportRow,
      $$MonthlyReportsTableFilterComposer,
      $$MonthlyReportsTableOrderingComposer,
      $$MonthlyReportsTableAnnotationComposer,
      $$MonthlyReportsTableCreateCompanionBuilder,
      $$MonthlyReportsTableUpdateCompanionBuilder,
      (MonthlyReportRow, $$MonthlyReportsTableReferences),
      MonthlyReportRow,
      PrefetchHooks Function({bool reportCategoriesRefs})
    >;
typedef $$ReportCategoriesTableCreateCompanionBuilder =
    ReportCategoriesCompanion Function({
      required DateTime month,
      required String categoryId,
      required int position,
      required String name,
      Value<String?> icon,
      Value<String?> color,
      required int amount,
      required double sharePercent,
      required int previousAmount,
      Value<double?> changePercent,
      Value<int> rowid,
    });
typedef $$ReportCategoriesTableUpdateCompanionBuilder =
    ReportCategoriesCompanion Function({
      Value<DateTime> month,
      Value<String> categoryId,
      Value<int> position,
      Value<String> name,
      Value<String?> icon,
      Value<String?> color,
      Value<int> amount,
      Value<double> sharePercent,
      Value<int> previousAmount,
      Value<double?> changePercent,
      Value<int> rowid,
    });

final class $$ReportCategoriesTableReferences
    extends
        BaseReferences<
          _$MonAIDatabase,
          $ReportCategoriesTable,
          ReportCategoryRow
        > {
  $$ReportCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MonthlyReportsTable _monthTable(_$MonAIDatabase db) => db
      .monthlyReports
      .createAlias('report_categories__month__monthly_reports__month');

  $$MonthlyReportsTableProcessedTableManager get month {
    final $_column = $_itemColumn<String>('month')!;

    final manager = $$MonthlyReportsTableTableManager(
      $_db,
      $_db.monthlyReports,
    ).filter((f) => f.month.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_monthTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportCategoriesTableFilterComposer
    extends Composer<_$MonAIDatabase, $ReportCategoriesTable> {
  $$ReportCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousAmount => $composableBuilder(
    column: $table.previousAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => ColumnFilters(column),
  );

  $$MonthlyReportsTableFilterComposer get month {
    final $$MonthlyReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.month,
      referencedTable: $db.monthlyReports,
      getReferencedColumn: (t) => t.month,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyReportsTableFilterComposer(
            $db: $db,
            $table: $db.monthlyReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportCategoriesTableOrderingComposer
    extends Composer<_$MonAIDatabase, $ReportCategoriesTable> {
  $$ReportCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousAmount => $composableBuilder(
    column: $table.previousAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => ColumnOrderings(column),
  );

  $$MonthlyReportsTableOrderingComposer get month {
    final $$MonthlyReportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.month,
      referencedTable: $db.monthlyReports,
      getReferencedColumn: (t) => t.month,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyReportsTableOrderingComposer(
            $db: $db,
            $table: $db.monthlyReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportCategoriesTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $ReportCategoriesTable> {
  $$ReportCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousAmount => $composableBuilder(
    column: $table.previousAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get changePercent => $composableBuilder(
    column: $table.changePercent,
    builder: (column) => column,
  );

  $$MonthlyReportsTableAnnotationComposer get month {
    final $$MonthlyReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.month,
      referencedTable: $db.monthlyReports,
      getReferencedColumn: (t) => t.month,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.monthlyReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportCategoriesTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $ReportCategoriesTable,
          ReportCategoryRow,
          $$ReportCategoriesTableFilterComposer,
          $$ReportCategoriesTableOrderingComposer,
          $$ReportCategoriesTableAnnotationComposer,
          $$ReportCategoriesTableCreateCompanionBuilder,
          $$ReportCategoriesTableUpdateCompanionBuilder,
          (ReportCategoryRow, $$ReportCategoriesTableReferences),
          ReportCategoryRow,
          PrefetchHooks Function({bool month})
        > {
  $$ReportCategoriesTableTableManager(
    _$MonAIDatabase db,
    $ReportCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> month = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<double> sharePercent = const Value.absent(),
                Value<int> previousAmount = const Value.absent(),
                Value<double?> changePercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportCategoriesCompanion(
                month: month,
                categoryId: categoryId,
                position: position,
                name: name,
                icon: icon,
                color: color,
                amount: amount,
                sharePercent: sharePercent,
                previousAmount: previousAmount,
                changePercent: changePercent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime month,
                required String categoryId,
                required int position,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                required int amount,
                required double sharePercent,
                required int previousAmount,
                Value<double?> changePercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportCategoriesCompanion.insert(
                month: month,
                categoryId: categoryId,
                position: position,
                name: name,
                icon: icon,
                color: color,
                amount: amount,
                sharePercent: sharePercent,
                previousAmount: previousAmount,
                changePercent: changePercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportCategoriesTable, ReportCategoryRow>(table),
                  $$ReportCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({month = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (month) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.month,
                        referencedTable: $$ReportCategoriesTableReferences
                            ._monthTable(db),
                        referencedColumn: $$ReportCategoriesTableReferences
                            ._monthTable(db)
                            .month,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $ReportCategoriesTable,
      ReportCategoryRow,
      $$ReportCategoriesTableFilterComposer,
      $$ReportCategoriesTableOrderingComposer,
      $$ReportCategoriesTableAnnotationComposer,
      $$ReportCategoriesTableCreateCompanionBuilder,
      $$ReportCategoriesTableUpdateCompanionBuilder,
      (ReportCategoryRow, $$ReportCategoriesTableReferences),
      ReportCategoryRow,
      PrefetchHooks Function({bool month})
    >;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String email,
  Value<String?> avatarUrl,
  required String timezone,
  required String roleSlug,
  required String roleName,
  required List<String> permissions,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> email,
  Value<String?> avatarUrl,
  Value<String> timezone,
  Value<String> roleSlug,
  Value<String> roleName,
  Value<List<String>> permissions,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer
    extends Composer<_$MonAIDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleSlug => $composableBuilder(
    column: $table.roleSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleName => $composableBuilder(
    column: $table.roleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$MonAIDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleSlug => $composableBuilder(
    column: $table.roleSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleName => $composableBuilder(
    column: $table.roleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$MonAIDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<String> get roleSlug =>
      $composableBuilder(column: $table.roleSlug, builder: (column) => column);

  GeneratedColumn<String> get roleName =>
      $composableBuilder(column: $table.roleName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get permissions =>
      $composableBuilder(
        column: $table.permissions,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$MonAIDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$MonAIDatabase, $UsersTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$MonAIDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<String> roleSlug = const Value.absent(),
                Value<String> roleName = const Value.absent(),
                Value<List<String>> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
                timezone: timezone,
                roleSlug: roleSlug,
                roleName: roleName,
                permissions: permissions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<String?> avatarUrl = const Value.absent(),
                required String timezone,
                required String roleSlug,
                required String roleName,
                required List<String> permissions,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
                timezone: timezone,
                roleSlug: roleSlug,
                roleName: roleName,
                permissions: permissions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, UserRow>(table),
                  BaseReferences<_$MonAIDatabase, $UsersTable, UserRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$MonAIDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$MonAIDatabase, $UsersTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;

class $MonAIDatabaseManager {
  final _$MonAIDatabase _db;
  $MonAIDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $TransactionsFtsTableManager get transactionsFts =>
      $TransactionsFtsTableManager(_db, _db.transactionsFts);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionRemoteKeysTableTableManager get transactionRemoteKeys =>
      $$TransactionRemoteKeysTableTableManager(_db, _db.transactionRemoteKeys);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$PaymentProvidersTableTableManager get paymentProviders =>
      $$PaymentProvidersTableTableManager(_db, _db.paymentProviders);
  $$PaymentProviderCatalogTableTableManager get paymentProviderCatalog =>
      $$PaymentProviderCatalogTableTableManager(
        _db,
        _db.paymentProviderCatalog,
      );
  $$MonthlyReportsTableTableManager get monthlyReports =>
      $$MonthlyReportsTableTableManager(_db, _db.monthlyReports);
  $$ReportCategoriesTableTableManager get reportCategories =>
      $$ReportCategoriesTableTableManager(_db, _db.reportCategories);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
