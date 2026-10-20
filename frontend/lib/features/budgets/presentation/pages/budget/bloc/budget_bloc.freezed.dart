// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BudgetEvent()';
}


}

/// @nodoc
class $BudgetEventCopyWith<$Res>  {
$BudgetEventCopyWith(BudgetEvent _, $Res Function(BudgetEvent) __);
}


/// Adds pattern-matching-related methods to [BudgetEvent].
extension BudgetEventPatterns on BudgetEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _LimitEdited value)?  limitEdited,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _BudgetChanged value)?  budgetChanged,TResult Function( _ReportChanged value)?  reportChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _LimitEdited() when limitEdited != null:
return limitEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _LimitEdited value)  limitEdited,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _BudgetChanged value)  budgetChanged,required TResult Function( _ReportChanged value)  reportChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _LimitEdited():
return limitEdited(_that);case _SaveRequested():
return saveRequested(_that);case _DeleteRequested():
return deleteRequested(_that);case _BudgetChanged():
return budgetChanged(_that);case _ReportChanged():
return reportChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _LimitEdited value)?  limitEdited,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _BudgetChanged value)?  budgetChanged,TResult? Function( _ReportChanged value)?  reportChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _LimitEdited() when limitEdited != null:
return limitEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String limit)?  limitEdited,TResult Function( String limit)?  saveRequested,TResult Function()?  deleteRequested,TResult Function( Budget? budget)?  budgetChanged,TResult Function( MonthlyReport? report)?  reportChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _LimitEdited() when limitEdited != null:
return limitEdited(_that.limit);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.limit);case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that.budget);case _ReportChanged() when reportChanged != null:
return reportChanged(_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String limit)  limitEdited,required TResult Function( String limit)  saveRequested,required TResult Function()  deleteRequested,required TResult Function( Budget? budget)  budgetChanged,required TResult Function( MonthlyReport? report)  reportChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _LimitEdited():
return limitEdited(_that.limit);case _SaveRequested():
return saveRequested(_that.limit);case _DeleteRequested():
return deleteRequested();case _BudgetChanged():
return budgetChanged(_that.budget);case _ReportChanged():
return reportChanged(_that.report);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String limit)?  limitEdited,TResult? Function( String limit)?  saveRequested,TResult? Function()?  deleteRequested,TResult? Function( Budget? budget)?  budgetChanged,TResult? Function( MonthlyReport? report)?  reportChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _LimitEdited() when limitEdited != null:
return limitEdited(_that.limit);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.limit);case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _BudgetChanged() when budgetChanged != null:
return budgetChanged(_that.budget);case _ReportChanged() when reportChanged != null:
return reportChanged(_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BudgetEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BudgetEvent.started()';
}


}




/// @nodoc


class _LimitEdited implements BudgetEvent {
  const _LimitEdited(this.limit);
  

 final  String limit;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LimitEditedCopyWith<_LimitEdited> get copyWith => __$LimitEditedCopyWithImpl<_LimitEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LimitEdited&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,limit);
}

@override
String toString() {
    return 'BudgetEvent.limitEdited(limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$LimitEditedCopyWith<$Res> implements $BudgetEventCopyWith<$Res> {
  factory _$LimitEditedCopyWith(_LimitEdited value, $Res Function(_LimitEdited) _then) = __$LimitEditedCopyWithImpl;
@useResult
$Res call({
 String limit
});




}
/// @nodoc
class __$LimitEditedCopyWithImpl<$Res>
    implements _$LimitEditedCopyWith<$Res> {
  __$LimitEditedCopyWithImpl(this._self, this._then);

  final _LimitEdited _self;
  final $Res Function(_LimitEdited) _then;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? limit = null,}) {
  return _then(_LimitEdited(
null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested implements BudgetEvent {
  const _SaveRequested(this.limit);
  

 final  String limit;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,limit);
}

@override
String toString() {
    return 'BudgetEvent.saveRequested(limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $BudgetEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String limit
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? limit = null,}) {
  return _then(_SaveRequested(
null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteRequested implements BudgetEvent {
  const _DeleteRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BudgetEvent.deleteRequested()';
}


}




/// @nodoc


class _BudgetChanged implements BudgetEvent {
  const _BudgetChanged(this.budget);
  

 final  Budget? budget;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetChangedCopyWith<_BudgetChanged> get copyWith => __$BudgetChangedCopyWithImpl<_BudgetChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetChanged&&(identical(other.budget, budget) || other.budget == budget));
}


@override
int get hashCode {
    return Object.hash(runtimeType,budget);
}

@override
String toString() {
    return 'BudgetEvent.budgetChanged(budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$BudgetChangedCopyWith<$Res> implements $BudgetEventCopyWith<$Res> {
  factory _$BudgetChangedCopyWith(_BudgetChanged value, $Res Function(_BudgetChanged) _then) = __$BudgetChangedCopyWithImpl;
@useResult
$Res call({
 Budget? budget
});


$BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class __$BudgetChangedCopyWithImpl<$Res>
    implements _$BudgetChangedCopyWith<$Res> {
  __$BudgetChangedCopyWithImpl(this._self, this._then);

  final _BudgetChanged _self;
  final $Res Function(_BudgetChanged) _then;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? budget = freezed,}) {
  return _then(_BudgetChanged(
freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,
  ));
}

/// Create a copy of BudgetEvent
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


class _ReportChanged implements BudgetEvent {
  const _ReportChanged(this.report);
  

 final  MonthlyReport? report;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportChangedCopyWith<_ReportChanged> get copyWith => __$ReportChangedCopyWithImpl<_ReportChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportChanged&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,report);
}

@override
String toString() {
    return 'BudgetEvent.reportChanged(report: $report)';
}


}

