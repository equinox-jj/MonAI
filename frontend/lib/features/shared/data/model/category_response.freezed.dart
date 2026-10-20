// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') CategoryData? get data;
/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryResponseCopyWith<CategoryResponse> get copyWith => _$CategoryResponseCopyWithImpl<CategoryResponse>(this as CategoryResponse, _$identity);

  /// Serializes this CategoryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CategoryResponse;
  return 'CategoryResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CategoryResponseCopyWith<$Res>  {
  factory $CategoryResponseCopyWith(CategoryResponse value, $Res Function(CategoryResponse) _then) = _$CategoryResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') CategoryData? data
});


$CategoryDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$CategoryResponseCopyWithImpl<$Res>
    implements $CategoryResponseCopyWith<$Res> {
  _$CategoryResponseCopyWithImpl(this._self, this._then);

  final CategoryResponse _self;
  final $Res Function(CategoryResponse) _then;

/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(CategoryResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CategoryData?,
  ));
}
/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CategoryDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryResponse].
extension CategoryResponsePatterns on CategoryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryResponse value)  $default,){
final _that = this;
switch (_that) {
case _CategoryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  CategoryData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  CategoryData? data)  $default,) {final _that = this;
switch (_that) {
case _CategoryResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  CategoryData? data)?  $default,) {final _that = this;
switch (_that) {
case _CategoryResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryResponse implements CategoryResponse {
  const _CategoryResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _CategoryResponse.fromJson(Map<String, dynamic> json) => _$CategoryResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  CategoryData? data;

/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryResponseCopyWith<_CategoryResponse> get copyWith => __$CategoryResponseCopyWithImpl<_CategoryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'CategoryResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CategoryResponseCopyWith<$Res> implements $CategoryResponseCopyWith<$Res> {
  factory _$CategoryResponseCopyWith(_CategoryResponse value, $Res Function(_CategoryResponse) _then) = __$CategoryResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') CategoryData? data
});


@override $CategoryDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$CategoryResponseCopyWithImpl<$Res>
    implements _$CategoryResponseCopyWith<$Res> {
  __$CategoryResponseCopyWithImpl(this._self, this._then);

  final _CategoryResponse _self;
  final $Res Function(_CategoryResponse) _then;

/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_CategoryResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CategoryData?,
  ));
}

/// Create a copy of CategoryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CategoryDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
