// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletDetailEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletDetailEvent()';
}


}

/// @nodoc
class $WalletDetailEventCopyWith<$Res>  {
$WalletDetailEventCopyWith(WalletDetailEvent _, $Res Function(WalletDetailEvent) __);
}


/// Adds pattern-matching-related methods to [WalletDetailEvent].
extension WalletDetailEventPatterns on WalletDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Refreshed value)?  refreshed,TResult Function( _ArchiveRequested value)?  archiveRequested,TResult Function( _SetDefaultRequested value)?  setDefaultRequested,TResult Function( _WalletChanged value)?  walletChanged,TResult Function( _OutflowsChanged value)?  outflowsChanged,TResult Function( _TransactionsChanged value)?  transactionsChanged,TResult Function( _CategoriesChanged value)?  categoriesChanged,TResult Function( _AllWalletsChanged value)?  allWalletsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested(_that);case _SetDefaultRequested() when setDefaultRequested != null:
return setDefaultRequested(_that);case _WalletChanged() when walletChanged != null:
return walletChanged(_that);case _OutflowsChanged() when outflowsChanged != null:
return outflowsChanged(_that);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Refreshed value)  refreshed,required TResult Function( _ArchiveRequested value)  archiveRequested,required TResult Function( _SetDefaultRequested value)  setDefaultRequested,required TResult Function( _WalletChanged value)  walletChanged,required TResult Function( _OutflowsChanged value)  outflowsChanged,required TResult Function( _TransactionsChanged value)  transactionsChanged,required TResult Function( _CategoriesChanged value)  categoriesChanged,required TResult Function( _AllWalletsChanged value)  allWalletsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Refreshed():
return refreshed(_that);case _ArchiveRequested():
return archiveRequested(_that);case _SetDefaultRequested():
return setDefaultRequested(_that);case _WalletChanged():
return walletChanged(_that);case _OutflowsChanged():
return outflowsChanged(_that);case _TransactionsChanged():
return transactionsChanged(_that);case _CategoriesChanged():
return categoriesChanged(_that);case _AllWalletsChanged():
return allWalletsChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Refreshed value)?  refreshed,TResult? Function( _ArchiveRequested value)?  archiveRequested,TResult? Function( _SetDefaultRequested value)?  setDefaultRequested,TResult? Function( _WalletChanged value)?  walletChanged,TResult? Function( _OutflowsChanged value)?  outflowsChanged,TResult? Function( _TransactionsChanged value)?  transactionsChanged,TResult? Function( _CategoriesChanged value)?  categoriesChanged,TResult? Function( _AllWalletsChanged value)?  allWalletsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested(_that);case _SetDefaultRequested() when setDefaultRequested != null:
return setDefaultRequested(_that);case _WalletChanged() when walletChanged != null:
return walletChanged(_that);case _OutflowsChanged() when outflowsChanged != null:
return outflowsChanged(_that);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshed,TResult Function()?  archiveRequested,TResult Function()?  setDefaultRequested,TResult Function( Wallet? wallet)?  walletChanged,TResult Function( Map<DateTime, int> outflows)?  outflowsChanged,TResult Function( List<Transaction> transactions)?  transactionsChanged,TResult Function( List<Category> categories)?  categoriesChanged,TResult Function( List<Wallet> wallets)?  allWalletsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _ArchiveRequested() when archiveRequested != null:
return archiveRequested();case _SetDefaultRequested() when setDefaultRequested != null:
return setDefaultRequested();case _WalletChanged() when walletChanged != null:
return walletChanged(_that.wallet);case _OutflowsChanged() when outflowsChanged != null:
return outflowsChanged(_that.outflows);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that.transactions);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshed,required TResult Function()  archiveRequested,required TResult Function()  setDefaultRequested,required TResult Function( Wallet? wallet)  walletChanged,required TResult Function( Map<DateTime, int> outflows)  outflowsChanged,required TResult Function( List<Transaction> transactions)  transactionsChanged,required TResult Function( List<Category> categories)  categoriesChanged,required TResult Function( List<Wallet> wallets)  allWalletsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Refreshed():
return refreshed();case _ArchiveRequested():
return archiveRequested();case _SetDefaultRequested():
return setDefaultRequested();case _WalletChanged():
return walletChanged(_that.wallet);case _OutflowsChanged():
return outflowsChanged(_that.outflows);case _TransactionsChanged():
return transactionsChanged(_that.transactions);case _CategoriesChanged():
return categoriesChanged(_that.categories);case _AllWalletsChanged():
return allWalletsChanged(_that.wallets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshed,TResult? Function()?  archiveRequested,TResult? Function()?  setDefaultRequested,TResult? Function( Wallet? wallet)?  walletChanged,TResult? Function( Map<DateTime, int> outflows)?  outflowsChanged,TResult? Function( List<Transaction> transactions)?  transactionsChanged,TResult? Function( List<Category> categories)?  categoriesChanged,TResult? Function( List<Wallet> wallets)?  allWalletsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _ArchiveRequested() when archiveRequested != null:
return archiveRequested();case _SetDefaultRequested() when setDefaultRequested != null:
return setDefaultRequested();case _WalletChanged() when walletChanged != null:
return walletChanged(_that.wallet);case _OutflowsChanged() when outflowsChanged != null:
return outflowsChanged(_that.outflows);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that.transactions);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements WalletDetailEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletDetailEvent.started()';
}


}




