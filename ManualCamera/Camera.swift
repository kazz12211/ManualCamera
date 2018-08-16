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
    @objc optional func cameraWillSavePhoto(_ camera: Camera, photo: AVCapturePhoto) -> Data?
    @objc optional func cameraDidSavePhoto(_ camera: Camera, photo: AVCapturePhoto, savedImage: Data)
    @objc optional func cameraDidFinishFocusing(_ camera: Camera, device: AVCaptureDevice)
    @objc optional func cameraDidFinishExposing(_ camera: Camera, device: AVCaptureDevice)
    @objc optional func cameraDidFinishWhiteBalancing(_ camera: Camera, device: AVCaptureDevice)
    @objc optional func cameraDidFinishSettingExposureTargetBias(_ camera: Camera, device: AVCaptureDevice)
}

class Camera : NSObject {
    
    var captureSession: AVCaptureSession!
    var maxISO: Float!
    var minISO: Float!
    var maxExposureDuration: CMTime!
    var minExposureDuration: CMTime!
    var maxExposureTargetBias: Float!
    var minExposureTargetBias: Float!
    var input: AVCaptureDeviceInput!
    var camera: AVCaptureDevice!
    var output: AVCapturePhotoOutput!
    var active: Bool = false
    weak var _delegate: CameraDelegate!
    
