// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_search_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionSearchPage {

 List<Transaction> get items; String? get nextCursor;
/// Create a copy of TransactionSearchPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSearchPageCopyWith<TransactionSearchPage> get copyWith => _$TransactionSearchPageCopyWithImpl<TransactionSearchPage>(this as TransactionSearchPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionSearchPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSearchPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}


@override
int get hashCode {
  final _this = this as TransactionSearchPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as TransactionSearchPage;
  return 'TransactionSearchPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $TransactionSearchPageCopyWith<$Res>  {
  factory $TransactionSearchPageCopyWith(TransactionSearchPage value, $Res Function(TransactionSearchPage) _then) = _$TransactionSearchPageCopyWithImpl;
@useResult
$Res call({
 List<Transaction> items, String? nextCursor
});




}
/// @nodoc
class _$TransactionSearchPageCopyWithImpl<$Res>
    implements $TransactionSearchPageCopyWith<$Res> {
  _$TransactionSearchPageCopyWithImpl(this._self, this._then);

  final TransactionSearchPage _self;
  final $Res Function(TransactionSearchPage) _then;

/// Create a copy of TransactionSearchPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(TransactionSearchPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSearchPage].
extension TransactionSearchPagePatterns on TransactionSearchPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSearchPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSearchPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSearchPage value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSearchPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSearchPage value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSearchPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionSearchPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TransactionSearchPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TransactionSearchPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionSearchPage extends TransactionSearchPage {
  const _TransactionSearchPage({required  List<Transaction> items, this.nextCursor}): _items = items,super._();
  

 final  List<Transaction> _items;
@override List<Transaction> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of TransactionSearchPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSearchPageCopyWith<_TransactionSearchPage> get copyWith => __$TransactionSearchPageCopyWithImpl<_TransactionSearchPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSearchPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'TransactionSearchPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TransactionSearchPageCopyWith<$Res> implements $TransactionSearchPageCopyWith<$Res> {
  factory _$TransactionSearchPageCopyWith(_TransactionSearchPage value, $Res Function(_TransactionSearchPage) _then) = __$TransactionSearchPageCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> items, String? nextCursor
});




}
/// @nodoc
class __$TransactionSearchPageCopyWithImpl<$Res>
    implements _$TransactionSearchPageCopyWith<$Res> {
  __$TransactionSearchPageCopyWithImpl(this._self, this._then);

  final _TransactionSearchPage _self;
  final $Res Function(_TransactionSearchPage) _then;

/// Create a copy of TransactionSearchPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_TransactionSearchPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