/// @nodoc


class _Refreshed implements WalletDetailEvent {
  const _Refreshed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletDetailEvent.refreshed()';
}


}




/// @nodoc


class _ArchiveRequested implements WalletDetailEvent {
  const _ArchiveRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletDetailEvent.archiveRequested()';
}


}




/// @nodoc


class _SetDefaultRequested implements WalletDetailEvent {
  const _SetDefaultRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetDefaultRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletDetailEvent.setDefaultRequested()';
}


}




/// @nodoc


class _WalletChanged implements WalletDetailEvent {
  const _WalletChanged(this.wallet);
  

 final  Wallet? wallet;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletChangedCopyWith<_WalletChanged> get copyWith => __$WalletChangedCopyWithImpl<_WalletChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletChanged&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode {
    return Object.hash(runtimeType,wallet);
}

@override
String toString() {
    return 'WalletDetailEvent.walletChanged(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class _$WalletChangedCopyWith<$Res> implements $WalletDetailEventCopyWith<$Res> {
  factory _$WalletChangedCopyWith(_WalletChanged value, $Res Function(_WalletChanged) _then) = __$WalletChangedCopyWithImpl;
@useResult
$Res call({
 Wallet? wallet
});


$WalletCopyWith<$Res>? get wallet;

}
/// @nodoc
class __$WalletChangedCopyWithImpl<$Res>
    implements _$WalletChangedCopyWith<$Res> {
  __$WalletChangedCopyWithImpl(this._self, this._then);

  final _WalletChanged _self;
  final $Res Function(_WalletChanged) _then;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallet = freezed,}) {
  return _then(_WalletChanged(
freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet?,
  ));
}

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

/// @nodoc


class _OutflowsChanged implements WalletDetailEvent {
  const _OutflowsChanged( Map<DateTime, int> outflows): _outflows = outflows;
  

 final  Map<DateTime, int> _outflows;
 Map<DateTime, int> get outflows {
  if (_outflows is EqualUnmodifiableMapView) return _outflows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_outflows);
}


/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutflowsChangedCopyWith<_OutflowsChanged> get copyWith => __$OutflowsChangedCopyWithImpl<_OutflowsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutflowsChanged&&const DeepCollectionEquality().equals(other.outflows, _outflows));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_outflows));
}

@override
String toString() {
    return 'WalletDetailEvent.outflowsChanged(outflows: $outflows)';
}


}

/// @nodoc
abstract mixin class _$OutflowsChangedCopyWith<$Res> implements $WalletDetailEventCopyWith<$Res> {
  factory _$OutflowsChangedCopyWith(_OutflowsChanged value, $Res Function(_OutflowsChanged) _then) = __$OutflowsChangedCopyWithImpl;
@useResult
$Res call({
 Map<DateTime, int> outflows
});




}
/// @nodoc
class __$OutflowsChangedCopyWithImpl<$Res>
    implements _$OutflowsChangedCopyWith<$Res> {
  __$OutflowsChangedCopyWithImpl(this._self, this._then);

  final _OutflowsChanged _self;
  final $Res Function(_OutflowsChanged) _then;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? outflows = null,}) {
  return _then(_OutflowsChanged(
null == outflows ? _self._outflows : outflows // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,
  ));
}


}

