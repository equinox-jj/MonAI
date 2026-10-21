// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_provider_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProviderRequest {

@JsonKey(name: 'name', includeIfNull: false) String? get name;@JsonKey(name: 'type', includeIfNull: false) String? get type;@JsonKey(name: 'aliases', includeIfNull: false) List<String>? get aliases;@JsonKey(name: 'sort_order', includeIfNull: false) int? get sortOrder;
/// Create a copy of UpdateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProviderRequestCopyWith<UpdateProviderRequest> get copyWith => _$UpdateProviderRequestCopyWithImpl<UpdateProviderRequest>(this as UpdateProviderRequest, _$identity);

  /// Serializes this UpdateProviderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateProviderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProviderRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateProviderRequest;
  return Object.hash(runtimeType,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder);
}

@override
String toString() {
  final _this = this as UpdateProviderRequest;
  return 'UpdateProviderRequest(name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $UpdateProviderRequestCopyWith<$Res>  {
  factory $UpdateProviderRequestCopyWith(UpdateProviderRequest value, $Res Function(UpdateProviderRequest) _then) = _$UpdateProviderRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'aliases', includeIfNull: false) List<String>? aliases,@JsonKey(name: 'sort_order', includeIfNull: false) int? sortOrder
});




}
/// @nodoc
class _$UpdateProviderRequestCopyWithImpl<$Res>
    implements $UpdateProviderRequestCopyWith<$Res> {
  _$UpdateProviderRequestCopyWithImpl(this._self, this._then);

  final UpdateProviderRequest _self;
  final $Res Function(UpdateProviderRequest) _then;

/// Create a copy of UpdateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(UpdateProviderRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProviderRequest].
extension UpdateProviderRequestPatterns on UpdateProviderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProviderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProviderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProviderRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProviderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProviderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProviderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'aliases', includeIfNull: false)  List<String>? aliases, @JsonKey(name: 'sort_order', includeIfNull: false)  int? sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProviderRequest() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'aliases', includeIfNull: false)  List<String>? aliases, @JsonKey(name: 'sort_order', includeIfNull: false)  int? sortOrder)  $default,) {final _that = this;
switch (_that) {
case _UpdateProviderRequest():
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'type', includeIfNull: false)  String? type, @JsonKey(name: 'aliases', includeIfNull: false)  List<String>? aliases, @JsonKey(name: 'sort_order', includeIfNull: false)  int? sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProviderRequest() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProviderRequest implements UpdateProviderRequest {
  const _UpdateProviderRequest({@JsonKey(name: 'name', includeIfNull: false) this.name, @JsonKey(name: 'type', includeIfNull: false) this.type, @JsonKey(name: 'aliases', includeIfNull: false)  List<String>? aliases, @JsonKey(name: 'sort_order', includeIfNull: false) this.sortOrder}): _aliases = aliases;
  factory _UpdateProviderRequest.fromJson(Map<String, dynamic> json) => _$UpdateProviderRequestFromJson(json);

@override@JsonKey(name: 'name', includeIfNull: false) final  String? name;
@override@JsonKey(name: 'type', includeIfNull: false) final  String? type;
 final  List<String>? _aliases;
@override@JsonKey(name: 'aliases', includeIfNull: false) List<String>? get aliases {
  final value = _aliases;
  if (value == null) return null;
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'sort_order', includeIfNull: false) final  int? sortOrder;

/// Create a copy of UpdateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProviderRequestCopyWith<_UpdateProviderRequest> get copyWith => __$UpdateProviderRequestCopyWithImpl<_UpdateProviderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProviderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProviderRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder);
}

@override
String toString() {
    return 'UpdateProviderRequest(name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$UpdateProviderRequestCopyWith<$Res> implements $UpdateProviderRequestCopyWith<$Res> {
  factory _$UpdateProviderRequestCopyWith(_UpdateProviderRequest value, $Res Function(_UpdateProviderRequest) _then) = __$UpdateProviderRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'type', includeIfNull: false) String? type,@JsonKey(name: 'aliases', includeIfNull: false) List<String>? aliases,@JsonKey(name: 'sort_order', includeIfNull: false) int? sortOrder
});




}
/// @nodoc
class __$UpdateProviderRequestCopyWithImpl<$Res>
    implements _$UpdateProviderRequestCopyWith<$Res> {
  __$UpdateProviderRequestCopyWithImpl(this._self, this._then);

  final _UpdateProviderRequest _self;
  final $Res Function(_UpdateProviderRequest) _then;

/// Create a copy of UpdateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(_UpdateProviderRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
