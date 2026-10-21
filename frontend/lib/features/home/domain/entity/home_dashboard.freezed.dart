// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeDashboard {

 DateTime get month; HomeGreeting get greeting; String get userName; String get initials;/// Whether a user or any wallet is cached, so there is something to show
/// while a refresh runs.
 bool get hasCache; int get totalBalance; List<Wallet> get wallets;/// Days after today until the month ends; 0 on its last day.
 int get daysLeftInMonth;/// At most [kMaxSpendingSlices], largest first; the last may be
/// "Others".
 List<SpendingSlice> get spending; List<RecentTransaction> get recent; String? get avatarUrl; MonthSummary? get summary; Budget? get budget;
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<HomeDashboard> get copyWith => _$HomeDashboardCopyWithImpl<HomeDashboard>(this as HomeDashboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboard&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.greeting, _this.greeting) || other.greeting == _this.greeting)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.initials, _this.initials) || other.initials == _this.initials)&&(identical(other.hasCache, _this.hasCache) || other.hasCache == _this.hasCache)&&(identical(other.totalBalance, _this.totalBalance) || other.totalBalance == _this.totalBalance)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&(identical(other.daysLeftInMonth, _this.daysLeftInMonth) || other.daysLeftInMonth == _this.daysLeftInMonth)&&const DeepCollectionEquality().equals(other.spending, _this.spending)&&const DeepCollectionEquality().equals(other.recent, _this.recent)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.budget, _this.budget) || other.budget == _this.budget));
}


@override
int get hashCode {
  final _this = this as HomeDashboard;
  return Object.hash(runtimeType,_this.month,_this.greeting,_this.userName,_this.initials,_this.hasCache,_this.totalBalance,const DeepCollectionEquality().hash(_this.wallets),_this.daysLeftInMonth,const DeepCollectionEquality().hash(_this.spending),const DeepCollectionEquality().hash(_this.recent),_this.avatarUrl,_this.summary,_this.budget);
}

@override
String toString() {
  final _this = this as HomeDashboard;
  return 'HomeDashboard(month: ${_this.month}, greeting: ${_this.greeting}, userName: ${_this.userName}, initials: ${_this.initials}, hasCache: ${_this.hasCache}, totalBalance: ${_this.totalBalance}, wallets: ${_this.wallets}, daysLeftInMonth: ${_this.daysLeftInMonth}, spending: ${_this.spending}, recent: ${_this.recent}, avatarUrl: ${_this.avatarUrl}, summary: ${_this.summary}, budget: ${_this.budget})';
}


}

