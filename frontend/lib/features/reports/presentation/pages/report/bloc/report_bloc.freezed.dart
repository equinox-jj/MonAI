// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReportEvent()';
}


}

/// @nodoc
class $ReportEventCopyWith<$Res>  {
$ReportEventCopyWith(ReportEvent _, $Res Function(ReportEvent) __);
}


/// Adds pattern-matching-related methods to [ReportEvent].
extension ReportEventPatterns on ReportEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _PreviousMonth value)?  previousMonth,TResult Function( _NextMonth value)?  nextMonth,TResult Function( _Retried value)?  retried,TResult Function( _ReportChanged value)?  reportChanged,TResult Function( _BudgetChanged value)?  budgetChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PreviousMonth() when previousMonth != null:
return previousMonth(_that);case _NextMonth() when nextMonth != null:
return nextMonth(_that);case _Retried() when retried != null:
return retried(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _PreviousMonth value)  previousMonth,required TResult Function( _NextMonth value)  nextMonth,required TResult Function( _Retried value)  retried,required TResult Function( _ReportChanged value)  reportChanged,required TResult Function( _BudgetChanged value)  budgetChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _PreviousMonth():
return previousMonth(_that);case _NextMonth():
return nextMonth(_that);case _Retried():
return retried(_that);case _ReportChanged():
return reportChanged(_that);case _BudgetChanged():
return budgetChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _PreviousMonth value)?  previousMonth,TResult? Function( _NextMonth value)?  nextMonth,TResult? Function( _Retried value)?  retried,TResult? Function( _ReportChanged value)?  reportChanged,TResult? Function( _BudgetChanged value)?  budgetChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PreviousMonth() when previousMonth != null:
return previousMonth(_that);case _NextMonth() when nextMonth != null:
return nextMonth(_that);case _Retried() when retried != null:
return retried(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  previousMonth,TResult Function()?  nextMonth,TResult Function()?  retried,TResult Function( DateTime month,  MonthlyReport? report)?  reportChanged,TResult Function( DateTime month,  Budget? budget)?  budgetChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _PreviousMonth() when previousMonth != null:
return previousMonth();case _NextMonth() when nextMonth != null:
return nextMonth();case _Retried() when retried != null:
return retried();case _ReportChanged() when reportChanged != null:
return reportChanged(_that.month,_that.report);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that.month,_that.budget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  previousMonth,required TResult Function()  nextMonth,required TResult Function()  retried,required TResult Function( DateTime month,  MonthlyReport? report)  reportChanged,required TResult Function( DateTime month,  Budget? budget)  budgetChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _PreviousMonth():
return previousMonth();case _NextMonth():
return nextMonth();case _Retried():
return retried();case _ReportChanged():
return reportChanged(_that.month,_that.report);case _BudgetChanged():
return budgetChanged(_that.month,_that.budget);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  previousMonth,TResult? Function()?  nextMonth,TResult? Function()?  retried,TResult? Function( DateTime month,  MonthlyReport? report)?  reportChanged,TResult? Function( DateTime month,  Budget? budget)?  budgetChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _PreviousMonth() when previousMonth != null:
return previousMonth();case _NextMonth() when nextMonth != null:
return nextMonth();case _Retried() when retried != null:
return retried();case _ReportChanged() when reportChanged != null:
return reportChanged(_that.month,_that.report);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that.month,_that.budget);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ReportEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReportEvent.started()';
}


}




/// @nodoc


class _PreviousMonth implements ReportEvent {
  const _PreviousMonth();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousMonth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReportEvent.previousMonth()';
}


}




/// @nodoc


class _NextMonth implements ReportEvent {
  const _NextMonth();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextMonth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReportEvent.nextMonth()';
}


}




/// @nodoc


class _Retried implements ReportEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReportEvent.retried()';
}


}




/// @nodoc


class _ReportChanged implements ReportEvent {
  const _ReportChanged(this.month, this.report);
  

 final  DateTime month;
 final  MonthlyReport? report;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportChangedCopyWith<_ReportChanged> get copyWith => __$ReportChangedCopyWithImpl<_ReportChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportChanged&&(identical(other.month, month) || other.month == month)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,report);
}

@override
String toString() {
    return 'ReportEvent.reportChanged(month: $month, report: $report)';
}


}

