package com.djtech.monai.core.datastore

import javax.inject.Qualifier

/** The DataStore holding the encrypted access token; excluded from backup. */
@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class SessionPreferences

/** The DataStore for app flags that are not tied to a session, such as onboarding. */
@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class AppPreferences
