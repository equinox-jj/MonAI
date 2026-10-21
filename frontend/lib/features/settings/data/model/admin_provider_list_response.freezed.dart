// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_provider_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminProviderListResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<AdminProviderData>? get data;@JsonKey(name: 'meta') AdminProviderListMeta? get meta;
/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProviderListResponseCopyWith<AdminProviderListResponse> get copyWith => _$AdminProviderListResponseCopyWithImpl<AdminProviderListResponse>(this as AdminProviderListResponse, _$identity);

  /// Serializes this AdminProviderListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProviderListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProviderListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProviderListResponse;
  return Object.hash(runtimeType,_this.success,_this.message,const DeepCollectionEquality().hash(_this.data),_this.meta);
}

@override
String toString() {
  final _this = this as AdminProviderListResponse;
  return 'AdminProviderListResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $AdminProviderListResponseCopyWith<$Res>  {
  factory $AdminProviderListResponseCopyWith(AdminProviderListResponse value, $Res Function(AdminProviderListResponse) _then) = _$AdminProviderListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<AdminProviderData>? data,@JsonKey(name: 'meta') AdminProviderListMeta? meta
});


$AdminProviderListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$AdminProviderListResponseCopyWithImpl<$Res>
    implements $AdminProviderListResponseCopyWith<$Res> {
  _$AdminProviderListResponseCopyWithImpl(this._self, this._then);

  final AdminProviderListResponse _self;
  final $Res Function(AdminProviderListResponse) _then;

/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(AdminProviderListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AdminProviderData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminProviderListMeta?,
  ));
}
/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProviderListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminProviderListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminProviderListResponse].
extension AdminProviderListResponsePatterns on AdminProviderListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProviderListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProviderListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProviderListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminProviderListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProviderListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProviderListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<AdminProviderData>? data, @JsonKey(name: 'meta')  AdminProviderListMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProviderListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<AdminProviderData>? data, @JsonKey(name: 'meta')  AdminProviderListMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _AdminProviderListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<AdminProviderData>? data, @JsonKey(name: 'meta')  AdminProviderListMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _AdminProviderListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProviderListResponse implements AdminProviderListResponse {
  const _AdminProviderListResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data')  List<AdminProviderData>? data, @JsonKey(name: 'meta') this.meta}): _data = data;
  factory _AdminProviderListResponse.fromJson(Map<String, dynamic> json) => _$AdminProviderListResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<AdminProviderData>? _data;
@override@JsonKey(name: 'data') List<AdminProviderData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'meta') final  AdminProviderListMeta? meta;

/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProviderListResponseCopyWith<_AdminProviderListResponse> get copyWith => __$AdminProviderListResponseCopyWithImpl<_AdminProviderListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProviderListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProviderListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);
}

@override
String toString() {
    return 'AdminProviderListResponse(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$AdminProviderListResponseCopyWith<$Res> implements $AdminProviderListResponseCopyWith<$Res> {
  factory _$AdminProviderListResponseCopyWith(_AdminProviderListResponse value, $Res Function(_AdminProviderListResponse) _then) = __$AdminProviderListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<AdminProviderData>? data,@JsonKey(name: 'meta') AdminProviderListMeta? meta
});


@override $AdminProviderListMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$AdminProviderListResponseCopyWithImpl<$Res>
    implements _$AdminProviderListResponseCopyWith<$Res> {
  __$AdminProviderListResponseCopyWithImpl(this._self, this._then);

  final _AdminProviderListResponse _self;
  final $Res Function(_AdminProviderListResponse) _then;

/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,Object? meta = freezed,}) {
  return _then(_AdminProviderListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AdminProviderData>?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminProviderListMeta?,
  ));
}

/// Create a copy of AdminProviderListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProviderListMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminProviderListMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$AdminProviderListMeta {

@JsonKey(name: 'page') int? get page;@JsonKey(name: 'per_page') int? get perPage;@JsonKey(name: 'total') int? get total;@JsonKey(name: 'total_pages') int? get totalPages;
/// Create a copy of AdminProviderListMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProviderListMetaCopyWith<AdminProviderListMeta> get copyWith => _$AdminProviderListMetaCopyWithImpl<AdminProviderListMeta>(this as AdminProviderListMeta, _$identity);

  /// Serializes this AdminProviderListMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProviderListMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProviderListMeta&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.perPage, _this.perPage) || other.perPage == _this.perPage)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProviderListMeta;
  return Object.hash(runtimeType,_this.page,_this.perPage,_this.total,_this.totalPages);
}