/// @nodoc
abstract mixin class $HomeDashboardCopyWith<$Res>  {
  factory $HomeDashboardCopyWith(HomeDashboard value, $Res Function(HomeDashboard) _then) = _$HomeDashboardCopyWithImpl;
@useResult
$Res call({
 DateTime month, HomeGreeting greeting, String userName, String initials, bool hasCache, int totalBalance, List<Wallet> wallets, int daysLeftInMonth, List<SpendingSlice> spending, List<RecentTransaction> recent, String? avatarUrl, MonthSummary? summary, Budget? budget
});


$MonthSummaryCopyWith<$Res>? get summary;$BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class _$HomeDashboardCopyWithImpl<$Res>
    implements $HomeDashboardCopyWith<$Res> {
  _$HomeDashboardCopyWithImpl(this._self, this._then);

  final HomeDashboard _self;
  final $Res Function(HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? greeting = null,Object? userName = null,Object? initials = null,Object? hasCache = null,Object? totalBalance = null,Object? wallets = null,Object? daysLeftInMonth = null,Object? spending = null,Object? recent = null,Object? avatarUrl = freezed,Object? summary = freezed,Object? budget = freezed,}) {
  return _then(HomeDashboard(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,greeting: null == greeting ? _self.greeting : greeting // ignore: cast_nullable_to_non_nullable
as HomeGreeting,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,hasCache: null == hasCache ? _self.hasCache : hasCache // ignore: cast_nullable_to_non_nullable
as bool,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,daysLeftInMonth: null == daysLeftInMonth ? _self.daysLeftInMonth : daysLeftInMonth // ignore: cast_nullable_to_non_nullable
as int,spending: null == spending ? _self.spending : spending // ignore: cast_nullable_to_non_nullable
as List<SpendingSlice>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<RecentTransaction>,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthSummary?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,
  ));
}
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MonthSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get budget {
    if (_self.budget == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.budget!, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeDashboard].
extension HomeDashboardPatterns on HomeDashboard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboard value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  HomeGreeting greeting,  String userName,  String initials,  bool hasCache,  int totalBalance,  List<Wallet> wallets,  int daysLeftInMonth,  List<SpendingSlice> spending,  List<RecentTransaction> recent,  String? avatarUrl,  MonthSummary? summary,  Budget? budget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.month,_that.greeting,_that.userName,_that.initials,_that.hasCache,_that.totalBalance,_that.wallets,_that.daysLeftInMonth,_that.spending,_that.recent,_that.avatarUrl,_that.summary,_that.budget);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  HomeGreeting greeting,  String userName,  String initials,  bool hasCache,  int totalBalance,  List<Wallet> wallets,  int daysLeftInMonth,  List<SpendingSlice> spending,  List<RecentTransaction> recent,  String? avatarUrl,  MonthSummary? summary,  Budget? budget)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard():
return $default(_that.month,_that.greeting,_that.userName,_that.initials,_that.hasCache,_that.totalBalance,_that.wallets,_that.daysLeftInMonth,_that.spending,_that.recent,_that.avatarUrl,_that.summary,_that.budget);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  HomeGreeting greeting,  String userName,  String initials,  bool hasCache,  int totalBalance,  List<Wallet> wallets,  int daysLeftInMonth,  List<SpendingSlice> spending,  List<RecentTransaction> recent,  String? avatarUrl,  MonthSummary? summary,  Budget? budget)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.month,_that.greeting,_that.userName,_that.initials,_that.hasCache,_that.totalBalance,_that.wallets,_that.daysLeftInMonth,_that.spending,_that.recent,_that.avatarUrl,_that.summary,_that.budget);case _:
  return null;

}
}

}

/// @nodoc


class _HomeDashboard implements HomeDashboard {
  const _HomeDashboard({required this.month, required this.greeting, required this.userName, required this.initials, required this.hasCache, required this.totalBalance, required  List<Wallet> wallets, required this.daysLeftInMonth, required  List<SpendingSlice> spending, required  List<RecentTransaction> recent, this.avatarUrl, this.summary, this.budget}): _wallets = wallets,_spending = spending,_recent = recent;
  

@override final  DateTime month;
@override final  HomeGreeting greeting;
@override final  String userName;
@override final  String initials;
/// Whether a user or any wallet is cached, so there is something to show
/// while a refresh runs.
@override final  bool hasCache;
@override final  int totalBalance;
 final  List<Wallet> _wallets;
@override List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

/// Days after today until the month ends; 0 on its last day.
@override final  int daysLeftInMonth;
/// At most [kMaxSpendingSlices], largest first; the last may be
/// "Others".
 final  List<SpendingSlice> _spending;
/// At most [kMaxSpendingSlices], largest first; the last may be
/// "Others".
@override List<SpendingSlice> get spending {
  if (_spending is EqualUnmodifiableListView) return _spending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spending);
}

 final  List<RecentTransaction> _recent;
@override List<RecentTransaction> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}

@override final  String? avatarUrl;
@override final  MonthSummary? summary;
@override final  Budget? budget;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardCopyWith<_HomeDashboard> get copyWith => __$HomeDashboardCopyWithImpl<_HomeDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboard&&(identical(other.month, month) || other.month == month)&&(identical(other.greeting, greeting) || other.greeting == greeting)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.hasCache, hasCache) || other.hasCache == hasCache)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&(identical(other.daysLeftInMonth, daysLeftInMonth) || other.daysLeftInMonth == daysLeftInMonth)&&const DeepCollectionEquality().equals(other.spending, _spending)&&const DeepCollectionEquality().equals(other.recent, _recent)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.budget, budget) || other.budget == budget));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,greeting,userName,initials,hasCache,totalBalance,const DeepCollectionEquality().hash(_wallets),daysLeftInMonth,const DeepCollectionEquality().hash(_spending),const DeepCollectionEquality().hash(_recent),avatarUrl,summary,budget);
}

