# ML Kit discovers its registrars by reflection through their no-arg constructors.
# Without this, R8 strips them and TextRecognition.getClient() crashes on startup.
-keep class * implements com.google.firebase.components.ComponentRegistrar {
    <init>();
}

# shared_preferences_android 2.5+ is called from Dart over JNI by method name and
# ships no keep rules, so R8 strips them and startup fails with NoSuchMethodError.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
# Kotlin classes the `jni` Dart package looks up by name to call suspend functions.
-keep class kotlin.Unit { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }
