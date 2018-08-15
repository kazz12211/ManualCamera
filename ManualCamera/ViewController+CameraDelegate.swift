//
//  ViewController+CameraDelegate.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/15.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import AVFoundation

extension ViewController: CameraDelegate {
    
    func cameraDidFinishFocusing(_ camera: Camera, device: AVCaptureDevice) {
        hideFocus()
        focusSlider.value = device.lensPosition
        lensPositionLabel.text = "".appendingFormat("%.2f", device.lensPosition)
    }
    
    func cameraDidFinishExposing(_ camera: Camera, device: AVCaptureDevice) {
        let c = camera as! ManualCamera
        if c.shutterMode == .auto {
            shutterSpeedLabel.text = c.exposureDurationLabel()
            shutterSpeedValueLabel.text = c.exposureDurationLabel()
            c.shutterSpeedValue = c.exposureDuration()
        }
        if c.isoMode == .auto {
            isoLabel.text = "".appendingFormat("%.0f", c.iso())
            isoValueLabel.text = "".appendingFormat("%.0f", c.iso())
            c.isoValue = c.iso()
        }
        if c.exposureMode == .auto {
            exposureLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
            c.exposureTargetBias = device.exposureTargetBias
        }
        
    }
    
    func cameraDidFinishWhiteBalancing(_ camera: Camera, device: AVCaptureDevice) {
        let wb = device.deviceWhiteBalanceGains
        print(wb)
    }
    
    func cameraDidFinishSettingExposureTargetBias(_ camera: Camera, device: AVCaptureDevice) {
        exposureLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
        exposureValueLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
    }
}

