//
//  ManualCamera.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/11.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum CameraFocusMode: Int {
    case auto = 0
    case manual = 1
}

enum CameraSettingMode: Int {
    case none = 0
    case shutterSpeed = 1
    case iso = 2
    case exposure = 3
    case whiteBalance = 4
}

enum CameraExposureMode: Int {
    case auto = 0
    case manual = 1
}

enum CameraISOMode: Int {
    case auto = 0
    case manual = 1
}

enum CameraShutterMode: Int {
    case auto = 0
    case manual = 1
}

class ManualCamera: Camera {
    
    var settingMode: CameraSettingMode = .none
    var focusMode: CameraFocusMode = .auto
    var flashMode: AVCaptureDevice.FlashMode = .off
    var exposureMode: CameraExposureMode = .auto {
        didSet {
            if exposureMode == .auto {
                exposureTargetBias = 0
                setExposure(exposureTargetBias)
                setContinuousAutoExposure()
           } else {
                setExposure(exposureTargetBias)
            }
        }
    }
    var whiteBalanceValue: AVCaptureDevice.WhiteBalanceGains!
    var whiteBalanceValues: [AVCaptureDevice.WhiteBalanceGains?] = []
    var selectedWhiteBalanceIndex: Int = 0 {
        didSet {
            if selectedWhiteBalanceIndex == 0 {
                setContinuousAutoWhiteBalance()
            } else {
                setWhiteBalance(gains: whiteBalanceValues[selectedWhiteBalanceIndex]!) { () -> (Void) in
                }
            }
        }
    }
    
    var exposureTargetBias: Float = 0.0 {
        didSet {
            if exposureMode == .manual {
                setExposure(exposureTargetBias)
            }
        }
    }
    
    var isoMode: CameraISOMode = .auto {
        didSet {
            if isoMode == .manual {
                self.setExposureModeCustom(exposureDuration: shutterSpeedValue, iso: isoValue) { () -> (Void) in
                }
            } else {
                self.setAutoExposure()
            }
        }
    }
    var shutterMode: CameraShutterMode = .auto {
        didSet {
            if shutterMode == .manual {
                self.setExposureModeCustom(exposureDuration: shutterSpeedValue, iso: isoValue) { () -> (Void) in
                }
            } else {
                self.setAutoExposure()
            }
        }
    }
    
    var isoValue: Float! {
        didSet {
            if isoMode == .manual {
                self.setExposureModeCustom(exposureDuration: shutterSpeedValue, iso: isoValue) { () -> (Void) in
                }
            }
        }
    }
    
    var shutterSpeedValue: CMTime! {
        didSet {
            if shutterMode == .manual {
                self.setExposureModeCustom(exposureDuration: shutterSpeedValue, iso: isoValue) { () -> (Void) in
                }
            }
        }
    }
        
    
    override init() {
        super.init()
        whiteBalanceValues.append(nil)
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Tungsten))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Fluorescent))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Sunrise))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Flash))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Daylight))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Cloudy))
        whiteBalanceValues.append(camera.deviceWhiteBalanceGains(for: CameraConstants.K_Shade))
        
        reset()
    }
    
    func reset() {
        settingMode = .none
        focusMode = .auto
        flashMode = .off
        exposureMode = .auto
        isoMode = .auto
        shutterMode = .auto
        selectedWhiteBalanceIndex = 0

        setContinuousAutoWhiteBalance()
        setContinuousAutoExposure()
        autoFocus(at: CGPoint(x:0.5, y: 0.5))
        
        exposureTargetBias = camera.exposureTargetBias
    }
        
    func takePhoto(orientation: AVCaptureVideoOrientation) {
        super.takePhoto(flashMode: flashMode, orientation: orientation)
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
    
    func indexOfISO() -> Int {
        return isoIndex(isoValue)
    }
    
    func indexOfShutterSpeed() -> Int {
        return exposureDurationIndex(shutterSpeedValue)
    }
    
    override func exposureDuration() -> CMTime {
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
    
    override func iso() -> Float {
        guard let cameraInput = input else { return CameraConstants.IsoValues[0] }
        let camera = cameraInput.device
        let iso = camera.iso
        let index = isoIndex(iso)
        if index >= 0 {
            return CameraConstants.IsoValues[index]
        }
        return CameraConstants.IsoValues[0]
    }
    
    func selectISO(_ index: Int) {
        isoValue = CameraConstants.IsoValues[index]
    }
    
    func selectShutterSpeed(_ index: Int) {
        shutterSpeedValue = CameraConstants.ExposureDurationValues[index]
    }

}
