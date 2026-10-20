// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_lookups.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionLookups {

 Map<String, Category> get categories; Map<String, Wallet> get wallets;
/// Create a copy of TransactionLookups
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<TransactionLookups> get copyWith => _$TransactionLookupsCopyWithImpl<TransactionLookups>(this as TransactionLookups, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionLookups;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionLookups&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets));
}


@override
int get hashCode {
  final _this = this as TransactionLookups;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.wallets));
}

@override
String toString() {
  final _this = this as TransactionLookups;
  return 'TransactionLookups(categories: ${_this.categories}, wallets: ${_this.wallets})';
}


}

/// @nodoc
abstract mixin class $TransactionLookupsCopyWith<$Res>  {
  factory $TransactionLookupsCopyWith(TransactionLookups value, $Res Function(TransactionLookups) _then) = _$TransactionLookupsCopyWithImpl;
@useResult
$Res call({
 Map<String, Category> categories, Map<String, Wallet> wallets
});




}
/// @nodoc
class _$TransactionLookupsCopyWithImpl<$Res>
    implements $TransactionLookupsCopyWith<$Res> {
  _$TransactionLookupsCopyWithImpl(this._self, this._then);

  final TransactionLookups _self;
  final $Res Function(TransactionLookups) _then;

/// Create a copy of TransactionLookups
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? wallets = null,}) {
  return _then(TransactionLookups(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, Category>,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as Map<String, Wallet>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionLookups].
extension TransactionLookupsPatterns on TransactionLookups {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionLookups value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionLookups() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionLookups value)  $default,){
final _that = this;
switch (_that) {
case _TransactionLookups():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionLookups value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionLookups() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Category> categories,  Map<String, Wallet> wallets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionLookups() when $default != null:
return $default(_that.categories,_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Category> categories,  Map<String, Wallet> wallets)  $default,) {final _that = this;
switch (_that) {
case _TransactionLookups():
return $default(_that.categories,_that.wallets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Category> categories,  Map<String, Wallet> wallets)?  $default,) {final _that = this;
switch (_that) {
case _TransactionLookups() when $default != null:
return $default(_that.categories,_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionLookups extends TransactionLookups {
  const _TransactionLookups({ Map<String, Category> categories = const {},  Map<String, Wallet> wallets = const {}}): _categories = categories,_wallets = wallets,super._();
  

 final  Map<String, Category> _categories;
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


/// Create a copy of TransactionLookups
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionLookupsCopyWith<_TransactionLookups> get copyWith => __$TransactionLookupsCopyWithImpl<_TransactionLookups>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionLookups&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.wallets, _wallets));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_wallets));
}

@override
String toString() {
    return 'TransactionLookups(categories: $categories, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$TransactionLookupsCopyWith<$Res> implements $TransactionLookupsCopyWith<$Res> {
  factory _$TransactionLookupsCopyWith(_TransactionLookups value, $Res Function(_TransactionLookups) _then) = __$TransactionLookupsCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Category> categories, Map<String, Wallet> wallets
});




}
/// @nodoc
class __$TransactionLookupsCopyWithImpl<$Res>
    implements _$TransactionLookupsCopyWith<$Res> {
  __$TransactionLookupsCopyWithImpl(this._self, this._then);

  final _TransactionLookups _self;
  final $Res Function(_TransactionLookups) _then;

/// Create a copy of TransactionLookups
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? wallets = null,}) {
  return _then(_TransactionLookups(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, Category>,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as Map<String, Wallet>,
  ));
}


}

// dart format on