@override
String toString() {
    return 'HomeDashboard(month: $month, greeting: $greeting, userName: $userName, initials: $initials, hasCache: $hasCache, totalBalance: $totalBalance, wallets: $wallets, daysLeftInMonth: $daysLeftInMonth, spending: $spending, recent: $recent, avatarUrl: $avatarUrl, summary: $summary, budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardCopyWith<$Res> implements $HomeDashboardCopyWith<$Res> {
  factory _$HomeDashboardCopyWith(_HomeDashboard value, $Res Function(_HomeDashboard) _then) = __$HomeDashboardCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, HomeGreeting greeting, String userName, String initials, bool hasCache, int totalBalance, List<Wallet> wallets, int daysLeftInMonth, List<SpendingSlice> spending, List<RecentTransaction> recent, String? avatarUrl, MonthSummary? summary, Budget? budget
});


@override $MonthSummaryCopyWith<$Res>? get summary;@override $BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class __$HomeDashboardCopyWithImpl<$Res>
    implements _$HomeDashboardCopyWith<$Res> {
  __$HomeDashboardCopyWithImpl(this._self, this._then);

  final _HomeDashboard _self;
  final $Res Function(_HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? greeting = null,Object? userName = null,Object? initials = null,Object? hasCache = null,Object? totalBalance = null,Object? wallets = null,Object? daysLeftInMonth = null,Object? spending = null,Object? recent = null,Object? avatarUrl = freezed,Object? summary = freezed,Object? budget = freezed,}) {
  return _then(_HomeDashboard(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,greeting: null == greeting ? _self.greeting : greeting // ignore: cast_nullable_to_non_nullable
as HomeGreeting,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,hasCache: null == hasCache ? _self.hasCache : hasCache // ignore: cast_nullable_to_non_nullable
as bool,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,daysLeftInMonth: null == daysLeftInMonth ? _self.daysLeftInMonth : daysLeftInMonth // ignore: cast_nullable_to_non_nullable
as int,spending: null == spending ? _self._spending : spending // ignore: cast_nullable_to_non_nullable
as List<SpendingSlice>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<RecentTransaction>,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MonthSummary?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,
  ));
}

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MonthSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get budget {
    if (_self.budget == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.budget!, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}

/// @nodoc
mixin _$MonthSummary {

 int get incomeTotal; int get expenseTotal; DateTime get previousMonth;/// Against [previousMonth]; negative means less was spent. Null when
/// that month had no expenses.
 double? get expenseChangePercent;
/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthSummaryCopyWith<MonthSummary> get copyWith => _$MonthSummaryCopyWithImpl<MonthSummary>(this as MonthSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthSummary&&(identical(other.incomeTotal, _this.incomeTotal) || other.incomeTotal == _this.incomeTotal)&&(identical(other.expenseTotal, _this.expenseTotal) || other.expenseTotal == _this.expenseTotal)&&(identical(other.previousMonth, _this.previousMonth) || other.previousMonth == _this.previousMonth)&&(identical(other.expenseChangePercent, _this.expenseChangePercent) || other.expenseChangePercent == _this.expenseChangePercent));
}


@override
int get hashCode {
  final _this = this as MonthSummary;
  return Object.hash(runtimeType,_this.incomeTotal,_this.expenseTotal,_this.previousMonth,_this.expenseChangePercent);
}

@override
String toString() {
  final _this = this as MonthSummary;
  return 'MonthSummary(incomeTotal: ${_this.incomeTotal}, expenseTotal: ${_this.expenseTotal}, previousMonth: ${_this.previousMonth}, expenseChangePercent: ${_this.expenseChangePercent})';
}


}

/// @nodoc
abstract mixin class $MonthSummaryCopyWith<$Res>  {
  factory $MonthSummaryCopyWith(MonthSummary value, $Res Function(MonthSummary) _then) = _$MonthSummaryCopyWithImpl;
@useResult
$Res call({
 int incomeTotal, int expenseTotal, DateTime previousMonth, double? expenseChangePercent
});




}
/// @nodoc
class _$MonthSummaryCopyWithImpl<$Res>
    implements $MonthSummaryCopyWith<$Res> {
  _$MonthSummaryCopyWithImpl(this._self, this._then);

  final MonthSummary _self;
  final $Res Function(MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? incomeTotal = null,Object? expenseTotal = null,Object? previousMonth = null,Object? expenseChangePercent = freezed,}) {
  return _then(MonthSummary(
incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,previousMonth: null == previousMonth ? _self.previousMonth : previousMonth // ignore: cast_nullable_to_non_nullable
as DateTime,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthSummary].
extension MonthSummaryPatterns on MonthSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthSummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int incomeTotal,  int expenseTotal,  DateTime previousMonth,  double? expenseChangePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.incomeTotal,_that.expenseTotal,_that.previousMonth,_that.expenseChangePercent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int incomeTotal,  int expenseTotal,  DateTime previousMonth,  double? expenseChangePercent)  $default,) {final _that = this;
switch (_that) {
case _MonthSummary():
return $default(_that.incomeTotal,_that.expenseTotal,_that.previousMonth,_that.expenseChangePercent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int incomeTotal,  int expenseTotal,  DateTime previousMonth,  double? expenseChangePercent)?  $default,) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.incomeTotal,_that.expenseTotal,_that.previousMonth,_that.expenseChangePercent);case _:
  return null;

}
}

}