    override init() {
        super.init()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        captureSession.beginConfiguration()
        
        let discoverSession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverSession.devices
        guard let c = devices.first else { return }
        
        camera = c
        camera.addObserver(self, forKeyPath: "adjustingFocus", options: [.new], context: nil)
        camera.addObserver(self, forKeyPath: "adjustingExposure", options: [.new], context: nil)
        camera.addObserver(self, forKeyPath: "adjustingWhiteBalance", options: [.new], context: nil)

        maxISO = camera.activeFormat.maxISO
        minISO = camera.activeFormat.minISO
        maxExposureDuration = camera.activeFormat.maxExposureDuration
        minExposureDuration = camera.activeFormat.minExposureDuration
        maxExposureTargetBias = camera.maxExposureTargetBias
        minExposureTargetBias = camera.minExposureTargetBias
        print("maxISO: \(maxISO)")
        print("minISO: \(minISO)")
        print("maxExposureDuration: \(maxExposureDuration)")
        print("minExposureDuration: \(minExposureDuration)")
        print("maxExposureTargetBias: \(maxExposureTargetBias)")
        print("minExposureTargetBias: \(minExposureTargetBias)")

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
    var whiteBalancing: Bool = false
    
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
                if _delegate != nil && _delegate.responds(to: #selector(CameraDelegate.cameraDidFinishFocusing(_:device:))) {
                    _delegate.cameraDidFinishFocusing!(self, device: camera)
                }
            }
        } else if key == "adjustingExposure" {
            let adjustingExposure = changes[.newKey]
            if (adjustingExposure! as! Bool) {
                expososing = true
            } else {
                expososing = false
                if _delegate != nil && _delegate.responds(to: #selector(CameraDelegate.cameraDidFinishExposing(_:device:))) {
                    _delegate.cameraDidFinishExposing!(self, device: camera)
                }
            }
        } else if key == "adjustWhiteBalance" {
            let adjustingWhiteBalance = changes[.newKey]
            if (adjustingWhiteBalance! as! Bool) {
                whiteBalancing = true
            } else {
                whiteBalancing = false
                if _delegate != nil && _delegate.responds(to: #selector(CameraDelegate.cameraDidFinishWhiteBalancing(_:device:))) {
                    _delegate.cameraDidFinishWhiteBalancing!(self, device: camera)
                }
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
        if camera.isFocusModeSupported(.locked) {
            do {
                focusing = false
                try camera.lockForConfiguration()
                camera.setFocusModeLocked(lensPosition: lensPosition) { (time) in
                    self.camera.unlockForConfiguration()
                    handler()
                }
            } catch {
                print(error)
                handler()
            }
        } else {
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
        if camera.isWhiteBalanceModeSupported(.locked) {
            do {
                try camera.lockForConfiguration()
                camera.setWhiteBalanceModeLocked(with: gains) { (time) in
                    self.camera.unlockForConfiguration()
                    handler()
                }
            } catch {
                print(error)
                handler()
            }
        } else {
            handler()
        }
    }
    
    func setAutoExposure() {
        _setExposureMode(.autoExpose)
    }
    
    func setContinuousAutoExposure() {
        _setExposureMode(.continuousAutoExposure)
    }
    
    func setExposure(_ exposure: Float) {
        if camera.isExposureModeSupported(.locked) {
            do {
                try camera.lockForConfiguration()
                camera.setExposureTargetBias(exposure) { (time) in
                    self.camera.unlockForConfiguration()
                    if self._delegate != nil && self._delegate.responds(to: #selector(CameraDelegate.cameraDidFinishSettingExposureTargetBias(_:device:))) {
                        self._delegate.cameraDidFinishSettingExposureTargetBias!(self, device: self.camera)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func setExposureModeCustom(exposureDuration: CMTime, iso: Float, complationHandler handler: @escaping() -> (Swift.Void)) {
        if camera.isFocusModeSupported(.locked) {
            do {
                try camera.lockForConfiguration()
                camera.setExposureModeCustom(duration: exposureDuration, iso: iso) { (time) in
                    self.camera.unlockForConfiguration()
                    handler()
                }
            } catch {
                print(error)
                handler()
            }
        } else {
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
        do {
            try camera.lockForConfiguration()
            if camera.isExposureModeSupported(mode) {
                camera.exposureMode = mode
            }
            camera.unlockForConfiguration()
            if self._delegate != nil && self._delegate.responds(to: #selector(CameraDelegate.cameraDidFinishSettingExposureTargetBias(_:device:))) {
                self._delegate.cameraDidFinishSettingExposureTargetBias!(self, device: self.camera)
            }
        } catch {
            print(error)
        }
    }
    
    func lensPosition() -> Float {
        return input.device.lensPosition
    }
    
    var oldZoomScale: CGFloat = 1.0
    func zoom(_ zoomScale: CGFloat, end: Bool, complationHandler handler: @escaping(_ : CGFloat) -> (Swift.Void)) {
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
        return camera.videoZoomFactor
    }
        
    func exposureDuration() -> CMTime {
        return camera.exposureDuration
    }
    
    func iso() -> Float {
        return camera.iso
    }
    
    func exposureTargetOffset() -> Float {
        return camera.exposureTargetOffset
    }
    
    func exposureTargetBias() -> Float {
        return camera.exposureTargetBias
    }
    
    func whiteBalanceGains() -> AVCaptureDevice.WhiteBalanceGains? {
        return camera.deviceWhiteBalanceGains
    }
    
    func hasTorch() -> Bool {
        return camera.hasTorch && camera.isTorchAvailable
    }
    
    func isTorchOn() -> Bool {
        return camera.isTorchActive
    }
    
    func torchOn() {
        toggleTorch(true)
    }
    
    func torchOff() {
        toggleTorch(false)
    }
    
    private func toggleTorch(_ flag: Bool) {
        if hasTorch() {
            do {
                try camera.lockForConfiguration()
                if flag {
                    camera.torchMode = .on
                } else {
                    camera.torchMode = .off
                }
                camera.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        var image: Data!
        if _delegate != nil && _delegate.responds(to: #selector(CameraDelegate.cameraWillSavePhoto(_:photo:))) {
            image = _delegate.cameraWillSavePhoto!(self, photo: photo)
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
                if self._delegate != nil && self._delegate.responds(to: #selector(CameraDelegate.cameraDidSavePhoto(_:photo:savedImage:))) {
                    self._delegate.cameraDidSavePhoto!(self, photo: photo, savedImage: image)
                }
            } else {
                print("Could not save photo: \(String(describing: failure))")
            }
        }
    }

}
