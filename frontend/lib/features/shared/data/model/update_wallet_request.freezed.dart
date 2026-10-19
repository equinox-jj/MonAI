// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_wallet_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateWalletRequest {

@JsonKey(name: 'name', includeIfNull: false) String? get name;@JsonKey(name: 'type', includeIfNull: false) String? get type;@JsonKey(name: 'initial_balance', includeIfNull: false) int? get initialBalance;@JsonKey(name: 'color', includeIfNull: false) String? get color;@JsonKey(name: 'is_default', includeIfNull: false) bool? get isDefault;@JsonKey(name: 'is_archived', includeIfNull: false) bool? get isArchived;
/// Create a copy of UpdateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWalletRequestCopyWith<UpdateWalletRequest> get copyWith => _$UpdateWalletRequestCopyWithImpl<UpdateWalletRequest>(this as UpdateWalletRequest, _$identity);

  /// Serializes this UpdateWalletRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateWalletRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWalletRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateWalletRequest;
  return Object.hash(runtimeType,_this.name,_this.type,_this.initialBalance,_this.color,_this.isDefault,_this.isArchived);
}

@override
String toString() {
  final _this = this as UpdateWalletRequest;
  return 'UpdateWalletRequest(name: ${_this.name}, type: ${_this.type}, initialBalance: ${_this.initialBalance}, color: ${_this.color}, isDefault: ${_this.isDefault}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $UpdateWalletRequestCopyWith<$Res>  {
  factory $UpdateWalletRequestCopyWith(UpdateWalletRequest value, $Res Function(UpdateWalletRequest) _then) = _$UpdateWalletRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'initial_balance', includeIfNull: false) int? initialBalance,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_default', includeIfNull: false) bool? isDefault,@JsonKey(name: 'is_archived', includeIfNull: false) bool? isArchived
});




}
/// @nodoc
class _$UpdateWalletRequestCopyWithImpl<$Res>
    implements $UpdateWalletRequestCopyWith<$Res> {
  _$UpdateWalletRequestCopyWithImpl(this._self, this._then);

  final UpdateWalletRequest _self;
  final $Res Function(UpdateWalletRequest) _then;

/// Create a copy of UpdateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? initialBalance = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,}) {
  return _then(UpdateWalletRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWalletRequest].
extension UpdateWalletRequestPatterns on UpdateWalletRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWalletRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWalletRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWalletRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWalletRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWalletRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWalletRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance', includeIfNull: false)  int? initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default', includeIfNull: false)  bool? isDefault, @JsonKey(name: 'is_archived', includeIfNull: false)  bool? isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWalletRequest() when $default != null:
return $default(_that.name,_that.type,_that.initialBalance,_that.color,_that.isDefault,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance', includeIfNull: false)  int? initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default', includeIfNull: false)  bool? isDefault, @JsonKey(name: 'is_archived', includeIfNull: false)  bool? isArchived)  $default,) {final _that = this;
switch (_that) {
case _UpdateWalletRequest():
return $default(_that.name,_that.type,_that.initialBalance,_that.color,_that.isDefault,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'initial_balance', includeIfNull: false)  int? initialBalance, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_default', includeIfNull: false)  bool? isDefault, @JsonKey(name: 'is_archived', includeIfNull: false)  bool? isArchived)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWalletRequest() when $default != null:
return $default(_that.name,_that.type,_that.initialBalance,_that.color,_that.isDefault,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWalletRequest implements UpdateWalletRequest {
  const _UpdateWalletRequest({@JsonKey(name: 'name', includeIfNull: false) this.name, @JsonKey(name: 'type', includeIfNull: false) this.type, @JsonKey(name: 'initial_balance', includeIfNull: false) this.initialBalance, @JsonKey(name: 'color', includeIfNull: false) this.color, @JsonKey(name: 'is_default', includeIfNull: false) this.isDefault, @JsonKey(name: 'is_archived', includeIfNull: false) this.isArchived});
  factory _UpdateWalletRequest.fromJson(Map<String, dynamic> json) => _$UpdateWalletRequestFromJson(json);

@override@JsonKey(name: 'name', includeIfNull: false) final  String? name;
@override@JsonKey(name: 'type', includeIfNull: false) final  String? type;
@override@JsonKey(name: 'initial_balance', includeIfNull: false) final  int? initialBalance;
@override@JsonKey(name: 'color', includeIfNull: false) final  String? color;
@override@JsonKey(name: 'is_default', includeIfNull: false) final  bool? isDefault;
@override@JsonKey(name: 'is_archived', includeIfNull: false) final  bool? isArchived;

/// Create a copy of UpdateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWalletRequestCopyWith<_UpdateWalletRequest> get copyWith => __$UpdateWalletRequestCopyWithImpl<_UpdateWalletRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWalletRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWalletRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,initialBalance,color,isDefault,isArchived);
}

@override
String toString() {
    return 'UpdateWalletRequest(name: $name, type: $type, initialBalance: $initialBalance, color: $color, isDefault: $isDefault, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$UpdateWalletRequestCopyWith<$Res> implements $UpdateWalletRequestCopyWith<$Res> {
  factory _$UpdateWalletRequestCopyWith(_UpdateWalletRequest value, $Res Function(_UpdateWalletRequest) _then) = __$UpdateWalletRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'initial_balance', includeIfNull: false) int? initialBalance,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_default', includeIfNull: false) bool? isDefault,@JsonKey(name: 'is_archived', includeIfNull: false) bool? isArchived
});




}
/// @nodoc
class __$UpdateWalletRequestCopyWithImpl<$Res>
    implements _$UpdateWalletRequestCopyWith<$Res> {
  __$UpdateWalletRequestCopyWithImpl(this._self, this._then);

  final _UpdateWalletRequest _self;
  final $Res Function(_UpdateWalletRequest) _then;

/// Create a copy of UpdateWalletRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? initialBalance = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,}) {
  return _then(_UpdateWalletRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