/// @nodoc


class _TransactionsChanged implements WalletDetailEvent {
  const _TransactionsChanged( List<Transaction> transactions): _transactions = transactions;
  

 final  List<Transaction> _transactions;
 List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsChangedCopyWith<_TransactionsChanged> get copyWith => __$TransactionsChangedCopyWithImpl<_TransactionsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsChanged&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'WalletDetailEvent.transactionsChanged(transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$TransactionsChangedCopyWith<$Res> implements $WalletDetailEventCopyWith<$Res> {
  factory _$TransactionsChangedCopyWith(_TransactionsChanged value, $Res Function(_TransactionsChanged) _then) = __$TransactionsChangedCopyWithImpl;
@useResult
$Res call({
 List<Transaction> transactions
});




}
/// @nodoc
class __$TransactionsChangedCopyWithImpl<$Res>
    implements _$TransactionsChangedCopyWith<$Res> {
  __$TransactionsChangedCopyWithImpl(this._self, this._then);

  final _TransactionsChanged _self;
  final $Res Function(_TransactionsChanged) _then;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,}) {
  return _then(_TransactionsChanged(
null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}


}

/// @nodoc


class _CategoriesChanged implements WalletDetailEvent {
  const _CategoriesChanged( List<Category> categories): _categories = categories;
  

 final  List<Category> _categories;
 List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesChangedCopyWith<_CategoriesChanged> get copyWith => __$CategoriesChangedCopyWithImpl<_CategoriesChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesChanged&&const DeepCollectionEquality().equals(other.categories, _categories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'WalletDetailEvent.categoriesChanged(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoriesChangedCopyWith<$Res> implements $WalletDetailEventCopyWith<$Res> {
  factory _$CategoriesChangedCopyWith(_CategoriesChanged value, $Res Function(_CategoriesChanged) _then) = __$CategoriesChangedCopyWithImpl;
@useResult
$Res call({
 List<Category> categories
});




}
/// @nodoc
class __$CategoriesChangedCopyWithImpl<$Res>
    implements _$CategoriesChangedCopyWith<$Res> {
  __$CategoriesChangedCopyWithImpl(this._self, this._then);

  final _CategoriesChanged _self;
  final $Res Function(_CategoriesChanged) _then;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoriesChanged(
null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,
  ));
}


}

/// @nodoc


class _AllWalletsChanged implements WalletDetailEvent {
  const _AllWalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllWalletsChangedCopyWith<_AllWalletsChanged> get copyWith => __$AllWalletsChangedCopyWithImpl<_AllWalletsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllWalletsChanged&&const DeepCollectionEquality().equals(other.wallets, _wallets));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_wallets));
}

