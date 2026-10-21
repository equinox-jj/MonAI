// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Refreshed value)?  refreshed,TResult Function( _BalanceVisibilityToggled value)?  balanceVisibilityToggled,TResult Function( _DashboardChanged value)?  dashboardChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _BalanceVisibilityToggled() when balanceVisibilityToggled != null:
return balanceVisibilityToggled(_that);case _DashboardChanged() when dashboardChanged != null:
return dashboardChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Refreshed value)  refreshed,required TResult Function( _BalanceVisibilityToggled value)  balanceVisibilityToggled,required TResult Function( _DashboardChanged value)  dashboardChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Refreshed():
return refreshed(_that);case _BalanceVisibilityToggled():
return balanceVisibilityToggled(_that);case _DashboardChanged():
return dashboardChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Refreshed value)?  refreshed,TResult? Function( _BalanceVisibilityToggled value)?  balanceVisibilityToggled,TResult? Function( _DashboardChanged value)?  dashboardChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _BalanceVisibilityToggled() when balanceVisibilityToggled != null:
return balanceVisibilityToggled(_that);case _DashboardChanged() when dashboardChanged != null:
return dashboardChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshed,TResult Function()?  balanceVisibilityToggled,TResult Function( HomeDashboard dashboard)?  dashboardChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _BalanceVisibilityToggled() when balanceVisibilityToggled != null:
return balanceVisibilityToggled();case _DashboardChanged() when dashboardChanged != null:
return dashboardChanged(_that.dashboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshed,required TResult Function()  balanceVisibilityToggled,required TResult Function( HomeDashboard dashboard)  dashboardChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Refreshed():
return refreshed();case _BalanceVisibilityToggled():
return balanceVisibilityToggled();case _DashboardChanged():
return dashboardChanged(_that.dashboard);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshed,TResult? Function()?  balanceVisibilityToggled,TResult? Function( HomeDashboard dashboard)?  dashboardChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _BalanceVisibilityToggled() when balanceVisibilityToggled != null:
return balanceVisibilityToggled();case _DashboardChanged() when dashboardChanged != null:
return dashboardChanged(_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements HomeEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeEvent.started()';
}


}




/// @nodoc


class _Refreshed implements HomeEvent {
  const _Refreshed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeEvent.refreshed()';
}


}




/// @nodoc


class _BalanceVisibilityToggled implements HomeEvent {
  const _BalanceVisibilityToggled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceVisibilityToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeEvent.balanceVisibilityToggled()';
}


}




/// @nodoc


class _DashboardChanged implements HomeEvent {
  const _DashboardChanged(this.dashboard);
  

 final  HomeDashboard dashboard;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardChangedCopyWith<_DashboardChanged> get copyWith => __$DashboardChangedCopyWithImpl<_DashboardChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardChanged&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode {
    return Object.hash(runtimeType,dashboard);
}

@override
String toString() {
    return 'HomeEvent.dashboardChanged(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$DashboardChangedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$DashboardChangedCopyWith(_DashboardChanged value, $Res Function(_DashboardChanged) _then) = __$DashboardChangedCopyWithImpl;
@useResult
$Res call({
 HomeDashboard dashboard
});


$HomeDashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$DashboardChangedCopyWithImpl<$Res>
    implements _$DashboardChangedCopyWith<$Res> {
  __$DashboardChangedCopyWithImpl(this._self, this._then);

  final _DashboardChanged _self;
  final $Res Function(_DashboardChanged) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dashboard = null,}) {
  return _then(_DashboardChanged(
null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as HomeDashboard,
  ));
}

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<$Res> get dashboard {
  
  return $HomeDashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

/// @nodoc
mixin _$HomeState {

 UiStatus get status; HomeDashboard? get dashboard; bool get isRefreshing; bool get isBalanceHidden;/// The month's budget was fetched, so a missing one means "not set".
 bool get budgetLoaded;/// The month's transactions were fetched, so none means a first run.
 bool get recentLoaded; HomeLoadFailure? get loadFailure; HomeLoadFailure? get refreshFailure;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dashboard, _this.dashboard) || other.dashboard == _this.dashboard)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.isBalanceHidden, _this.isBalanceHidden) || other.isBalanceHidden == _this.isBalanceHidden)&&(identical(other.budgetLoaded, _this.budgetLoaded) || other.budgetLoaded == _this.budgetLoaded)&&(identical(other.recentLoaded, _this.recentLoaded) || other.recentLoaded == _this.recentLoaded)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.refreshFailure, _this.refreshFailure) || other.refreshFailure == _this.refreshFailure));
}


@override
int get hashCode {
  final _this = this as HomeState;
  return Object.hash(runtimeType,_this.status,_this.dashboard,_this.isRefreshing,_this.isBalanceHidden,_this.budgetLoaded,_this.recentLoaded,_this.loadFailure,_this.refreshFailure);
}

@override
String toString() {
  final _this = this as HomeState;
  return 'HomeState(status: ${_this.status}, dashboard: ${_this.dashboard}, isRefreshing: ${_this.isRefreshing}, isBalanceHidden: ${_this.isBalanceHidden}, budgetLoaded: ${_this.budgetLoaded}, recentLoaded: ${_this.recentLoaded}, loadFailure: ${_this.loadFailure}, refreshFailure: ${_this.refreshFailure})';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, HomeDashboard? dashboard, bool isRefreshing, bool isBalanceHidden, bool budgetLoaded, bool recentLoaded, HomeLoadFailure? loadFailure, HomeLoadFailure? refreshFailure
});


