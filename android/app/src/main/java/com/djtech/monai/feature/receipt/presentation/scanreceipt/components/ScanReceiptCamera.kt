package com.djtech.monai.feature.receipt.presentation.scanreceipt.components

import android.content.Context
import androidx.camera.compose.CameraXViewfinder
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.Preview
import androidx.camera.core.SurfaceRequest
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.lifecycle.awaitInstance
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat
import androidx.core.net.toUri
import androidx.lifecycle.compose.LocalLifecycleOwner
import kotlinx.coroutines.awaitCancellation

/** The back camera's live preview, bound with [imageCapture] while this is on screen. */
@Composable
internal fun ScanReceiptCamera(imageCapture: ImageCapture, modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    var surfaceRequest by remember { mutableStateOf<SurfaceRequest?>(null) }
    LaunchedEffect(lifecycleOwner, imageCapture) {
        val provider = ProcessCameraProvider.awaitInstance(context)
        val preview = Preview.Builder().build().apply { setSurfaceProvider { surfaceRequest = it } }
        provider.unbindAll()
        provider.bindToLifecycle(lifecycleOwner, CameraSelector.DEFAULT_BACK_CAMERA, preview, imageCapture)
        try {
            awaitCancellation()
        } finally {
            provider.unbindAll()
        }
    }
    surfaceRequest?.let { CameraXViewfinder(surfaceRequest = it, modifier = modifier) }
}

/** Saves the next photo to [uri] (a FileProvider URI), then reports whether it worked. */
internal fun ImageCapture.takePhotoTo(context: Context, uri: String, onDone: (saved: Boolean) -> Unit) {
    val stream = context.contentResolver.openOutputStream(uri.toUri())
    if (stream == null) {
        onDone(false)
        return
    }
    takePicture(
        ImageCapture.OutputFileOptions.Builder(stream).build(),
        ContextCompat.getMainExecutor(context),
        object : ImageCapture.OnImageSavedCallback {
            override fun onImageSaved(output: ImageCapture.OutputFileResults) {
                stream.close()
                onDone(true)
            }

            override fun onError(exception: ImageCaptureException) {
                stream.close()
                onDone(false)
            }
        },
    )
}
