// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_changes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletChanges {

 String? get name; WalletType? get type; int? get initialBalance; String? get color; bool? get isDefault; bool? get isArchived;
/// Create a copy of WalletChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletChangesCopyWith<WalletChanges> get copyWith => _$WalletChangesCopyWithImpl<WalletChanges>(this as WalletChanges, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WalletChanges;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletChanges&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}


@override
int get hashCode {
  final _this = this as WalletChanges;
  return Object.hash(runtimeType,_this.name,_this.type,_this.initialBalance,_this.color,_this.isDefault,_this.isArchived);
}

@override
String toString() {
  final _this = this as WalletChanges;
  return 'WalletChanges(name: ${_this.name}, type: ${_this.type}, initialBalance: ${_this.initialBalance}, color: ${_this.color}, isDefault: ${_this.isDefault}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $WalletChangesCopyWith<$Res>  {
  factory $WalletChangesCopyWith(WalletChanges value, $Res Function(WalletChanges) _then) = _$WalletChangesCopyWithImpl;
@useResult
$Res call({
 String? name, WalletType? type, int? initialBalance, String? color, bool? isDefault, bool? isArchived
});




}
/// @nodoc
class _$WalletChangesCopyWithImpl<$Res>
    implements $WalletChangesCopyWith<$Res> {
  _$WalletChangesCopyWithImpl(this._self, this._then);

  final WalletChanges _self;
  final $Res Function(WalletChanges) _then;

/// Create a copy of WalletChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? initialBalance = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,}) {
  return _then(WalletChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletChanges].
extension WalletChangesPatterns on WalletChanges {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletChanges() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletChanges value)  $default,){
final _that = this;
switch (_that) {
case _WalletChanges():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletChanges value)?  $default,){
final _that = this;
switch (_that) {
case _WalletChanges() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  WalletType? type,  int? initialBalance,  String? color,  bool? isDefault,  bool? isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletChanges() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  WalletType? type,  int? initialBalance,  String? color,  bool? isDefault,  bool? isArchived)  $default,) {final _that = this;
switch (_that) {
case _WalletChanges():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  WalletType? type,  int? initialBalance,  String? color,  bool? isDefault,  bool? isArchived)?  $default,) {final _that = this;
switch (_that) {
case _WalletChanges() when $default != null:
return $default(_that.name,_that.type,_that.initialBalance,_that.color,_that.isDefault,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc


class _WalletChanges extends WalletChanges {
  const _WalletChanges({this.name, this.type, this.initialBalance, this.color, this.isDefault, this.isArchived}): super._();
  

@override final  String? name;
@override final  WalletType? type;
@override final  int? initialBalance;
@override final  String? color;
@override final  bool? isDefault;
@override final  bool? isArchived;

/// Create a copy of WalletChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletChangesCopyWith<_WalletChanges> get copyWith => __$WalletChangesCopyWithImpl<_WalletChanges>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletChanges&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,type,initialBalance,color,isDefault,isArchived);
}

@override
String toString() {
    return 'WalletChanges(name: $name, type: $type, initialBalance: $initialBalance, color: $color, isDefault: $isDefault, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$WalletChangesCopyWith<$Res> implements $WalletChangesCopyWith<$Res> {
  factory _$WalletChangesCopyWith(_WalletChanges value, $Res Function(_WalletChanges) _then) = __$WalletChangesCopyWithImpl;
@override @useResult
$Res call({
 String? name, WalletType? type, int? initialBalance, String? color, bool? isDefault, bool? isArchived
});




}
/// @nodoc
class __$WalletChangesCopyWithImpl<$Res>
    implements _$WalletChangesCopyWith<$Res> {
  __$WalletChangesCopyWithImpl(this._self, this._then);

  final _WalletChanges _self;
  final $Res Function(_WalletChanges) _then;

/// Create a copy of WalletChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? initialBalance = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isArchived = freezed,}) {
  return _then(_WalletChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,initialBalance: freezed == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
