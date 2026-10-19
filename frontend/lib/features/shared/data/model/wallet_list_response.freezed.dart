// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletListResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<WalletData>? get data;@JsonKey(name: 'meta') WalletListMeta? get meta;
/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletListResponseCopyWith<WalletListResponse> get copyWith => _$WalletListResponseCopyWithImpl<WalletListResponse>(this as WalletListResponse, _$identity);

  /// Serializes this WalletListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WalletListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WalletListResponse;
  return Object.hash(runtimeType,_this.success,_this.message,const DeepCollectionEquality().hash(_this.data),_this.meta);
}

@override
String toString() {
  final _this = this as WalletListResponse;
  return 'WalletListResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $WalletListResponseCopyWith<$Res>  {
  factory $WalletListResponseCopyWith(WalletListResponse value, $Res Function(WalletListResponse) _then) = _$WalletListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<WalletData>? data,@JsonKey(name: 'meta') WalletListMeta? meta
});


$WalletListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$WalletListResponseCopyWithImpl<$Res>
    implements $WalletListResponseCopyWith<$Res> {
  _$WalletListResponseCopyWithImpl(this._self, this._then);

  final WalletListResponse _self;
  final $Res Function(WalletListResponse) _then;

/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(WalletListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<WalletData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as WalletListMeta?,
  ));
}
/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $WalletListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletListResponse].
extension WalletListResponsePatterns on WalletListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletListResponse value)  $default,){
final _that = this;
switch (_that) {
case _WalletListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WalletListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<WalletData>? data, @JsonKey(name: 'meta')  WalletListMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<WalletData>? data, @JsonKey(name: 'meta')  WalletListMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _WalletListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<WalletData>? data, @JsonKey(name: 'meta')  WalletListMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _WalletListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletListResponse implements WalletListResponse {
  const _WalletListResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data')  List<WalletData>? data, @JsonKey(name: 'meta') this.meta}): _data = data;
  factory _WalletListResponse.fromJson(Map<String, dynamic> json) => _$WalletListResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<WalletData>? _data;
@override@JsonKey(name: 'data') List<WalletData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'meta') final  WalletListMeta? meta;

/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletListResponseCopyWith<_WalletListResponse> get copyWith => __$WalletListResponseCopyWithImpl<_WalletListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);
}

@override
String toString() {
    return 'WalletListResponse(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$WalletListResponseCopyWith<$Res> implements $WalletListResponseCopyWith<$Res> {
  factory _$WalletListResponseCopyWith(_WalletListResponse value, $Res Function(_WalletListResponse) _then) = __$WalletListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<WalletData>? data,@JsonKey(name: 'meta') WalletListMeta? meta
});


@override $WalletListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$WalletListResponseCopyWithImpl<$Res>
    implements _$WalletListResponseCopyWith<$Res> {
  __$WalletListResponseCopyWithImpl(this._self, this._then);

  final _WalletListResponse _self;
  final $Res Function(_WalletListResponse) _then;

/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(_WalletListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<WalletData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as WalletListMeta?,
  ));
}

/// Create a copy of WalletListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $WalletListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$WalletListMeta {

@JsonKey(name: 'total_balance') int? get totalBalance;
/// Create a copy of WalletListMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletListMetaCopyWith<WalletListMeta> get copyWith => _$WalletListMetaCopyWithImpl<WalletListMeta>(this as WalletListMeta, _$identity);

  /// Serializes this WalletListMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WalletListMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletListMeta&&(identical(other.totalBalance, _this.totalBalance) || other.totalBalance == _this.totalBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WalletListMeta;
  return Object.hash(runtimeType,_this.totalBalance);
}

@override
String toString() {
  final _this = this as WalletListMeta;
  return 'WalletListMeta(totalBalance: ${_this.totalBalance})';
}


}

/// @nodoc
abstract mixin class $WalletListMetaCopyWith<$Res>  {
  factory $WalletListMetaCopyWith(WalletListMeta value, $Res Function(WalletListMeta) _then) = _$WalletListMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_balance') int? totalBalance
});




}
/// @nodoc
class _$WalletListMetaCopyWithImpl<$Res>
    implements $WalletListMetaCopyWith<$Res> {
  _$WalletListMetaCopyWithImpl(this._self, this._then);

  final WalletListMeta _self;
  final $Res Function(WalletListMeta) _then;

/// Create a copy of WalletListMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalance = freezed,}) {
  return _then(WalletListMeta(
totalBalance: freezed == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletListMeta].
extension WalletListMetaPatterns on WalletListMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletListMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletListMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletListMeta value)  $default,){
final _that = this;
switch (_that) {
case _WalletListMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletListMeta value)?  $default,){
final _that = this;
switch (_that) {
case _WalletListMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_balance')  int? totalBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletListMeta() when $default != null:
return $default(_that.totalBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_balance')  int? totalBalance)  $default,) {final _that = this;
switch (_that) {
case _WalletListMeta():
return $default(_that.totalBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_balance')  int? totalBalance)?  $default,) {final _that = this;
switch (_that) {
case _WalletListMeta() when $default != null:
return $default(_that.totalBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletListMeta implements WalletListMeta {
  const _WalletListMeta({@JsonKey(name: 'total_balance') this.totalBalance});
  factory _WalletListMeta.fromJson(Map<String, dynamic> json) => _$WalletListMetaFromJson(json);

@override@JsonKey(name: 'total_balance') final  int? totalBalance;

/// Create a copy of WalletListMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletListMetaCopyWith<_WalletListMeta> get copyWith => __$WalletListMetaCopyWithImpl<_WalletListMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletListMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletListMeta&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalBalance);
}

@override
String toString() {
    return 'WalletListMeta(totalBalance: $totalBalance)';
}


}

/// @nodoc
abstract mixin class _$WalletListMetaCopyWith<$Res> implements $WalletListMetaCopyWith<$Res> {
  factory _$WalletListMetaCopyWith(_WalletListMeta value, $Res Function(_WalletListMeta) _then) = __$WalletListMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_balance') int? totalBalance
});




}
/// @nodoc
class __$WalletListMetaCopyWithImpl<$Res>
    implements _$WalletListMetaCopyWith<$Res> {
  __$WalletListMetaCopyWithImpl(this._self, this._then);

  final _WalletListMeta _self;
  final $Res Function(_WalletListMeta) _then;

/// Create a copy of WalletListMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalance = freezed,}) {
  return _then(_WalletListMeta(
totalBalance: freezed == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