/// @nodoc


class _MonthSummary implements MonthSummary {
  const _MonthSummary({required this.incomeTotal, required this.expenseTotal, required this.previousMonth, this.expenseChangePercent});
  

@override final  int incomeTotal;
@override final  int expenseTotal;
@override final  DateTime previousMonth;
/// Against [previousMonth]; negative means less was spent. Null when
/// that month had no expenses.
@override final  double? expenseChangePercent;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthSummaryCopyWith<_MonthSummary> get copyWith => __$MonthSummaryCopyWithImpl<_MonthSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthSummary&&(identical(other.incomeTotal, incomeTotal) || other.incomeTotal == incomeTotal)&&(identical(other.expenseTotal, expenseTotal) || other.expenseTotal == expenseTotal)&&(identical(other.previousMonth, previousMonth) || other.previousMonth == previousMonth)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,incomeTotal,expenseTotal,previousMonth,expenseChangePercent);
}

@override
String toString() {
    return 'MonthSummary(incomeTotal: $incomeTotal, expenseTotal: $expenseTotal, previousMonth: $previousMonth, expenseChangePercent: $expenseChangePercent)';
}


}

/// @nodoc
abstract mixin class _$MonthSummaryCopyWith<$Res> implements $MonthSummaryCopyWith<$Res> {
  factory _$MonthSummaryCopyWith(_MonthSummary value, $Res Function(_MonthSummary) _then) = __$MonthSummaryCopyWithImpl;
@override @useResult
$Res call({
 int incomeTotal, int expenseTotal, DateTime previousMonth, double? expenseChangePercent
});




}
/// @nodoc
class __$MonthSummaryCopyWithImpl<$Res>
    implements _$MonthSummaryCopyWith<$Res> {
  __$MonthSummaryCopyWithImpl(this._self, this._then);

  final _MonthSummary _self;
  final $Res Function(_MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? incomeTotal = null,Object? expenseTotal = null,Object? previousMonth = null,Object? expenseChangePercent = freezed,}) {
  return _then(_MonthSummary(
incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,previousMonth: null == previousMonth ? _self.previousMonth : previousMonth // ignore: cast_nullable_to_non_nullable
as DateTime,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$SpendingSlice {

 int get amount; double get sharePercent;/// Null for the "Others" slice.
 String? get categoryId; String? get name;/// `#RRGGBB`; null uses the neutral color.
 String? get color;
/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendingSliceCopyWith<SpendingSlice> get copyWith => _$SpendingSliceCopyWithImpl<SpendingSlice>(this as SpendingSlice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpendingSlice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendingSlice&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.sharePercent, _this.sharePercent) || other.sharePercent == _this.sharePercent)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.color, _this.color) || other.color == _this.color));
}


@override
int get hashCode {
  final _this = this as SpendingSlice;
  return Object.hash(runtimeType,_this.amount,_this.sharePercent,_this.categoryId,_this.name,_this.color);
}

