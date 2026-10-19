// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionListResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<TransactionData>? get data;@JsonKey(name: 'meta') TransactionListMeta? get meta;
/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionListResponseCopyWith<TransactionListResponse> get copyWith => _$TransactionListResponseCopyWithImpl<TransactionListResponse>(this as TransactionListResponse, _$identity);

  /// Serializes this TransactionListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionListResponse;
  return Object.hash(runtimeType,_this.success,_this.message,const DeepCollectionEquality().hash(_this.data),_this.meta);
}

@override
String toString() {
  final _this = this as TransactionListResponse;
  return 'TransactionListResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $TransactionListResponseCopyWith<$Res>  {
  factory $TransactionListResponseCopyWith(TransactionListResponse value, $Res Function(TransactionListResponse) _then) = _$TransactionListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<TransactionData>? data,@JsonKey(name: 'meta') TransactionListMeta? meta
});


$TransactionListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$TransactionListResponseCopyWithImpl<$Res>
    implements $TransactionListResponseCopyWith<$Res> {
  _$TransactionListResponseCopyWithImpl(this._self, this._then);

  final TransactionListResponse _self;
  final $Res Function(TransactionListResponse) _then;

/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(TransactionListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<TransactionData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as TransactionListMeta?,
  ));
}
/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $TransactionListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionListResponse].
extension TransactionListResponsePatterns on TransactionListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionListResponse value)  $default,){
final _that = this;
switch (_that) {
case _TransactionListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<TransactionData>? data, @JsonKey(name: 'meta')  TransactionListMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<TransactionData>? data, @JsonKey(name: 'meta')  TransactionListMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _TransactionListResponse():
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<TransactionData>? data, @JsonKey(name: 'meta')  TransactionListMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _TransactionListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionListResponse implements TransactionListResponse {
  const _TransactionListResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data')  List<TransactionData>? data, @JsonKey(name: 'meta') this.meta}): _data = data;
  factory _TransactionListResponse.fromJson(Map<String, dynamic> json) => _$TransactionListResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<TransactionData>? _data;
@override@JsonKey(name: 'data') List<TransactionData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'meta') final  TransactionListMeta? meta;

/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionListResponseCopyWith<_TransactionListResponse> get copyWith => __$TransactionListResponseCopyWithImpl<_TransactionListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);
}

@override
String toString() {
    return 'TransactionListResponse(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$TransactionListResponseCopyWith<$Res> implements $TransactionListResponseCopyWith<$Res> {
  factory _$TransactionListResponseCopyWith(_TransactionListResponse value, $Res Function(_TransactionListResponse) _then) = __$TransactionListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<TransactionData>? data,@JsonKey(name: 'meta') TransactionListMeta? meta
});


@override $TransactionListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$TransactionListResponseCopyWithImpl<$Res>
    implements _$TransactionListResponseCopyWith<$Res> {
  __$TransactionListResponseCopyWithImpl(this._self, this._then);

  final _TransactionListResponse _self;
  final $Res Function(_TransactionListResponse) _then;

/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(_TransactionListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<TransactionData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as TransactionListMeta?,
  ));
}

/// Create a copy of TransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $TransactionListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$TransactionListMeta {

@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool? get hasMore;@JsonKey(name: 'limit') int? get limit;
/// Create a copy of TransactionListMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionListMetaCopyWith<TransactionListMeta> get copyWith => _$TransactionListMetaCopyWithImpl<TransactionListMeta>(this as TransactionListMeta, _$identity);

  /// Serializes this TransactionListMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionListMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionListMeta&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionListMeta;
  return Object.hash(runtimeType,_this.nextCursor,_this.hasMore,_this.limit);
}

@override
String toString() {
  final _this = this as TransactionListMeta;
  return 'TransactionListMeta(nextCursor: ${_this.nextCursor}, hasMore: ${_this.hasMore}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $TransactionListMetaCopyWith<$Res>  {
  factory $TransactionListMetaCopyWith(TransactionListMeta value, $Res Function(TransactionListMeta) _then) = _$TransactionListMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool? hasMore,@JsonKey(name: 'limit') int? limit
});




}
/// @nodoc
class _$TransactionListMetaCopyWithImpl<$Res>
    implements $TransactionListMetaCopyWith<$Res> {
  _$TransactionListMetaCopyWithImpl(this._self, this._then);

  final TransactionListMeta _self;
  final $Res Function(TransactionListMeta) _then;

/// Create a copy of TransactionListMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextCursor = freezed,Object? hasMore = freezed,Object? limit = freezed,}) {
  return _then(TransactionListMeta(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionListMeta].
extension TransactionListMetaPatterns on TransactionListMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionListMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionListMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionListMeta value)  $default,){
final _that = this;
switch (_that) {
case _TransactionListMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionListMeta value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionListMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool? hasMore, @JsonKey(name: 'limit')  int? limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionListMeta() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool? hasMore, @JsonKey(name: 'limit')  int? limit)  $default,) {final _that = this;
switch (_that) {
case _TransactionListMeta():
return $default(_that.nextCursor,_that.hasMore,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool? hasMore, @JsonKey(name: 'limit')  int? limit)?  $default,) {final _that = this;
switch (_that) {
case _TransactionListMeta() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionListMeta implements TransactionListMeta {
  const _TransactionListMeta({@JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') this.hasMore, @JsonKey(name: 'limit') this.limit});
  factory _TransactionListMeta.fromJson(Map<String, dynamic> json) => _$TransactionListMetaFromJson(json);

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool? hasMore;
@override@JsonKey(name: 'limit') final  int? limit;

/// Create a copy of TransactionListMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionListMetaCopyWith<_TransactionListMeta> get copyWith => __$TransactionListMetaCopyWithImpl<_TransactionListMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionListMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionListMeta&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nextCursor,hasMore,limit);
}

@override
String toString() {
    return 'TransactionListMeta(nextCursor: $nextCursor, hasMore: $hasMore, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$TransactionListMetaCopyWith<$Res> implements $TransactionListMetaCopyWith<$Res> {
  factory _$TransactionListMetaCopyWith(_TransactionListMeta value, $Res Function(_TransactionListMeta) _then) = __$TransactionListMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool? hasMore,@JsonKey(name: 'limit') int? limit
});




}
/// @nodoc
class __$TransactionListMetaCopyWithImpl<$Res>
    implements _$TransactionListMetaCopyWith<$Res> {
  __$TransactionListMetaCopyWithImpl(this._self, this._then);

  final _TransactionListMeta _self;
  final $Res Function(_TransactionListMeta) _then;

/// Create a copy of TransactionListMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextCursor = freezed,Object? hasMore = freezed,Object? limit = freezed,}) {
  return _then(_TransactionListMeta(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