$HomeDashboardCopyWith<$Res>? get dashboard;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? dashboard = freezed,Object? isRefreshing = null,Object? isBalanceHidden = null,Object? budgetLoaded = null,Object? recentLoaded = null,Object? loadFailure = freezed,Object? refreshFailure = freezed,}) {
  return _then(HomeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,dashboard: freezed == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as HomeDashboard?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isBalanceHidden: null == isBalanceHidden ? _self.isBalanceHidden : isBalanceHidden // ignore: cast_nullable_to_non_nullable
as bool,budgetLoaded: null == budgetLoaded ? _self.budgetLoaded : budgetLoaded // ignore: cast_nullable_to_non_nullable
as bool,recentLoaded: null == recentLoaded ? _self.recentLoaded : recentLoaded // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as HomeLoadFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as HomeLoadFailure?,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<$Res>? get dashboard {
    if (_self.dashboard == null) {
    return null;
  }

  return $HomeDashboardCopyWith<$Res>(_self.dashboard!, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  HomeDashboard? dashboard,  bool isRefreshing,  bool isBalanceHidden,  bool budgetLoaded,  bool recentLoaded,  HomeLoadFailure? loadFailure,  HomeLoadFailure? refreshFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.status,_that.dashboard,_that.isRefreshing,_that.isBalanceHidden,_that.budgetLoaded,_that.recentLoaded,_that.loadFailure,_that.refreshFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  HomeDashboard? dashboard,  bool isRefreshing,  bool isBalanceHidden,  bool budgetLoaded,  bool recentLoaded,  HomeLoadFailure? loadFailure,  HomeLoadFailure? refreshFailure)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.status,_that.dashboard,_that.isRefreshing,_that.isBalanceHidden,_that.budgetLoaded,_that.recentLoaded,_that.loadFailure,_that.refreshFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  HomeDashboard? dashboard,  bool isRefreshing,  bool isBalanceHidden,  bool budgetLoaded,  bool recentLoaded,  HomeLoadFailure? loadFailure,  HomeLoadFailure? refreshFailure)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.status,_that.dashboard,_that.isRefreshing,_that.isBalanceHidden,_that.budgetLoaded,_that.recentLoaded,_that.loadFailure,_that.refreshFailure);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.status = UiStatus.initial, this.dashboard, this.isRefreshing = false, this.isBalanceHidden = false, this.budgetLoaded = false, this.recentLoaded = false, this.loadFailure, this.refreshFailure});
  

@override@JsonKey() final  UiStatus status;
@override final  HomeDashboard? dashboard;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool isBalanceHidden;
/// The month's budget was fetched, so a missing one means "not set".
@override@JsonKey() final  bool budgetLoaded;
/// The month's transactions were fetched, so none means a first run.
@override@JsonKey() final  bool recentLoaded;
@override final  HomeLoadFailure? loadFailure;
@override final  HomeLoadFailure? refreshFailure;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.status, status) || other.status == status)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.isBalanceHidden, isBalanceHidden) || other.isBalanceHidden == isBalanceHidden)&&(identical(other.budgetLoaded, budgetLoaded) || other.budgetLoaded == budgetLoaded)&&(identical(other.recentLoaded, recentLoaded) || other.recentLoaded == recentLoaded)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.refreshFailure, refreshFailure) || other.refreshFailure == refreshFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,dashboard,isRefreshing,isBalanceHidden,budgetLoaded,recentLoaded,loadFailure,refreshFailure);
}

@override
String toString() {
    return 'HomeState(status: $status, dashboard: $dashboard, isRefreshing: $isRefreshing, isBalanceHidden: $isBalanceHidden, budgetLoaded: $budgetLoaded, recentLoaded: $recentLoaded, loadFailure: $loadFailure, refreshFailure: $refreshFailure)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, HomeDashboard? dashboard, bool isRefreshing, bool isBalanceHidden, bool budgetLoaded, bool recentLoaded, HomeLoadFailure? loadFailure, HomeLoadFailure? refreshFailure
});


@override $HomeDashboardCopyWith<$Res>? get dashboard;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? dashboard = freezed,Object? isRefreshing = null,Object? isBalanceHidden = null,Object? budgetLoaded = null,Object? recentLoaded = null,Object? loadFailure = freezed,Object? refreshFailure = freezed,}) {
  return _then(_HomeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,dashboard: freezed == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as HomeDashboard?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isBalanceHidden: null == isBalanceHidden ? _self.isBalanceHidden : isBalanceHidden // ignore: cast_nullable_to_non_nullable
as bool,budgetLoaded: null == budgetLoaded ? _self.budgetLoaded : budgetLoaded // ignore: cast_nullable_to_non_nullable
as bool,recentLoaded: null == recentLoaded ? _self.recentLoaded : recentLoaded // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as HomeLoadFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as HomeLoadFailure?,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<$Res>? get dashboard {
    if (_self.dashboard == null) {
    return null;
  }

  return $HomeDashboardCopyWith<$Res>(_self.dashboard!, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

// dart format on