/// @nodoc
abstract mixin class _$ReportChangedCopyWith<$Res> implements $ReportEventCopyWith<$Res> {
  factory _$ReportChangedCopyWith(_ReportChanged value, $Res Function(_ReportChanged) _then) = __$ReportChangedCopyWithImpl;
@useResult
$Res call({
 DateTime month, MonthlyReport? report
});


$MonthlyReportCopyWith<$Res>? get report;

}
/// @nodoc
class __$ReportChangedCopyWithImpl<$Res>
    implements _$ReportChangedCopyWith<$Res> {
  __$ReportChangedCopyWithImpl(this._self, this._then);

  final _ReportChanged _self;
  final $Res Function(_ReportChanged) _then;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? month = null,Object? report = freezed,}) {
  return _then(_ReportChanged(
null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,
  ));
}

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _BudgetChanged implements ReportEvent {
  const _BudgetChanged(this.month, this.budget);
  

 final  DateTime month;
 final  Budget? budget;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetChangedCopyWith<_BudgetChanged> get copyWith => __$BudgetChangedCopyWithImpl<_BudgetChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetChanged&&(identical(other.month, month) || other.month == month)&&(identical(other.budget, budget) || other.budget == budget));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,budget);
}

@override
String toString() {
    return 'ReportEvent.budgetChanged(month: $month, budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$BudgetChangedCopyWith<$Res> implements $ReportEventCopyWith<$Res> {
  factory _$BudgetChangedCopyWith(_BudgetChanged value, $Res Function(_BudgetChanged) _then) = __$BudgetChangedCopyWithImpl;
@useResult
$Res call({
 DateTime month, Budget? budget
});


$BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class __$BudgetChangedCopyWithImpl<$Res>
    implements _$BudgetChangedCopyWith<$Res> {
  __$BudgetChangedCopyWithImpl(this._self, this._then);

  final _BudgetChanged _self;
  final $Res Function(_BudgetChanged) _then;

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? month = null,Object? budget = freezed,}) {
  return _then(_BudgetChanged(
null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,
  ));
}

/// Create a copy of ReportEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get budget {
    if (_self.budget == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.budget!, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}

/// @nodoc
mixin _$ReportState {

/// The first of the shown month.
 DateTime get month;/// The first of this month: the latest month the report shows.
 DateTime get currentMonth;/// [UiStatus.loading] while a month without a saved report loads,
/// [UiStatus.failure] when it couldn't be, otherwise
/// [UiStatus.success].
 UiStatus get status;/// The month's report; null until loaded.
 MonthlyReport? get report;/// The month's budget; null when none is set.
 Budget? get budget;/// Why the report couldn't be loaded.
 ReportFailure? get loadFailure;/// Why a saved report couldn't be refreshed; shown once as a snackbar.
 ReportFailure? get refreshFailure;
/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportStateCopyWith<ReportState> get copyWith => _$ReportStateCopyWithImpl<ReportState>(this as ReportState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportState&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.currentMonth, _this.currentMonth) || other.currentMonth == _this.currentMonth)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.report, _this.report) || other.report == _this.report)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.refreshFailure, _this.refreshFailure) || other.refreshFailure == _this.refreshFailure));
}


@override
int get hashCode {
  final _this = this as ReportState;
  return Object.hash(runtimeType,_this.month,_this.currentMonth,_this.status,_this.report,_this.budget,_this.loadFailure,_this.refreshFailure);
}

@override
String toString() {
  final _this = this as ReportState;
  return 'ReportState(month: ${_this.month}, currentMonth: ${_this.currentMonth}, status: ${_this.status}, report: ${_this.report}, budget: ${_this.budget}, loadFailure: ${_this.loadFailure}, refreshFailure: ${_this.refreshFailure})';
}


}

/// @nodoc
abstract mixin class $ReportStateCopyWith<$Res>  {
  factory $ReportStateCopyWith(ReportState value, $Res Function(ReportState) _then) = _$ReportStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, DateTime currentMonth, UiStatus status, MonthlyReport? report, Budget? budget, ReportFailure? loadFailure, ReportFailure? refreshFailure
});


