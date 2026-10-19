// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletInput {

 String get name; String? get providerId; WalletType? get type; int get initialBalance;/// `#RRGGBB`.
 String? get color; bool get isDefault;
/// Create a copy of WalletInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletInputCopyWith<WalletInput> get copyWith => _$WalletInputCopyWithImpl<WalletInput>(this as WalletInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WalletInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.providerId, _this.providerId) || other.providerId == _this.providerId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}


@override
int get hashCode {
  final _this = this as WalletInput;
  return Object.hash(runtimeType,_this.name,_this.providerId,_this.type,_this.initialBalance,_this.color,_this.isDefault);
}

@override
String toString() {
  final _this = this as WalletInput;
  return 'WalletInput(name: ${_this.name}, providerId: ${_this.providerId}, type: ${_this.type}, initialBalance: ${_this.initialBalance}, color: ${_this.color}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $WalletInputCopyWith<$Res>  {
  factory $WalletInputCopyWith(WalletInput value, $Res Function(WalletInput) _then) = _$WalletInputCopyWithImpl;
@useResult
$Res call({
 String name, String? providerId, WalletType? type, int initialBalance, String? color, bool isDefault
});




}
/// @nodoc
class _$WalletInputCopyWithImpl<$Res>
    implements $WalletInputCopyWith<$Res> {
  _$WalletInputCopyWithImpl(this._self, this._then);

  final WalletInput _self;
  final $Res Function(WalletInput) _then;

/// Create a copy of WalletInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? providerId = freezed,Object? type = freezed,Object? initialBalance = null,Object? color = freezed,Object? isDefault = null,}) {
  return _then(WalletInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletInput].
extension WalletInputPatterns on WalletInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletInput value)  $default,){
final _that = this;
switch (_that) {
case _WalletInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletInput value)?  $default,){
final _that = this;
switch (_that) {
case _WalletInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? providerId,  WalletType? type,  int initialBalance,  String? color,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletInput() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? providerId,  WalletType? type,  int initialBalance,  String? color,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _WalletInput():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? providerId,  WalletType? type,  int initialBalance,  String? color,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _WalletInput() when $default != null:
return $default(_that.name,_that.providerId,_that.type,_that.initialBalance,_that.color,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _WalletInput implements WalletInput {
  const _WalletInput({required this.name, this.providerId, this.type, this.initialBalance = 0, this.color, this.isDefault = false});
  

@override final  String name;
@override final  String? providerId;
@override final  WalletType? type;
@override@JsonKey() final  int initialBalance;
/// `#RRGGBB`.
@override final  String? color;
@override@JsonKey() final  bool isDefault;

/// Create a copy of WalletInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletInputCopyWith<_WalletInput> get copyWith => __$WalletInputCopyWithImpl<_WalletInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletInput&&(identical(other.name, name) || other.name == name)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.type, type) || other.type == type)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,providerId,type,initialBalance,color,isDefault);
}

@override
String toString() {
    return 'WalletInput(name: $name, providerId: $providerId, type: $type, initialBalance: $initialBalance, color: $color, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$WalletInputCopyWith<$Res> implements $WalletInputCopyWith<$Res> {
  factory _$WalletInputCopyWith(_WalletInput value, $Res Function(_WalletInput) _then) = __$WalletInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String? providerId, WalletType? type, int initialBalance, String? color, bool isDefault
});




}
/// @nodoc
class __$WalletInputCopyWithImpl<$Res>
    implements _$WalletInputCopyWith<$Res> {
  __$WalletInputCopyWithImpl(this._self, this._then);

  final _WalletInput _self;
  final $Res Function(_WalletInput) _then;

/// Create a copy of WalletInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? providerId = freezed,Object? type = freezed,Object? initialBalance = null,Object? color = freezed,Object? isDefault = null,}) {
  return _then(_WalletInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