@override
String toString() {
  final _this = this as AdminProviderListMeta;
  return 'AdminProviderListMeta(page: ${_this.page}, perPage: ${_this.perPage}, total: ${_this.total}, totalPages: ${_this.totalPages})';
}


}

/// @nodoc
abstract mixin class $AdminProviderListMetaCopyWith<$Res>  {
  factory $AdminProviderListMetaCopyWith(AdminProviderListMeta value, $Res Function(AdminProviderListMeta) _then) = _$AdminProviderListMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'page') int? page,@JsonKey(name: 'per_page') int? perPage,@JsonKey(name: 'total') int? total,@JsonKey(name: 'total_pages') int? totalPages
});




}
/// @nodoc
class _$AdminProviderListMetaCopyWithImpl<$Res>
    implements $AdminProviderListMetaCopyWith<$Res> {
  _$AdminProviderListMetaCopyWithImpl(this._self, this._then);

  final AdminProviderListMeta _self;
  final $Res Function(AdminProviderListMeta) _then;

/// Create a copy of AdminProviderListMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = freezed,Object? perPage = freezed,Object? total = freezed,Object? totalPages = freezed,}) {
  return _then(AdminProviderListMeta(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProviderListMeta].
extension AdminProviderListMetaPatterns on AdminProviderListMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProviderListMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProviderListMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProviderListMeta value)  $default,){
final _that = this;
switch (_that) {
case _AdminProviderListMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProviderListMeta value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProviderListMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'page')  int? page, @JsonKey(name: 'per_page')  int? perPage, @JsonKey(name: 'total')  int? total, @JsonKey(name: 'total_pages')  int? totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProviderListMeta() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'page')  int? page, @JsonKey(name: 'per_page')  int? perPage, @JsonKey(name: 'total')  int? total, @JsonKey(name: 'total_pages')  int? totalPages)  $default,) {final _that = this;
switch (_that) {
case _AdminProviderListMeta():
return $default(_that.page,_that.perPage,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'page')  int? page, @JsonKey(name: 'per_page')  int? perPage, @JsonKey(name: 'total')  int? total, @JsonKey(name: 'total_pages')  int? totalPages)?  $default,) {final _that = this;
switch (_that) {
case _AdminProviderListMeta() when $default != null:
return $default(_that.page,_that.perPage,_that.total,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProviderListMeta implements AdminProviderListMeta {
  const _AdminProviderListMeta({@JsonKey(name: 'page') this.page, @JsonKey(name: 'per_page') this.perPage, @JsonKey(name: 'total') this.total, @JsonKey(name: 'total_pages') this.totalPages});
  factory _AdminProviderListMeta.fromJson(Map<String, dynamic> json) => _$AdminProviderListMetaFromJson(json);

@override@JsonKey(name: 'page') final  int? page;
@override@JsonKey(name: 'per_page') final  int? perPage;
@override@JsonKey(name: 'total') final  int? total;
@override@JsonKey(name: 'total_pages') final  int? totalPages;

/// Create a copy of AdminProviderListMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProviderListMetaCopyWith<_AdminProviderListMeta> get copyWith => __$AdminProviderListMetaCopyWithImpl<_AdminProviderListMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProviderListMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProviderListMeta&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,page,perPage,total,totalPages);
}

@override
String toString() {
    return 'AdminProviderListMeta(page: $page, perPage: $perPage, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$AdminProviderListMetaCopyWith<$Res> implements $AdminProviderListMetaCopyWith<$Res> {
  factory _$AdminProviderListMetaCopyWith(_AdminProviderListMeta value, $Res Function(_AdminProviderListMeta) _then) = __$AdminProviderListMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'page') int? page,@JsonKey(name: 'per_page') int? perPage,@JsonKey(name: 'total') int? total,@JsonKey(name: 'total_pages') int? totalPages
});




}
/// @nodoc
class __$AdminProviderListMetaCopyWithImpl<$Res>
    implements _$AdminProviderListMetaCopyWith<$Res> {
  __$AdminProviderListMetaCopyWithImpl(this._self, this._then);

  final _AdminProviderListMeta _self;
  final $Res Function(_AdminProviderListMeta) _then;

/// Create a copy of AdminProviderListMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = freezed,Object? perPage = freezed,Object? total = freezed,Object? totalPages = freezed,}) {
  return _then(_AdminProviderListMeta(
page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
