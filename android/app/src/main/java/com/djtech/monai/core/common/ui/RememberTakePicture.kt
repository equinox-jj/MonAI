package com.djtech.monai.core.common.ui

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat
import androidx.core.net.toUri

/**
 * Takes a photo with the camera app into the given content uri and returns a launcher for it.
 * The app declares CAMERA (for receipt scanning), so Android refuses IMAGE_CAPTURE until it's
 * granted: the launcher asks first and calls [onDenied] if the user says no.
 *
 * @param onResult the uri once the photo is saved, or null if the user backed out.
 */
@Composable
fun rememberTakePicture(onDenied: () -> Unit, onResult: (String?) -> Unit): (String) -> Unit {
    val context = LocalContext.current
    val currentOnDenied by rememberUpdatedState(onDenied)
    val currentOnResult by rememberUpdatedState(onResult)
    // Kept across process death: the camera app may outlive this one.
    var pendingUri by rememberSaveable { mutableStateOf<String?>(null) }
    val camera = rememberLauncherForActivityResult(ActivityResultContracts.TakePicture()) { taken ->
        currentOnResult(pendingUri.takeIf { taken })
        pendingUri = null
    }
    val permission = rememberLauncherForActivityResult(ActivityResultContracts.RequestPermission()) { granted ->
        val uri = pendingUri
        when {
            uri == null -> Unit
            granted -> camera.launch(uri.toUri())
            else -> {
                pendingUri = null
                currentOnDenied()
            }
        }
    }
    return remember(context, camera, permission) {
        { uri ->
            pendingUri = uri
            val granted = ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) ==
                PackageManager.PERMISSION_GRANTED
            if (granted) camera.launch(uri.toUri()) else permission.launch(Manifest.permission.CAMERA)
        }
    }
}