$MonthlyReportCopyWith<$Res>? get report;$BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class _$ReportStateCopyWithImpl<$Res>
    implements $ReportStateCopyWith<$Res> {
  _$ReportStateCopyWithImpl(this._self, this._then);

  final ReportState _self;
  final $Res Function(ReportState) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? currentMonth = null,Object? status = null,Object? report = freezed,Object? budget = freezed,Object? loadFailure = freezed,Object? refreshFailure = freezed,}) {
  return _then(ReportState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as ReportFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as ReportFailure?,
  ));
}
/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get budget {
    if (_self.budget == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.budget!, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportState].
extension ReportStatePatterns on ReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportState value)  $default,){
final _that = this;
switch (_that) {
case _ReportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  DateTime currentMonth,  UiStatus status,  MonthlyReport? report,  Budget? budget,  ReportFailure? loadFailure,  ReportFailure? refreshFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportState() when $default != null:
return $default(_that.month,_that.currentMonth,_that.status,_that.report,_that.budget,_that.loadFailure,_that.refreshFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  DateTime currentMonth,  UiStatus status,  MonthlyReport? report,  Budget? budget,  ReportFailure? loadFailure,  ReportFailure? refreshFailure)  $default,) {final _that = this;
switch (_that) {
case _ReportState():
return $default(_that.month,_that.currentMonth,_that.status,_that.report,_that.budget,_that.loadFailure,_that.refreshFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  DateTime currentMonth,  UiStatus status,  MonthlyReport? report,  Budget? budget,  ReportFailure? loadFailure,  ReportFailure? refreshFailure)?  $default,) {final _that = this;
switch (_that) {
case _ReportState() when $default != null:
return $default(_that.month,_that.currentMonth,_that.status,_that.report,_that.budget,_that.loadFailure,_that.refreshFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ReportState implements ReportState {
  const _ReportState({required this.month, required this.currentMonth, this.status = UiStatus.initial, this.report, this.budget, this.loadFailure, this.refreshFailure});
  

/// The first of the shown month.
@override final  DateTime month;
/// The first of this month: the latest month the report shows.
@override final  DateTime currentMonth;
/// [UiStatus.loading] while a month without a saved report loads,
/// [UiStatus.failure] when it couldn't be, otherwise
/// [UiStatus.success].
@override@JsonKey() final  UiStatus status;
/// The month's report; null until loaded.
@override final  MonthlyReport? report;
/// The month's budget; null when none is set.
@override final  Budget? budget;
/// Why the report couldn't be loaded.
@override final  ReportFailure? loadFailure;
/// Why a saved report couldn't be refreshed; shown once as a snackbar.
@override final  ReportFailure? refreshFailure;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportStateCopyWith<_ReportState> get copyWith => __$ReportStateCopyWithImpl<_ReportState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportState&&(identical(other.month, month) || other.month == month)&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.status, status) || other.status == status)&&(identical(other.report, report) || other.report == report)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.refreshFailure, refreshFailure) || other.refreshFailure == refreshFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,currentMonth,status,report,budget,loadFailure,refreshFailure);
}

@override
String toString() {
    return 'ReportState(month: $month, currentMonth: $currentMonth, status: $status, report: $report, budget: $budget, loadFailure: $loadFailure, refreshFailure: $refreshFailure)';
}


}

/// @nodoc
abstract mixin class _$ReportStateCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$ReportStateCopyWith(_ReportState value, $Res Function(_ReportState) _then) = __$ReportStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, DateTime currentMonth, UiStatus status, MonthlyReport? report, Budget? budget, ReportFailure? loadFailure, ReportFailure? refreshFailure
});


@override $MonthlyReportCopyWith<$Res>? get report;@override $BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class __$ReportStateCopyWithImpl<$Res>
    implements _$ReportStateCopyWith<$Res> {
  __$ReportStateCopyWithImpl(this._self, this._then);

  final _ReportState _self;
  final $Res Function(_ReportState) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? currentMonth = null,Object? status = null,Object? report = freezed,Object? budget = freezed,Object? loadFailure = freezed,Object? refreshFailure = freezed,}) {
  return _then(_ReportState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as ReportFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as ReportFailure?,
  ));
}

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res>? get budget {
    if (_self.budget == null) {
    return null;
  }

  return $BudgetCopyWith<$Res>(_self.budget!, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}

// dart format on