@override
String toString() {
    return 'WalletDetailEvent.allWalletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$AllWalletsChangedCopyWith<$Res> implements $WalletDetailEventCopyWith<$Res> {
  factory _$AllWalletsChangedCopyWith(_AllWalletsChanged value, $Res Function(_AllWalletsChanged) _then) = __$AllWalletsChangedCopyWithImpl;
@useResult
$Res call({
 List<Wallet> wallets
});




}
/// @nodoc
class __$AllWalletsChangedCopyWithImpl<$Res>
    implements _$AllWalletsChangedCopyWith<$Res> {
  __$AllWalletsChangedCopyWithImpl(this._self, this._then);

  final _AllWalletsChanged _self;
  final $Res Function(_AllWalletsChanged) _then;

/// Create a copy of WalletDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_AllWalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc
mixin _$WalletDetailState {

 String get id;/// The user's current date.
 DateTime get today;/// The first of the month the chart and the list show.
 DateTime get month;/// [UiStatus.loading] while nothing is cached, [UiStatus.failure] when
/// that first load failed, otherwise [UiStatus.success].
 UiStatus get status; Wallet? get wallet;/// Each day's money out of the wallet this month.
 Map<DateTime, int> get outflows;/// This month's transactions in or out of the wallet, newest first.
 List<Transaction> get transactions;/// Every cached category and wallet by id, for the rows' names.
 Map<String, Category> get categories; Map<String, Wallet> get wallets;/// The server answered once.
 bool get loaded; bool get isRefreshing; bool get isArchiving; bool get isSettingDefault;/// The server no longer has the wallet; the screen closes.
 bool get isGone;/// Set once the wallet is archived; the screen closes.
 String? get archivedName;/// Why the first load failed, with nothing cached.
 WalletFailure? get loadFailure;/// Why a refresh or an action failed; shown once as a snackbar.
 WalletFailure? get actionFailure;
/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDetailStateCopyWith<WalletDetailState> get copyWith => _$WalletDetailStateCopyWithImpl<WalletDetailState>(this as WalletDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WalletDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDetailState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.wallet, _this.wallet) || other.wallet == _this.wallet)&&const DeepCollectionEquality().equals(other.outflows, _this.outflows)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.isArchiving, _this.isArchiving) || other.isArchiving == _this.isArchiving)&&(identical(other.isSettingDefault, _this.isSettingDefault) || other.isSettingDefault == _this.isSettingDefault)&&(identical(other.isGone, _this.isGone) || other.isGone == _this.isGone)&&(identical(other.archivedName, _this.archivedName) || other.archivedName == _this.archivedName)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as WalletDetailState;
  return Object.hash(runtimeType,_this.id,_this.today,_this.month,_this.status,_this.wallet,const DeepCollectionEquality().hash(_this.outflows),const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.wallets),_this.loaded,_this.isRefreshing,_this.isArchiving,_this.isSettingDefault,_this.isGone,_this.archivedName,_this.loadFailure,_this.actionFailure);
}