/// @nodoc
abstract mixin class _$ReportChangedCopyWith<$Res> implements $BudgetEventCopyWith<$Res> {
  factory _$ReportChangedCopyWith(_ReportChanged value, $Res Function(_ReportChanged) _then) = __$ReportChangedCopyWithImpl;
@useResult
$Res call({
 MonthlyReport? report
});


$MonthlyReportCopyWith<$Res>? get report;

}
/// @nodoc
class __$ReportChangedCopyWithImpl<$Res>
    implements _$ReportChangedCopyWith<$Res> {
  __$ReportChangedCopyWithImpl(this._self, this._then);

  final _ReportChanged _self;
  final $Res Function(_ReportChanged) _then;

/// Create a copy of BudgetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = freezed,}) {
  return _then(_ReportChanged(
freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,
  ));
}

/// Create a copy of BudgetEvent
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
mixin _$BudgetState {

/// The first of the month.
 DateTime get month;/// The saved budget; null when the month has none.
 Budget? get budget;/// The month's spending from the report, for a month without a budget.
 int? get reportSpent;/// The limit in the field, in rupiah; 0 when empty.
 int get limit;/// The user changed the limit: a budget loading late no longer fills it.
 bool get limitTouched;/// The limit's error, shown under the field.
 FieldError? get limitError;/// A save failed on the limit, so its error updates as the user types.
 bool get autovalidate; bool get isSaving; bool get isDeleting;/// Set once saved or removed; the screen closes.
 BudgetOutcome? get outcome;/// Why a save or remove failed; shown once as a snackbar.
 BudgetFailure? get actionFailure;
/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetStateCopyWith<BudgetState> get copyWith => _$BudgetStateCopyWithImpl<BudgetState>(this as BudgetState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BudgetState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetState&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.reportSpent, _this.reportSpent) || other.reportSpent == _this.reportSpent)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.limitTouched, _this.limitTouched) || other.limitTouched == _this.limitTouched)&&(identical(other.limitError, _this.limitError) || other.limitError == _this.limitError)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as BudgetState;
  return Object.hash(runtimeType,_this.month,_this.budget,_this.reportSpent,_this.limit,_this.limitTouched,_this.limitError,_this.autovalidate,_this.isSaving,_this.isDeleting,_this.outcome,_this.actionFailure);
}

@override
String toString() {
  final _this = this as BudgetState;
  return 'BudgetState(month: ${_this.month}, budget: ${_this.budget}, reportSpent: ${_this.reportSpent}, limit: ${_this.limit}, limitTouched: ${_this.limitTouched}, limitError: ${_this.limitError}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, isDeleting: ${_this.isDeleting}, outcome: ${_this.outcome}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $BudgetStateCopyWith<$Res>  {
  factory $BudgetStateCopyWith(BudgetState value, $Res Function(BudgetState) _then) = _$BudgetStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, Budget? budget, int? reportSpent, int limit, bool limitTouched, FieldError? limitError, bool autovalidate, bool isSaving, bool isDeleting, BudgetOutcome? outcome, BudgetFailure? actionFailure
});


$BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class _$BudgetStateCopyWithImpl<$Res>
    implements $BudgetStateCopyWith<$Res> {
  _$BudgetStateCopyWithImpl(this._self, this._then);

  final BudgetState _self;
  final $Res Function(BudgetState) _then;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? budget = freezed,Object? reportSpent = freezed,Object? limit = null,Object? limitTouched = null,Object? limitError = freezed,Object? autovalidate = null,Object? isSaving = null,Object? isDeleting = null,Object? outcome = freezed,Object? actionFailure = freezed,}) {
  return _then(BudgetState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,reportSpent: freezed == reportSpent ? _self.reportSpent : reportSpent // ignore: cast_nullable_to_non_nullable
as int?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,limitTouched: null == limitTouched ? _self.limitTouched : limitTouched // ignore: cast_nullable_to_non_nullable
as bool,limitError: freezed == limitError ? _self.limitError : limitError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as BudgetOutcome?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as BudgetFailure?,
  ));
}
/// Create a copy of BudgetState
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


