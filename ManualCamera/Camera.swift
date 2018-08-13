//
//  Camera.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/11.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@objc protocol CameraDelegate: NSObjectProtocol {
    @objc optional func cameraWillSave(_ camera: Camera, photo: AVCapturePhoto) -> Data?
    @objc optional func cameraDidSave(_ camera: Camera, photo: AVCapturePhoto, savedImage: Data)
}

class Camera : NSObject {
    
    var captureSession: AVCaptureSession!
    var maxISO: Float!
    var minISO: Float!
    var maxExposureDuration: CMTime!
    var minExposureDuration: CMTime!
    var input: AVCaptureDeviceInput!
    var output: AVCapturePhotoOutput!
    var active: Bool = false
    weak var _delegate: CameraDelegate!
    
    static let CameraDidFinishAutoFocus = Notification.Name("CameraDidFinishAutoFocus")
    static let CameraDidFinishExposing = Notification.Name("CameraDidFinishExposing")
    
    override init() {
        super.init()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        captureSession.beginConfiguration()
        
        let discoverSession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverSession.devices
        guard let camera = devices.first else { return }
        
        camera.addObserver(self, forKeyPath: "adjustingFocus", options: [.new], context: nil)
        camera.addObserver(self, forKeyPath: "adjustingExposure", options: [.new], context: nil)

        maxISO = camera.activeFormat.maxISO
        minISO = camera.activeFormat.minISO
        maxExposureDuration = camera.activeFormat.maxExposureDuration
        minExposureDuration = camera.activeFormat.minExposureDuration
        do {
            self.input = try AVCaptureDeviceInput(device: camera)
            if self.captureSession.canAddInput(self.input) {
                self.captureSession.addInput(self.input)
                self.active = true
            }
        } catch {
            active = false
            print(error)
        }
        
        output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        captureSession.commitConfiguration()
        
    }

    var focusing: Bool = false
    var expososing: Bool = false
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let key = keyPath, let changes = change else {
            return
        }
        
        if key == "adjustingFocus" {
            let adjustingFocus = changes[.newKey]
            if (adjustingFocus! as! Bool) {
                focusing = true
            } else {
                focusing = false
                NotificationCenter.default.post(name: Camera.CameraDidFinishAutoFocus, object: self)
            }
        } else if key == "adjustingExposure" {
            let adjustingExposure = changes[.newKey]
            if (adjustingExposure! as! Bool) {
                expososing = true
            } else {
                expososing = false
                NotificationCenter.default.post(name: Camera.CameraDidFinishExposing, object: self)
            }
        }
    }
    
    func start() {
        captureSession.startRunning()
    }
    
    func stop() {
        captureSession.stopRunning()
    }
    
    func setDelegate(_ delegate: CameraDelegate) {
        _delegate = delegate
    }
    
    func enableLowLightBoost(_ flag: Bool) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            try camera.lockForConfiguration()
            if camera.isLowLightBoostSupported {
                camera.automaticallyEnablesLowLightBoostWhenAvailable = flag
            }
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func autoFocus(at point: CGPoint) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            try camera.lockForConfiguration()
            if camera.isFocusModeSupported(.autoFocus) && camera.isFocusPointOfInterestSupported {
                focusing = true
                camera.focusPointOfInterest = point
                camera.focusMode = .autoFocus
            }
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func manualFocus(lensPosition: Float, completionHandler handler: @escaping() -> (Swift.Void)) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            if camera.isFocusModeSupported(.locked) {
                focusing = false
                try camera.lockForConfiguration()
                camera.setFocusModeLocked(lensPosition: lensPosition) { (time) in
                    camera.unlockForConfiguration()
                    handler()
                }
            } else {
                handler()
            }
        } catch {
            print(error)
            handler()
        }
    }
    
    func setAutoWhiteBalance() {
        _setWhiteBalanceMode(.autoWhiteBalance)
    }
    
    func setContinuousAutoWhiteBalance() {
        _setWhiteBalanceMode(.continuousAutoWhiteBalance)
    }
    
    func setWhiteBalance(gains: AVCaptureDevice.WhiteBalanceGains, completionHandler handler: @escaping() -> (Swift.Void)) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            if camera.isWhiteBalanceModeSupported(.locked) {
                try camera.lockForConfiguration()
                camera.setWhiteBalanceModeLocked(with: gains) { (time) in
                    camera.unlockForConfiguration()
                    handler()
                }
            } else {
                handler()
            }
        } catch {
            print(error)
            handler()
        }
    }
    
    func setAutoExposure() {
        _setExposureMode(.autoExpose)
    }
    
    func setContinuousAutoExposure() {
        _setExposureMode(.continuousAutoExposure)
    }
    
    func setExposureModeCustom(exposureDuration: CMTime, iso: Float, complationHandler handler: @escaping() -> (Swift.Void)) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            if camera.isFocusModeSupported(.locked) {
                try camera.lockForConfiguration()
                camera.setExposureModeCustom(duration: exposureDuration, iso: iso) { (time) in
                    camera.unlockForConfiguration()
                    handler()
                }
            } else {
                handler()
            }
        } catch {
            print(error)
            handler()
        }
    }
    
    func takePhoto(flashMode: AVCaptureDevice.FlashMode, orientation: AVCaptureVideoOrientation) {
        let setting = AVCapturePhotoSettings()
        setting.flashMode = flashMode
        if let conn = output.connection(with: .video) {
            if conn.isVideoOrientationSupported {
                conn.videoOrientation = orientation
            }
        }
        if output.isStillImageStabilizationSupported {
            setting.isAutoStillImageStabilizationEnabled = true
        }
        if output.isHighResolutionCaptureEnabled {
            setting.isHighResolutionPhotoEnabled = true
        }
        
        output.capturePhoto(with: setting, delegate: self)
    }
    
    func _setWhiteBalanceMode(_ mode: AVCaptureDevice.WhiteBalanceMode) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            try camera.lockForConfiguration()
            if camera.isWhiteBalanceModeSupported(mode) {
                camera.whiteBalanceMode = mode
            }
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    private func _setExposureMode(_ mode: AVCaptureDevice.ExposureMode) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            try camera.lockForConfiguration()
            if camera.isExposureModeSupported(mode) {
                camera.exposureMode = mode
            }
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func lensPosition() -> Float {
        return input.device.lensPosition
    }
    
    var oldZoomScale: CGFloat = 1.0
    func zoom(_ zoomScale: CGFloat, end: Bool, complationHandler handler: @escaping(_ : CGFloat) -> (Swift.Void)) {
        guard let cameraInput = input else { return }
        let camera = cameraInput.device
        do {
            try camera.lockForConfiguration()
            let maxZoomScale: CGFloat = 6.0
            let minZoomScale: CGFloat = 1.0
            var currentZoomScale: CGFloat = camera.videoZoomFactor
            
            if zoomScale > 1.0 {
                currentZoomScale = oldZoomScale + zoomScale - 1
            } else {
                currentZoomScale = oldZoomScale - (1 - zoomScale) * oldZoomScale
            }
            
            if currentZoomScale < minZoomScale {
                currentZoomScale = minZoomScale
            } else if currentZoomScale > maxZoomScale {
                currentZoomScale = maxZoomScale
            }
            
            if end {
                oldZoomScale = currentZoomScale
            }
            
            camera.videoZoomFactor = currentZoomScale
            camera.unlockForConfiguration()
            handler(oldZoomScale)
        } catch {
            print(error)
        }
    }
    
    func zoomFactor() -> CGFloat {
        guard let cameraInput = input else { return oldZoomScale }
        let camera = cameraInput.device
        return camera.videoZoomFactor
    }
    
    private func exposureDurationIndex(_ duration: CMTime) -> Int {
        for i in 0...CameraConstants.ExposureDurationValues.count-2 {
            if CMTimeCompare(duration, CameraConstants.ExposureDurationValues[i]) == 0 {
                return i
            } else if CMTimeCompare(duration, CameraConstants.ExposureDurationValues[i+1]) == 0 {
                return i+1
            } else if CMTimeCompare(duration, CameraConstants.ExposureDurationValues[i]) == 1 && CMTimeCompare(duration, CameraConstants.ExposureDurationValues[i+1]) == -1 {
                return i
            }
        }
        return -1
    }
    
    private func isoIndex(_ iso: Float) -> Int {
        for i in 0...CameraConstants.IsoValues.count-2 {
            if iso == CameraConstants.IsoValues[i] {
                return i
            } else if iso == CameraConstants.IsoValues[i+1] {
                return i+1
            } else if iso > CameraConstants.IsoValues[i] && iso < CameraConstants.IsoValues[i+1] {
                return i
            }
        }
        return -1
    }
    
    func exposureDuration() -> CMTime {
        guard let cameraInput = input else { return CameraConstants.ExposureDurationValues[0] }
        let camera = cameraInput.device
        let duration = camera.exposureDuration
        let index = exposureDurationIndex(duration)
        if index >= 0 {
            return CameraConstants.ExposureDurationValues[index]
        }
        return CameraConstants.ExposureDurationValues[0]
    }
    
    func exposureDurationLabel() -> String {
        guard let cameraInput = input else { return CameraConstants.ExposureDurationLabels[0] }
        let camera = cameraInput.device
        let duration = camera.exposureDuration
        let index = exposureDurationIndex(duration)
        if index >= 0 {
            return CameraConstants.ExposureDurationLabels[index]
        }
        return CameraConstants.ExposureDurationLabels[0]
    }
    
    func iso() -> Float {
        guard let cameraInput = input else { return CameraConstants.IsoValues[0] }
        let camera = cameraInput.device
        let iso = camera.iso
        let index = isoIndex(iso)
        if index >= 0 {
            return CameraConstants.IsoValues[index]
        }
        return CameraConstants.IsoValues[0]
    }
    
    func exposureTargetOffset() -> Float {
        guard let cameraInput = input else { return 0 }
        let camera = cameraInput.device
        return camera.exposureTargetOffset
    }
    
    func exposureTargetBias() -> Float {
        guard let cameraInput = input else { return 0 }
        let camera = cameraInput.device
        return camera.exposureTargetBias
    }
    
    func whiteBalanceGains() -> AVCaptureDevice.WhiteBalanceGains? {
        guard let cameraInput = input else { return nil }
        let camera = cameraInput.device
        return camera.deviceWhiteBalanceGains
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        var image: Data!
        if _delegate != nil && _delegate.responds(to: #selector(CameraDelegate.cameraWillSave(_:photo:))) {
            image = _delegate.cameraWillSave!(self, photo: photo)
        } else {
            image = imageData
        }
        if image == nil { return }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: image, options: nil)
        }) { (success, failure) in
            if success {
                print("Photo saved")
                if self._delegate != nil && self._delegate.responds(to: #selector(CameraDelegate.cameraDidSave(_:photo:savedImage:))) {
                    self._delegate.cameraDidSave!(self, photo: photo, savedImage: image)
                }
            } else {
                print("Could not save photo: \(String(describing: failure))")
            }
        }
    }

}
