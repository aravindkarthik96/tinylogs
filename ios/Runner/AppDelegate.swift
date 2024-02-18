import UIKit
import Flutter
import Foundation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupMethodChannel()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        methodChannel = FlutterMethodChannel(name: "com.tinylogs.app/backup",
                                             binaryMessenger: controller.binaryMessenger)
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            guard call.method == "backupData" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.backupDataToiCloud(arguments: call.arguments, result: result)
        }
    }
    
    private func backupDataToiCloud(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let filePath = args["filePath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments received from Flutter", details: nil))
            return
        }
        
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            result(FlutterError(code: "ICLOUD_NOT_AVAILABLE", message: "iCloud is not available or not enabled", details: nil))
            return
        }
        
        if !FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                result(FlutterError(code: "ICLOUD_DIRECTORY_CREATION_FAILED", message: "Failed to create iCloud directory", details: error.localizedDescription))
                return
            }
        }
        
        let localFileURL = URL(fileURLWithPath: filePath)
        let iCloudFileURL = iCloudDocumentsURL.appendingPathComponent(localFileURL.lastPathComponent)
        
        do {
            if FileManager.default.fileExists(atPath: iCloudFileURL.path) {
                try FileManager.default.removeItem(at: iCloudFileURL)
            }
            try FileManager.default.copyItem(at: localFileURL, to: iCloudFileURL)
            result(true) // Success
        } catch {
            result(FlutterError(code: "ICLOUD_BACKUP_FAILED", message: "Failed to back up data to iCloud", details: error.localizedDescription))
        }
    }
}