@override
String toString() {
  final _this = this as SpendingSlice;
  return 'SpendingSlice(amount: ${_this.amount}, sharePercent: ${_this.sharePercent}, categoryId: ${_this.categoryId}, name: ${_this.name}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $SpendingSliceCopyWith<$Res>  {
  factory $SpendingSliceCopyWith(SpendingSlice value, $Res Function(SpendingSlice) _then) = _$SpendingSliceCopyWithImpl;
@useResult
$Res call({
 int amount, double sharePercent, String? categoryId, String? name, String? color
});




}
/// @nodoc
class _$SpendingSliceCopyWithImpl<$Res>
    implements $SpendingSliceCopyWith<$Res> {
  _$SpendingSliceCopyWithImpl(this._self, this._then);

  final SpendingSlice _self;
  final $Res Function(SpendingSlice) _then;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? sharePercent = null,Object? categoryId = freezed,Object? name = freezed,Object? color = freezed,}) {
  return _then(SpendingSlice(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sharePercent: null == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpendingSlice].
extension SpendingSlicePatterns on SpendingSlice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpendingSlice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpendingSlice value)  $default,){
final _that = this;
switch (_that) {
case _SpendingSlice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpendingSlice value)?  $default,){
final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  double sharePercent,  String? categoryId,  String? name,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that.amount,_that.sharePercent,_that.categoryId,_that.name,_that.color);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  double sharePercent,  String? categoryId,  String? name,  String? color)  $default,) {final _that = this;
switch (_that) {
case _SpendingSlice():
return $default(_that.amount,_that.sharePercent,_that.categoryId,_that.name,_that.color);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  double sharePercent,  String? categoryId,  String? name,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that.amount,_that.sharePercent,_that.categoryId,_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _SpendingSlice extends SpendingSlice {
  const _SpendingSlice({required this.amount, required this.sharePercent, this.categoryId, this.name, this.color}): super._();
  

@override final  int amount;
@override final  double sharePercent;
/// Null for the "Others" slice.
@override final  String? categoryId;
@override final  String? name;
/// `#RRGGBB`; null uses the neutral color.
@override final  String? color;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpendingSliceCopyWith<_SpendingSlice> get copyWith => __$SpendingSliceCopyWithImpl<_SpendingSlice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpendingSlice&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sharePercent, sharePercent) || other.sharePercent == sharePercent)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,amount,sharePercent,categoryId,name,color);
}

@override
String toString() {
    return 'SpendingSlice(amount: $amount, sharePercent: $sharePercent, categoryId: $categoryId, name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$SpendingSliceCopyWith<$Res> implements $SpendingSliceCopyWith<$Res> {
  factory _$SpendingSliceCopyWith(_SpendingSlice value, $Res Function(_SpendingSlice) _then) = __$SpendingSliceCopyWithImpl;
@override @useResult
$Res call({
 int amount, double sharePercent, String? categoryId, String? name, String? color
});




}
/// @nodoc
class __$SpendingSliceCopyWithImpl<$Res>
    implements _$SpendingSliceCopyWith<$Res> {
  __$SpendingSliceCopyWithImpl(this._self, this._then);

  final _SpendingSlice _self;
  final $Res Function(_SpendingSlice) _then;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? sharePercent = null,Object? categoryId = freezed,Object? name = freezed,Object? color = freezed,}) {
  return _then(_SpendingSlice(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sharePercent: null == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$RecentTransaction {

 String get id; TransactionType get type; int get amount; RecentDay get day;/// The note, else the merchant, else the category name; null when there
/// is none, so the screen labels it by its [type].
 String? get title; String? get categoryName; String? get icon; String? get color; String? get walletName; String? get toWalletName;
/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentTransactionCopyWith<RecentTransaction> get copyWith => _$RecentTransactionCopyWithImpl<RecentTransaction>(this as RecentTransaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecentTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.walletName, _this.walletName) || other.walletName == _this.walletName)&&(identical(other.toWalletName, _this.toWalletName) || other.toWalletName == _this.toWalletName));
}


@override
int get hashCode {
  final _this = this as RecentTransaction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.amount,_this.day,_this.title,_this.categoryName,_this.icon,_this.color,_this.walletName,_this.toWalletName);
}

@override
String toString() {
  final _this = this as RecentTransaction;
  return 'RecentTransaction(id: ${_this.id}, type: ${_this.type}, amount: ${_this.amount}, day: ${_this.day}, title: ${_this.title}, categoryName: ${_this.categoryName}, icon: ${_this.icon}, color: ${_this.color}, walletName: ${_this.walletName}, toWalletName: ${_this.toWalletName})';
}


}

/// @nodoc
abstract mixin class $RecentTransactionCopyWith<$Res>  {
  factory $RecentTransactionCopyWith(RecentTransaction value, $Res Function(RecentTransaction) _then) = _$RecentTransactionCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, int amount, RecentDay day, String? title, String? categoryName, String? icon, String? color, String? walletName, String? toWalletName
});