/// Adds pattern-matching-related methods to [BudgetState].
extension BudgetStatePatterns on BudgetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetState value)  $default,){
final _that = this;
switch (_that) {
case _BudgetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetState value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  Budget? budget,  int? reportSpent,  int limit,  bool limitTouched,  FieldError? limitError,  bool autovalidate,  bool isSaving,  bool isDeleting,  BudgetOutcome? outcome,  BudgetFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetState() when $default != null:
return $default(_that.month,_that.budget,_that.reportSpent,_that.limit,_that.limitTouched,_that.limitError,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.outcome,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  Budget? budget,  int? reportSpent,  int limit,  bool limitTouched,  FieldError? limitError,  bool autovalidate,  bool isSaving,  bool isDeleting,  BudgetOutcome? outcome,  BudgetFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _BudgetState():
return $default(_that.month,_that.budget,_that.reportSpent,_that.limit,_that.limitTouched,_that.limitError,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.outcome,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  Budget? budget,  int? reportSpent,  int limit,  bool limitTouched,  FieldError? limitError,  bool autovalidate,  bool isSaving,  bool isDeleting,  BudgetOutcome? outcome,  BudgetFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _BudgetState() when $default != null:
return $default(_that.month,_that.budget,_that.reportSpent,_that.limit,_that.limitTouched,_that.limitError,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.outcome,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetState implements BudgetState {
  const _BudgetState({required this.month, this.budget, this.reportSpent, this.limit = 0, this.limitTouched = false, this.limitError, this.autovalidate = false, this.isSaving = false, this.isDeleting = false, this.outcome, this.actionFailure});
  

/// The first of the month.
@override final  DateTime month;
/// The saved budget; null when the month has none.
@override final  Budget? budget;
/// The month's spending from the report, for a month without a budget.
@override final  int? reportSpent;
/// The limit in the field, in rupiah; 0 when empty.
@override@JsonKey() final  int limit;
/// The user changed the limit: a budget loading late no longer fills it.
@override@JsonKey() final  bool limitTouched;
/// The limit's error, shown under the field.
@override final  FieldError? limitError;
/// A save failed on the limit, so its error updates as the user types.
@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isDeleting;
/// Set once saved or removed; the screen closes.
@override final  BudgetOutcome? outcome;
/// Why a save or remove failed; shown once as a snackbar.
@override final  BudgetFailure? actionFailure;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetStateCopyWith<_BudgetState> get copyWith => __$BudgetStateCopyWithImpl<_BudgetState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetState&&(identical(other.month, month) || other.month == month)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.reportSpent, reportSpent) || other.reportSpent == reportSpent)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.limitTouched, limitTouched) || other.limitTouched == limitTouched)&&(identical(other.limitError, limitError) || other.limitError == limitError)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,budget,reportSpent,limit,limitTouched,limitError,autovalidate,isSaving,isDeleting,outcome,actionFailure);
}

@override
String toString() {
    return 'BudgetState(month: $month, budget: $budget, reportSpent: $reportSpent, limit: $limit, limitTouched: $limitTouched, limitError: $limitError, autovalidate: $autovalidate, isSaving: $isSaving, isDeleting: $isDeleting, outcome: $outcome, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$BudgetStateCopyWith<$Res> implements $BudgetStateCopyWith<$Res> {
  factory _$BudgetStateCopyWith(_BudgetState value, $Res Function(_BudgetState) _then) = __$BudgetStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, Budget? budget, int? reportSpent, int limit, bool limitTouched, FieldError? limitError, bool autovalidate, bool isSaving, bool isDeleting, BudgetOutcome? outcome, BudgetFailure? actionFailure
});


@override $BudgetCopyWith<$Res>? get budget;

}
/// @nodoc
class __$BudgetStateCopyWithImpl<$Res>
    implements _$BudgetStateCopyWith<$Res> {
  __$BudgetStateCopyWithImpl(this._self, this._then);

  final _BudgetState _self;
  final $Res Function(_BudgetState) _then;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? budget = freezed,Object? reportSpent = freezed,Object? limit = null,Object? limitTouched = null,Object? limitError = freezed,Object? autovalidate = null,Object? isSaving = null,Object? isDeleting = null,Object? outcome = freezed,Object? actionFailure = freezed,}) {
  return _then(_BudgetState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget?,reportSpent: freezed == reportSpent ? _self.reportSpent : reportSpent // ignore: cast_nullable_to_non_nullable
as int?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,limitTouched: null == limitTouched ? _self.limitTouched : limitTouched // ignore: cast_nullable_to_non_nullable
as bool,limitError: freezed == limitError ? _self.limitError : limitError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as BudgetOutcome?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as BudgetFailure?,
  ));
}

/// Create a copy of BudgetState
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
