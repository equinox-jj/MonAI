// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_wallet_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWalletRequest {

@JsonKey(name: 'name', includeIfNull: false) String? get name;@JsonKey(name: 'provider_id', includeIfNull: false) String? get providerId;@JsonKey(name: 'type', includeIfNull: false) String? get type;@JsonKey(name: 'initial_balance') int get initialBalance;@JsonKey(name: 'color', includeIfNull: false) String? get color;@JsonKey(name: 'is_default') bool get isDefault;
/// Create a copy of CreateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWalletRequestCopyWith<CreateWalletRequest> get copyWith => _$CreateWalletRequestCopyWithImpl<CreateWalletRequest>(this as CreateWalletRequest, _$identity);

  /// Serializes this CreateWalletRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateWalletRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWalletRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.providerId, _this.providerId) || other.providerId == _this.providerId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateWalletRequest;
  return Object.hash(runtimeType,_this.name,_this.providerId,_this.type,_this.initialBalance,_this.color,_this.isDefault);
}

@override
String toString() {
  final _this = this as CreateWalletRequest;
  return 'CreateWalletRequest(name: ${_this.name}, providerId: ${_this.providerId}, type: ${_this.type}, initialBalance: ${_this.initialBalance}, color: ${_this.color}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $CreateWalletRequestCopyWith<$Res>  {
  factory $CreateWalletRequestCopyWith(CreateWalletRequest value, $Res Function(CreateWalletRequest) _then) = _$CreateWalletRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'provider_id', includeIfNull: false) String? providerId,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'initial_balance') int initialBalance,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class _$CreateWalletRequestCopyWithImpl<$Res>
    implements $CreateWalletRequestCopyWith<$Res> {
  _$CreateWalletRequestCopyWithImpl(this._self, this._then);

  final CreateWalletRequest _self;
  final $Res Function(CreateWalletRequest) _then;

/// Create a copy of CreateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? providerId = freezed,Object? type = freezed,Object? initialBalance = null,Object? color = freezed,Object? isDefault = null,}) {
  return _then(CreateWalletRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWalletRequest].
extension CreateWalletRequestPatterns on CreateWalletRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWalletRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWalletRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWalletRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateWalletRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWalletRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWalletRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'provider_id', includeIfNull: false)  String? providerId, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance')  int initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWalletRequest() when $default != null:
return $default(_that.name,_that.providerId,_that.type,_that.initialBalance,_that.color,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'provider_id', includeIfNull: false)  String? providerId, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance')  int initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _CreateWalletRequest():
return $default(_that.name,_that.providerId,_that.type,_that.initialBalance,_that.color,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'provider_id', includeIfNull: false)  String? providerId, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance')  int initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _CreateWalletRequest() when $default != null:
return $default(_that.name,_that.providerId,_that.type,_that.initialBalance,_that.color,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWalletRequest implements CreateWalletRequest {
  const _CreateWalletRequest({@JsonKey(name: 'name', includeIfNull: false) this.name, @JsonKey(name: 'provider_id', includeIfNull: false) this.providerId, @JsonKey(name: 'type', includeIfNull: false) this.type, @JsonKey(name: 'initial_balance') required this.initialBalance, @JsonKey(name: 'color', includeIfNull: false) this.color, @JsonKey(name: 'is_default') required this.isDefault});
  factory _CreateWalletRequest.fromJson(Map<String, dynamic> json) => _$CreateWalletRequestFromJson(json);

@override@JsonKey(name: 'name', includeIfNull: false) final  String? name;
@override@JsonKey(name: 'provider_id', includeIfNull: false) final  String? providerId;
@override@JsonKey(name: 'type', includeIfNull: false) final  String? type;
@override@JsonKey(name: 'initial_balance') final  int initialBalance;
@override@JsonKey(name: 'color', includeIfNull: false) final  String? color;
@override@JsonKey(name: 'is_default') final  bool isDefault;

/// Create a copy of CreateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWalletRequestCopyWith<_CreateWalletRequest> get copyWith => __$CreateWalletRequestCopyWithImpl<_CreateWalletRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWalletRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWalletRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.type, type) || other.type == type)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,providerId,type,initialBalance,color,isDefault);
}

@override
String toString() {
    return 'CreateWalletRequest(name: $name, providerId: $providerId, type: $type, initialBalance: $initialBalance, color: $color, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$CreateWalletRequestCopyWith<$Res> implements $CreateWalletRequestCopyWith<$Res> {
  factory _$CreateWalletRequestCopyWith(_CreateWalletRequest value, $Res Function(_CreateWalletRequest) _then) = __$CreateWalletRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'provider_id', includeIfNull: false) String? providerId,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'initial_balance') int initialBalance,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class __$CreateWalletRequestCopyWithImpl<$Res>
    implements _$CreateWalletRequestCopyWith<$Res> {
  __$CreateWalletRequestCopyWithImpl(this._self, this._then);

  final _CreateWalletRequest _self;
  final $Res Function(_CreateWalletRequest) _then;

/// Create a copy of CreateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? providerId = freezed,Object? type = freezed,Object? initialBalance = null,Object? color = freezed,Object? isDefault = null,}) {
  return _then(_CreateWalletRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