$RecentDayCopyWith<$Res> get day;

}
/// @nodoc
class _$RecentTransactionCopyWithImpl<$Res>
    implements $RecentTransactionCopyWith<$Res> {
  _$RecentTransactionCopyWithImpl(this._self, this._then);

  final RecentTransaction _self;
  final $Res Function(RecentTransaction) _then;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? day = null,Object? title = freezed,Object? categoryName = freezed,Object? icon = freezed,Object? color = freezed,Object? walletName = freezed,Object? toWalletName = freezed,}) {
  return _then(RecentTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as RecentDay,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,toWalletName: freezed == toWalletName ? _self.toWalletName : toWalletName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentDayCopyWith<$Res> get day {
  
  return $RecentDayCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecentTransaction].
extension RecentTransactionPatterns on RecentTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RecentTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  RecentDay day,  String? title,  String? categoryName,  String? icon,  String? color,  String? walletName,  String? toWalletName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.day,_that.title,_that.categoryName,_that.icon,_that.color,_that.walletName,_that.toWalletName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  RecentDay day,  String? title,  String? categoryName,  String? icon,  String? color,  String? walletName,  String? toWalletName)  $default,) {final _that = this;
switch (_that) {
case _RecentTransaction():
return $default(_that.id,_that.type,_that.amount,_that.day,_that.title,_that.categoryName,_that.icon,_that.color,_that.walletName,_that.toWalletName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  int amount,  RecentDay day,  String? title,  String? categoryName,  String? icon,  String? color,  String? walletName,  String? toWalletName)?  $default,) {final _that = this;
switch (_that) {
case _RecentTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.day,_that.title,_that.categoryName,_that.icon,_that.color,_that.walletName,_that.toWalletName);case _:
  return null;

}
}

}

/// @nodoc


class _RecentTransaction implements RecentTransaction {
  const _RecentTransaction({required this.id, required this.type, required this.amount, required this.day, this.title, this.categoryName, this.icon, this.color, this.walletName, this.toWalletName});
  

@override final  String id;
@override final  TransactionType type;
@override final  int amount;
@override final  RecentDay day;
/// The note, else the merchant, else the category name; null when there
/// is none, so the screen labels it by its [type].
@override final  String? title;
@override final  String? categoryName;
@override final  String? icon;
@override final  String? color;
@override final  String? walletName;
@override final  String? toWalletName;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentTransactionCopyWith<_RecentTransaction> get copyWith => __$RecentTransactionCopyWithImpl<_RecentTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.day, day) || other.day == day)&&(identical(other.title, title) || other.title == title)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.toWalletName, toWalletName) || other.toWalletName == toWalletName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,amount,day,title,categoryName,icon,color,walletName,toWalletName);
}

@override
String toString() {
    return 'RecentTransaction(id: $id, type: $type, amount: $amount, day: $day, title: $title, categoryName: $categoryName, icon: $icon, color: $color, walletName: $walletName, toWalletName: $toWalletName)';
}


}

/// @nodoc
abstract mixin class _$RecentTransactionCopyWith<$Res> implements $RecentTransactionCopyWith<$Res> {
  factory _$RecentTransactionCopyWith(_RecentTransaction value, $Res Function(_RecentTransaction) _then) = __$RecentTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, int amount, RecentDay day, String? title, String? categoryName, String? icon, String? color, String? walletName, String? toWalletName
});


@override $RecentDayCopyWith<$Res> get day;

}
/// @nodoc
class __$RecentTransactionCopyWithImpl<$Res>
    implements _$RecentTransactionCopyWith<$Res> {
  __$RecentTransactionCopyWithImpl(this._self, this._then);

  final _RecentTransaction _self;
  final $Res Function(_RecentTransaction) _then;

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? day = null,Object? title = freezed,Object? categoryName = freezed,Object? icon = freezed,Object? color = freezed,Object? walletName = freezed,Object? toWalletName = freezed,}) {
  return _then(_RecentTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as RecentDay,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,toWalletName: freezed == toWalletName ? _self.toWalletName : toWalletName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RecentTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentDayCopyWith<$Res> get day {
  
  return $RecentDayCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}

/// @nodoc
mixin _$RecentDay {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentDay);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RecentDay()';
}


}