@override
String toString() {
  final _this = this as WalletDetailState;
  return 'WalletDetailState(id: ${_this.id}, today: ${_this.today}, month: ${_this.month}, status: ${_this.status}, wallet: ${_this.wallet}, outflows: ${_this.outflows}, transactions: ${_this.transactions}, categories: ${_this.categories}, wallets: ${_this.wallets}, loaded: ${_this.loaded}, isRefreshing: ${_this.isRefreshing}, isArchiving: ${_this.isArchiving}, isSettingDefault: ${_this.isSettingDefault}, isGone: ${_this.isGone}, archivedName: ${_this.archivedName}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $WalletDetailStateCopyWith<$Res>  {
  factory $WalletDetailStateCopyWith(WalletDetailState value, $Res Function(WalletDetailState) _then) = _$WalletDetailStateCopyWithImpl;
@useResult
$Res call({
 String id, DateTime today, DateTime month, UiStatus status, Wallet? wallet, Map<DateTime, int> outflows, List<Transaction> transactions, Map<String, Category> categories, Map<String, Wallet> wallets, bool loaded, bool isRefreshing, bool isArchiving, bool isSettingDefault, bool isGone, String? archivedName, WalletFailure? loadFailure, WalletFailure? actionFailure
});


$WalletCopyWith<$Res>? get wallet;

}
/// @nodoc
class _$WalletDetailStateCopyWithImpl<$Res>
    implements $WalletDetailStateCopyWith<$Res> {
  _$WalletDetailStateCopyWithImpl(this._self, this._then);

  final WalletDetailState _self;
  final $Res Function(WalletDetailState) _then;

/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? today = null,Object? month = null,Object? status = null,Object? wallet = freezed,Object? outflows = null,Object? transactions = null,Object? categories = null,Object? wallets = null,Object? loaded = null,Object? isRefreshing = null,Object? isArchiving = null,Object? isSettingDefault = null,Object? isGone = null,Object? archivedName = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(WalletDetailState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet?,outflows: null == outflows ? _self.outflows : outflows // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, Category>,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as Map<String, Wallet>,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isArchiving: null == isArchiving ? _self.isArchiving : isArchiving // ignore: cast_nullable_to_non_nullable
as bool,isSettingDefault: null == isSettingDefault ? _self.isSettingDefault : isSettingDefault // ignore: cast_nullable_to_non_nullable
as bool,isGone: null == isGone ? _self.isGone : isGone // ignore: cast_nullable_to_non_nullable
as bool,archivedName: freezed == archivedName ? _self.archivedName : archivedName // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}
/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletDetailState].
extension WalletDetailStatePatterns on WalletDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletDetailState value)  $default,){
final _that = this;
switch (_that) {
case _WalletDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime today,  DateTime month,  UiStatus status,  Wallet? wallet,  Map<DateTime, int> outflows,  List<Transaction> transactions,  Map<String, Category> categories,  Map<String, Wallet> wallets,  bool loaded,  bool isRefreshing,  bool isArchiving,  bool isSettingDefault,  bool isGone,  String? archivedName,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletDetailState() when $default != null:
return $default(_that.id,_that.today,_that.month,_that.status,_that.wallet,_that.outflows,_that.transactions,_that.categories,_that.wallets,_that.loaded,_that.isRefreshing,_that.isArchiving,_that.isSettingDefault,_that.isGone,_that.archivedName,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime today,  DateTime month,  UiStatus status,  Wallet? wallet,  Map<DateTime, int> outflows,  List<Transaction> transactions,  Map<String, Category> categories,  Map<String, Wallet> wallets,  bool loaded,  bool isRefreshing,  bool isArchiving,  bool isSettingDefault,  bool isGone,  String? archivedName,  WalletFailure? loadFailure,  WalletFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _WalletDetailState():
return $default(_that.id,_that.today,_that.month,_that.status,_that.wallet,_that.outflows,_that.transactions,_that.categories,_that.wallets,_that.loaded,_that.isRefreshing,_that.isArchiving,_that.isSettingDefault,_that.isGone,_that.archivedName,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime today,  DateTime month,  UiStatus status,  Wallet? wallet,  Map<DateTime, int> outflows,  List<Transaction> transactions,  Map<String, Category> categories,  Map<String, Wallet> wallets,  bool loaded,  bool isRefreshing,  bool isArchiving,  bool isSettingDefault,  bool isGone,  String? archivedName,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _WalletDetailState() when $default != null:
return $default(_that.id,_that.today,_that.month,_that.status,_that.wallet,_that.outflows,_that.transactions,_that.categories,_that.wallets,_that.loaded,_that.isRefreshing,_that.isArchiving,_that.isSettingDefault,_that.isGone,_that.archivedName,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _WalletDetailState implements WalletDetailState {
  const _WalletDetailState({required this.id, required this.today, required this.month, this.status = UiStatus.initial, this.wallet,  Map<DateTime, int> outflows = const {},  List<Transaction> transactions = const [],  Map<String, Category> categories = const {},  Map<String, Wallet> wallets = const {}, this.loaded = false, this.isRefreshing = false, this.isArchiving = false, this.isSettingDefault = false, this.isGone = false, this.archivedName, this.loadFailure, this.actionFailure}): _outflows = outflows,_transactions = transactions,_categories = categories,_wallets = wallets;
  

@override final  String id;
/// The user's current date.
@override final  DateTime today;
/// The first of the month the chart and the list show.
@override final  DateTime month;
/// [UiStatus.loading] while nothing is cached, [UiStatus.failure] when
/// that first load failed, otherwise [UiStatus.success].
@override@JsonKey() final  UiStatus status;
@override final  Wallet? wallet;
/// Each day's money out of the wallet this month.
 final  Map<DateTime, int> _outflows;
/// Each day's money out of the wallet this month.
@override@JsonKey() Map<DateTime, int> get outflows {
  if (_outflows is EqualUnmodifiableMapView) return _outflows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_outflows);
}

/// This month's transactions in or out of the wallet, newest first.
 final  List<Transaction> _transactions;
/// This month's transactions in or out of the wallet, newest first.
@override@JsonKey() List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

/// Every cached category and wallet by id, for the rows' names.
 final  Map<String, Category> _categories;
/// Every cached category and wallet by id, for the rows' names.
@override@JsonKey() Map<String, Category> get categories {
  if (_categories is EqualUnmodifiableMapView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categories);
}

 final  Map<String, Wallet> _wallets;
@override@JsonKey() Map<String, Wallet> get wallets {
  if (_wallets is EqualUnmodifiableMapView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_wallets);
}

/// The server answered once.
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool isArchiving;
@override@JsonKey() final  bool isSettingDefault;
/// The server no longer has the wallet; the screen closes.
@override@JsonKey() final  bool isGone;
/// Set once the wallet is archived; the screen closes.
@override final  String? archivedName;
/// Why the first load failed, with nothing cached.
@override final  WalletFailure? loadFailure;
/// Why a refresh or an action failed; shown once as a snackbar.
@override final  WalletFailure? actionFailure;

/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDetailStateCopyWith<_WalletDetailState> get copyWith => __$WalletDetailStateCopyWithImpl<_WalletDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDetailState&&(identical(other.id, id) || other.id == id)&&(identical(other.today, today) || other.today == today)&&(identical(other.month, month) || other.month == month)&&(identical(other.status, status) || other.status == status)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&const DeepCollectionEquality().equals(other.outflows, _outflows)&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.isArchiving, isArchiving) || other.isArchiving == isArchiving)&&(identical(other.isSettingDefault, isSettingDefault) || other.isSettingDefault == isSettingDefault)&&(identical(other.isGone, isGone) || other.isGone == isGone)&&(identical(other.archivedName, archivedName) || other.archivedName == archivedName)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,today,month,status,wallet,const DeepCollectionEquality().hash(_outflows),const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_wallets),loaded,isRefreshing,isArchiving,isSettingDefault,isGone,archivedName,loadFailure,actionFailure);
}

