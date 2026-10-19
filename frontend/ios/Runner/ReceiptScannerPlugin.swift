import Flutter
import UIKit
import Vision

/// Backs the Dart `MethodChannelReceiptScannerService` with Apple Vision's on-device
/// text recognition. The Android side uses ML Kit.
final class ReceiptScannerPlugin: NSObject, FlutterPlugin {
  private static let channelName = "com.djtech.monai/receipt_scanner"
  private static let preferredLanguages = ["id-ID", "en-US"]

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(ReceiptScannerPlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "readText" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard let args = call.arguments as? [String: Any], let path = args["path"] as? String else {
      result(FlutterError(code: "invalid_argument", message: "Missing image path", details: nil))
      return
    }
    guard let image = UIImage(contentsOfFile: path), let cgImage = image.cgImage else {
      result(FlutterError(code: "unreadable_image", message: "Could not open \(path)", details: nil))
      return
    }
    // Passing the orientation makes sideways shots read the right way up.
    let orientation = CGImagePropertyOrientation(image.imageOrientation)

    DispatchQueue.global(qos: .userInitiated).async {
      let request = VNRecognizeTextRequest()
      request.recognitionLevel = .accurate
      // Correction rewrites item abbreviations and Indonesian words into English ones.
      request.usesLanguageCorrection = false
      if let supported = try? request.supportedRecognitionLanguages() {
        let languages = Self.preferredLanguages.filter(supported.contains)
        if !languages.isEmpty { request.recognitionLanguages = languages }
      }

      do {
        try VNImageRequestHandler(cgImage: cgImage, orientation: orientation).perform([request])
        let text = (request.results ?? [])
          .compactMap { $0.topCandidates(1).first?.string }
          .joined(separator: "\n")
        DispatchQueue.main.async { result(text.isEmpty ? nil : text) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(
            code: "recognition_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
  }
}

private extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
    case .up: self = .up
    case .upMirrored: self = .upMirrored
    case .down: self = .down
    case .downMirrored: self = .downMirrored
    case .left: self = .left
    case .leftMirrored: self = .leftMirrored
    case .right: self = .right
    case .rightMirrored: self = .rightMirrored
    @unknown default: self = .up
    }
  }
}
