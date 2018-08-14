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

enum FocusMode: Int {
    case autoFocus = 0
    case manualFocus = 1
}

enum SettingMode: Int {
    case none = 0
    case shutterSpeed = 1
    case iso = 2
    case exposure = 3
    case whiteBalance = 4
}

class ManualCamera: Camera {
    
    var settingMode: SettingMode = .none
    var focusMode: FocusMode = .autoFocus
    var flashMode: AVCaptureDevice.FlashMode = .off
    var whiteBalance: AVCaptureDevice.WhiteBalanceGains!
    var whiteBalanceValues: [AVCaptureDevice.WhiteBalanceGains?] = []
    var selectedWhiteBalanceIndex: Int = 0
    
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
        setAutoWhiteBalance()
        setContinuousAutoExposure()
        autoFocus(at: CGPoint(x:0.5, y: 0.5))
    }
    
    func selectWhiteBalance(index: Int) {
        selectedWhiteBalanceIndex = index
        if index == 0 {
            setAutoWhiteBalance()
        } else {
            setWhiteBalance(gains: whiteBalanceValues[index]!) { () -> (Void) in
            }
        }
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
    

}