@override
String toString() {
    return 'WalletDetailState(id: $id, today: $today, month: $month, status: $status, wallet: $wallet, outflows: $outflows, transactions: $transactions, categories: $categories, wallets: $wallets, loaded: $loaded, isRefreshing: $isRefreshing, isArchiving: $isArchiving, isSettingDefault: $isSettingDefault, isGone: $isGone, archivedName: $archivedName, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$WalletDetailStateCopyWith<$Res> implements $WalletDetailStateCopyWith<$Res> {
  factory _$WalletDetailStateCopyWith(_WalletDetailState value, $Res Function(_WalletDetailState) _then) = __$WalletDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime today, DateTime month, UiStatus status, Wallet? wallet, Map<DateTime, int> outflows, List<Transaction> transactions, Map<String, Category> categories, Map<String, Wallet> wallets, bool loaded, bool isRefreshing, bool isArchiving, bool isSettingDefault, bool isGone, String? archivedName, WalletFailure? loadFailure, WalletFailure? actionFailure
});


@override $WalletCopyWith<$Res>? get wallet;

}
/// @nodoc
class __$WalletDetailStateCopyWithImpl<$Res>
    implements _$WalletDetailStateCopyWith<$Res> {
  __$WalletDetailStateCopyWithImpl(this._self, this._then);

  final _WalletDetailState _self;
  final $Res Function(_WalletDetailState) _then;

/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? today = null,Object? month = null,Object? status = null,Object? wallet = freezed,Object? outflows = null,Object? transactions = null,Object? categories = null,Object? wallets = null,Object? loaded = null,Object? isRefreshing = null,Object? isArchiving = null,Object? isSettingDefault = null,Object? isGone = null,Object? archivedName = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_WalletDetailState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet?,outflows: null == outflows ? _self._outflows : outflows // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, Category>,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as Map<String, Wallet>,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isArchiving: null == isArchiving ? _self.isArchiving : isArchiving // ignore: cast_nullable_to_non_nullable
as bool,isSettingDefault: null == isSettingDefault ? _self.isSettingDefault : isSettingDefault // ignore: cast_nullable_to_non_nullable
as bool,isGone: null == isGone ? _self.isGone : isGone // ignore: cast_nullable_to_non_nullable
as bool,archivedName: freezed == archivedName ? _self.archivedName : archivedName // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}

/// Create a copy of WalletDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
