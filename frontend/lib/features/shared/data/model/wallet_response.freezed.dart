// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') WalletData? get data;
/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletResponseCopyWith<WalletResponse> get copyWith => _$WalletResponseCopyWithImpl<WalletResponse>(this as WalletResponse, _$identity);

  /// Serializes this WalletResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WalletResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WalletResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as WalletResponse;
  return 'WalletResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $WalletResponseCopyWith<$Res>  {
  factory $WalletResponseCopyWith(WalletResponse value, $Res Function(WalletResponse) _then) = _$WalletResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') WalletData? data
});


$WalletDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$WalletResponseCopyWithImpl<$Res>
    implements $WalletResponseCopyWith<$Res> {
  _$WalletResponseCopyWithImpl(this._self, this._then);

  final WalletResponse _self;
  final $Res Function(WalletResponse) _then;

/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(WalletResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData?,
  ));
}
/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $WalletDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletResponse].
extension WalletResponsePatterns on WalletResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletResponse value)  $default,){
final _that = this;
switch (_that) {
case _WalletResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WalletResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  WalletData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  WalletData? data)  $default,) {final _that = this;
switch (_that) {
case _WalletResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  WalletData? data)?  $default,) {final _that = this;
switch (_that) {
case _WalletResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletResponse implements WalletResponse {
  const _WalletResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _WalletResponse.fromJson(Map<String, dynamic> json) => _$WalletResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  WalletData? data;

/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletResponseCopyWith<_WalletResponse> get copyWith => __$WalletResponseCopyWithImpl<_WalletResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'WalletResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletResponseCopyWith<$Res> implements $WalletResponseCopyWith<$Res> {
  factory _$WalletResponseCopyWith(_WalletResponse value, $Res Function(_WalletResponse) _then) = __$WalletResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') WalletData? data
});


@override $WalletDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$WalletResponseCopyWithImpl<$Res>
    implements _$WalletResponseCopyWith<$Res> {
  __$WalletResponseCopyWithImpl(this._self, this._then);

  final _WalletResponse _self;
  final $Res Function(_WalletResponse) _then;

/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_WalletResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData?,
  ));
}

/// Create a copy of WalletResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $WalletDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$WalletData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'provider_id') String? get providerId;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'initial_balance') int? get initialBalance;@JsonKey(name: 'current_balance') int? get currentBalance;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'color') String? get color;@JsonKey(name: 'is_default') bool? get isDefault;@JsonKey(name: 'is_archived') bool? get isArchived;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDataCopyWith<WalletData> get copyWith => _$WalletDataCopyWithImpl<WalletData>(this as WalletData, _$identity);

  /// Serializes this WalletData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WalletData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.providerId, _this.providerId) || other.providerId == _this.providerId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.currentBalance, _this.currentBalance) || other.currentBalance == _this.currentBalance)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WalletData;
  return Object.hash(runtimeType,_this.id,_this.providerId,_this.name,_this.type,_this.logoUrl,_this.initialBalance,_this.currentBalance,_this.icon,_this.color,_this.isDefault,_this.isArchived,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as WalletData;
  return 'WalletData(id: ${_this.id}, providerId: ${_this.providerId}, name: ${_this.name}, type: ${_this.type}, logoUrl: ${_this.logoUrl}, initialBalance: ${_this.initialBalance}, currentBalance: ${_this.currentBalance}, icon: ${_this.icon}, color: ${_this.color}, isDefault: ${_this.isDefault}, isArchived: ${_this.isArchived}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $WalletDataCopyWith<$Res>  {
  factory $WalletDataCopyWith(WalletData value, $Res Function(WalletData) _then) = _$WalletDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'provider_id') String? providerId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'initial_balance') int? initialBalance,@JsonKey(name: 'current_balance') int? currentBalance,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'is_default') bool? isDefault,@JsonKey(name: 'is_archived') bool? isArchived,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$WalletDataCopyWithImpl<$Res>
    implements $WalletDataCopyWith<$Res> {
  _$WalletDataCopyWithImpl(this._self, this._then);

  final WalletData _self;
  final $Res Function(WalletData) _then;

/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? providerId = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? initialBalance = freezed,Object? currentBalance = freezed,Object? icon = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(WalletData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,currentBalance: freezed == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletData].
extension WalletDataPatterns on WalletData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletData value)  $default,){
final _that = this;
switch (_that) {
case _WalletData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletData value)?  $default,){
final _that = this;
switch (_that) {
case _WalletData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'provider_id')  String? providerId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'initial_balance')  int? initialBalance, @JsonKey(name: 'current_balance')  int? currentBalance, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_archived')  bool? isArchived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletData() when $default != null:
return $default(_that.id,_that.providerId,_that.name,_that.type,_that.logoUrl,_that.initialBalance,_that.currentBalance,_that.icon,_that.color,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'provider_id')  String? providerId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'initial_balance')  int? initialBalance, @JsonKey(name: 'current_balance')  int? currentBalance, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_archived')  bool? isArchived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WalletData():
return $default(_that.id,_that.providerId,_that.name,_that.type,_that.logoUrl,_that.initialBalance,_that.currentBalance,_that.icon,_that.color,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'provider_id')  String? providerId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'initial_balance')  int? initialBalance, @JsonKey(name: 'current_balance')  int? currentBalance, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_archived')  bool? isArchived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletData() when $default != null:
return $default(_that.id,_that.providerId,_that.name,_that.type,_that.logoUrl,_that.initialBalance,_that.currentBalance,_that.icon,_that.color,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletData implements WalletData {
  const _WalletData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'provider_id') this.providerId, @JsonKey(name: 'name') this.name, @JsonKey(name: 'type') this.type, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'initial_balance') this.initialBalance, @JsonKey(name: 'current_balance') this.currentBalance, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'color') this.color, @JsonKey(name: 'is_default') this.isDefault, @JsonKey(name: 'is_archived') this.isArchived, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _WalletData.fromJson(Map<String, dynamic> json) => _$WalletDataFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'provider_id') final  String? providerId;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'initial_balance') final  int? initialBalance;
@override@JsonKey(name: 'current_balance') final  int? currentBalance;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'color') final  String? color;
@override@JsonKey(name: 'is_default') final  bool? isDefault;
@override@JsonKey(name: 'is_archived') final  bool? isArchived;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDataCopyWith<_WalletData> get copyWith => __$WalletDataCopyWithImpl<_WalletData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletData&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,providerId,name,type,logoUrl,initialBalance,currentBalance,icon,color,isDefault,isArchived,createdAt,updatedAt);
}

@override
String toString() {
    return 'WalletData(id: $id, providerId: $providerId, name: $name, type: $type, logoUrl: $logoUrl, initialBalance: $initialBalance, currentBalance: $currentBalance, icon: $icon, color: $color, isDefault: $isDefault, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WalletDataCopyWith<$Res> implements $WalletDataCopyWith<$Res> {
  factory _$WalletDataCopyWith(_WalletData value, $Res Function(_WalletData) _then) = __$WalletDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'provider_id') String? providerId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'initial_balance') int? initialBalance,@JsonKey(name: 'current_balance') int? currentBalance,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'is_default') bool? isDefault,@JsonKey(name: 'is_archived') bool? isArchived,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$WalletDataCopyWithImpl<$Res>
    implements _$WalletDataCopyWith<$Res> {
  __$WalletDataCopyWithImpl(this._self, this._then);

  final _WalletData _self;
  final $Res Function(_WalletData) _then;

/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? providerId = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? initialBalance = freezed,Object? currentBalance = freezed,Object? icon = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_WalletData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,currentBalance: freezed == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