/// @nodoc
class $RecentDayCopyWith<$Res>  {
$RecentDayCopyWith(RecentDay _, $Res Function(RecentDay) __);
}


/// Adds pattern-matching-related methods to [RecentDay].
extension RecentDayPatterns on RecentDay {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RecentToday value)?  today,TResult Function( RecentYesterday value)?  yesterday,TResult Function( RecentEarlier value)?  earlier,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RecentToday() when today != null:
return today(_that);case RecentYesterday() when yesterday != null:
return yesterday(_that);case RecentEarlier() when earlier != null:
return earlier(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RecentToday value)  today,required TResult Function( RecentYesterday value)  yesterday,required TResult Function( RecentEarlier value)  earlier,}){
final _that = this;
switch (_that) {
case RecentToday():
return today(_that);case RecentYesterday():
return yesterday(_that);case RecentEarlier():
return earlier(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RecentToday value)?  today,TResult? Function( RecentYesterday value)?  yesterday,TResult? Function( RecentEarlier value)?  earlier,}){
final _that = this;
switch (_that) {
case RecentToday() when today != null:
return today(_that);case RecentYesterday() when yesterday != null:
return yesterday(_that);case RecentEarlier() when earlier != null:
return earlier(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime time)?  today,TResult Function()?  yesterday,TResult Function( DateTime date)?  earlier,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RecentToday() when today != null:
return today(_that.time);case RecentYesterday() when yesterday != null:
return yesterday();case RecentEarlier() when earlier != null:
return earlier(_that.date);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime time)  today,required TResult Function()  yesterday,required TResult Function( DateTime date)  earlier,}) {final _that = this;
switch (_that) {
case RecentToday():
return today(_that.time);case RecentYesterday():
return yesterday();case RecentEarlier():
return earlier(_that.date);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime time)?  today,TResult? Function()?  yesterday,TResult? Function( DateTime date)?  earlier,}) {final _that = this;
switch (_that) {
case RecentToday() when today != null:
return today(_that.time);case RecentYesterday() when yesterday != null:
return yesterday();case RecentEarlier() when earlier != null:
return earlier(_that.date);case _:
  return null;

}
}

}

/// @nodoc


class RecentToday implements RecentDay {
  const RecentToday(this.time);
  

 final  DateTime time;

/// Create a copy of RecentDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentTodayCopyWith<RecentToday> get copyWith => _$RecentTodayCopyWithImpl<RecentToday>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentToday&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,time);
}

@override
String toString() {
    return 'RecentDay.today(time: $time)';
}


}

/// @nodoc
abstract mixin class $RecentTodayCopyWith<$Res> implements $RecentDayCopyWith<$Res> {
  factory $RecentTodayCopyWith(RecentToday value, $Res Function(RecentToday) _then) = _$RecentTodayCopyWithImpl;
@useResult
$Res call({
 DateTime time
});




}
/// @nodoc
class _$RecentTodayCopyWithImpl<$Res>
    implements $RecentTodayCopyWith<$Res> {
  _$RecentTodayCopyWithImpl(this._self, this._then);

  final RecentToday _self;
  final $Res Function(RecentToday) _then;

/// Create a copy of RecentDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? time = null,}) {
  return _then(RecentToday(
null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class RecentYesterday implements RecentDay {
  const RecentYesterday();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentYesterday);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RecentDay.yesterday()';
}


}




/// @nodoc


class RecentEarlier implements RecentDay {
  const RecentEarlier(this.date);
  

 final  DateTime date;

/// Create a copy of RecentDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentEarlierCopyWith<RecentEarlier> get copyWith => _$RecentEarlierCopyWithImpl<RecentEarlier>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentEarlier&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString() {
    return 'RecentDay.earlier(date: $date)';
}


}

/// @nodoc
abstract mixin class $RecentEarlierCopyWith<$Res> implements $RecentDayCopyWith<$Res> {
  factory $RecentEarlierCopyWith(RecentEarlier value, $Res Function(RecentEarlier) _then) = _$RecentEarlierCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$RecentEarlierCopyWithImpl<$Res>
    implements $RecentEarlierCopyWith<$Res> {
  _$RecentEarlierCopyWithImpl(this._self, this._then);

  final RecentEarlier _self;
  final $Res Function(RecentEarlier) _then;

/// Create a copy of RecentDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(RecentEarlier(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
