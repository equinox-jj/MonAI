package com.djtech.monai.receipt

import android.content.Context
import android.net.Uri
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

/**
 * Backs the Dart `MethodChannelReceiptScannerService`. Uses ML Kit's bundled Latin
 * recognizer: works offline, with no model download on first use.
 */
class ReceiptScannerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private lateinit var recognizer: TextRecognizer

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        recognizer.close()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "readText") return result.notImplemented()
        val path = call.argument<String>("path")
            ?: return result.error("invalid_argument", "Missing image path", null)

        val image = try {
            // Applies the photo's EXIF rotation, so sideways shots read the right way up.
            InputImage.fromFilePath(context, Uri.fromFile(File(path)))
        } catch (e: IOException) {
            return result.error("unreadable_image", e.message, null)
        }
        // ML Kit calls these listeners on the main thread, where results must be sent.
        recognizer.process(image)
            .addOnSuccessListener { result.success(it.text.ifBlank { null }) }
            .addOnFailureListener { result.error("recognition_failed", it.message, null) }
    }

    private companion object {
        const val CHANNEL = "com.djtech.monai/receipt_scanner"
    }
}
