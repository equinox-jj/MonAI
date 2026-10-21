// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_provider_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProviderRequest {

@JsonKey(name: 'name') String get name;/// `CASH`, `BANK`, `E_WALLET` or `OTHER`.
@JsonKey(name: 'type') String get type;@JsonKey(name: 'aliases') List<String> get aliases;@JsonKey(name: 'sort_order') int get sortOrder;
/// Create a copy of CreateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProviderRequestCopyWith<CreateProviderRequest> get copyWith => _$CreateProviderRequestCopyWithImpl<CreateProviderRequest>(this as CreateProviderRequest, _$identity);

  /// Serializes this CreateProviderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProviderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProviderRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProviderRequest;
  return Object.hash(runtimeType,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder);
}

@override
String toString() {
  final _this = this as CreateProviderRequest;
  return 'CreateProviderRequest(name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $CreateProviderRequestCopyWith<$Res>  {
  factory $CreateProviderRequestCopyWith(CreateProviderRequest value, $Res Function(CreateProviderRequest) _then) = _$CreateProviderRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'type') String type,@JsonKey(name: 'aliases') List<String> aliases,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class _$CreateProviderRequestCopyWithImpl<$Res>
    implements $CreateProviderRequestCopyWith<$Res> {
  _$CreateProviderRequestCopyWithImpl(this._self, this._then);

  final CreateProviderRequest _self;
  final $Res Function(CreateProviderRequest) _then;

/// Create a copy of CreateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,}) {
  return _then(CreateProviderRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProviderRequest].
extension CreateProviderRequestPatterns on CreateProviderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProviderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProviderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProviderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProviderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProviderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProviderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'type')  String type, @JsonKey(name: 'aliases')  List<String> aliases, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProviderRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'type')  String type, @JsonKey(name: 'aliases')  List<String> aliases, @JsonKey(name: 'sort_order')  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _CreateProviderRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'type')  String type, @JsonKey(name: 'aliases')  List<String> aliases, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _CreateProviderRequest() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProviderRequest implements CreateProviderRequest {
  const _CreateProviderRequest({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'type') required this.type, @JsonKey(name: 'aliases') required  List<String> aliases, @JsonKey(name: 'sort_order') required this.sortOrder}): _aliases = aliases;
  factory _CreateProviderRequest.fromJson(Map<String, dynamic> json) => _$CreateProviderRequestFromJson(json);

@override@JsonKey(name: 'name') final  String name;
/// `CASH`, `BANK`, `E_WALLET` or `OTHER`.
@override@JsonKey(name: 'type') final  String type;
 final  List<String> _aliases;
@override@JsonKey(name: 'aliases') List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override@JsonKey(name: 'sort_order') final  int sortOrder;

/// Create a copy of CreateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProviderRequestCopyWith<_CreateProviderRequest> get copyWith => __$CreateProviderRequestCopyWithImpl<_CreateProviderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProviderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProviderRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder);
}

@override
String toString() {
    return 'CreateProviderRequest(name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CreateProviderRequestCopyWith<$Res> implements $CreateProviderRequestCopyWith<$Res> {
  factory _$CreateProviderRequestCopyWith(_CreateProviderRequest value, $Res Function(_CreateProviderRequest) _then) = __$CreateProviderRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'type') String type,@JsonKey(name: 'aliases') List<String> aliases,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class __$CreateProviderRequestCopyWithImpl<$Res>
    implements _$CreateProviderRequestCopyWith<$Res> {
  __$CreateProviderRequestCopyWithImpl(this._self, this._then);

  final _CreateProviderRequest _self;
  final $Res Function(_CreateProviderRequest) _then;

/// Create a copy of CreateProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,}) {
  return _then(_CreateProviderRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
