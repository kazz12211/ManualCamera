//
//  ViewController+Layout.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/12.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit

extension ViewController {
    
    func layoutSubviews() {
        
        // Preview View
        layoutPreviewView()
        
        // TakePhoto Button
        layoutTakePhotoButton()
        
        // SelfTimer Button
        layoutSelfTimerButton()
        
        // SelfTimer Control
        layoutSelfTimerControl()
        
        // Flash Button
        layoutFlashButton()
        
        // Flash Control
        layoutFlashControl()
        
        // Focus Button
        layoutFocusButton()
        
        // Shutter Speed Button
        layoutShutterSpeedButton()
        
        // ISO Button
        layoutIsoButton()
        
        // White Balance Button
        layoutWhiteBalanceButton()
        
        // EXP Button
        layoutExposureButton()
        
       // Focus Control
        layoutFocusControl()
        
        // Focus Slider
        layoutFocusSlider()
        
        // Timer Counter
        layoutCounterButton()
        
        // Zoom Factor
        layoutZoomLabel()
        
        // Lens Position
        layoutLensPositionLabel()
        
        // Shutter Speed Label
        layoutShutterSpeedLabel()
        
        // ISO Label
        layoutIsoLabel()
        
        // Exposure Label
        layoutExposureLabel()
        
        // White Balance Label
        layoutWhiteBalanceLabel()
        
        // Setting View
        layoutSettingView()
    }

    private func layoutPreviewView() {
        var f = previewView.frame
        if UIDevice.current.orientation.isLandscape {
            f.size.width = UIScreen.main.bounds.height * 4 / 3
            f.size.height = UIScreen.main.bounds.size.height
        } else {
            f.size.width = UIScreen.main.bounds.size.width
            f.size.height = UIScreen.main.bounds.size.width * 4 / 3
        }
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT
            f.origin.y = 0
            break
        case .portrait:
            f.origin.x = 0
            f.origin.y = ViewController.TOP_BAR_HEIGHT
            break
        default:
            break
        }
        previewView.frame = f
        
    }
    
    private func layoutTakePhotoButton() {
        var f = CGRect(x: 0, y: 0, width: 60, height: 60)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - (f.width + ViewController.SCREEN_MARGIN)
            f.origin.y = UIScreen.main.bounds.height / 2 - (f.width / 2)
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width / 2 - (f.width / 2)
            f.origin.y = UIScreen.main.bounds.height - (f.height + ViewController.SCREEN_MARGIN)
            break
        default:
            break
        }
        takeButton.frame = f
    }
    
    private func layoutSelfTimerButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = 16
            f.origin.y = UIScreen.main.bounds.height - 48
            break
        case .portrait:
            f.origin.x = 16
            f.origin.y = 24
            break
        default:
            break
        }
        timerButton.frame = f
    }
    
    private func layoutSelfTimerControl() {
        var f = CGRect(x: 0, y: 0, width: 121, height: 28)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = 64
            f.origin.y = UIScreen.main.bounds.height - 46
            break
        case .portrait:
            f.origin.x = 64
            f.origin.y = 26
            break
        default:
            break
        }
        timerControl.frame = f
    }
    
    private func layoutFlashButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = 16
            f.origin.y = 16
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - 48
            f.origin.y = 24
            break
        default:
            break
        }
        flashButton.frame = f
    }
    
    private func layoutFlashControl() {
        var f = CGRect(x: 0, y: 0, width: 121, height: 28)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT + 4
            f.origin.y = ViewController.SCREEN_MARGIN + 2
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - (flashButton.frame.width + ViewController.CONTROL_GAP + ViewController.SCREEN_MARGIN + f.width)
            f.origin.y = 26
            break
        default:
            break
        }
        flashControl.frame = f
    }
    
    private func layoutFocusButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - 102
            f.origin.y = UIScreen.main.bounds.height - (f.height + ViewController.SCREEN_MARGIN)
            break
        case .portrait:
            f.origin.x = ViewController.SCREEN_MARGIN
            f.origin.y = UIScreen.main.bounds.height - 102
            break
        default:
            break
        }
        focusButton.frame = f
    }
    
    private func layoutShutterSpeedButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - 102
            f.origin.y = UIScreen.main.bounds.height - (ViewController.SCREEN_MARGIN + 32 + ViewController.CONTROL_GAP + f.height)
            break
        case .portrait:
            f.origin.x = ViewController.SCREEN_MARGIN + 32 + ViewController.CONTROL_GAP
            f.origin.y = UIScreen.main.bounds.height - 102
            break
        default:
            break
        }
        shutterSpeedButton.frame = f
    }
    
    private func layoutIsoButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - 102
            f.origin.y = UIScreen.main.bounds.height - (ViewController.SCREEN_MARGIN + 32 + ViewController.CONTROL_GAP + 32 + ViewController.CONTROL_GAP + f.height)
            break
        case .portrait:
            f.origin.x = ViewController.SCREEN_MARGIN + 32 + ViewController.CONTROL_GAP + 32 + ViewController.CONTROL_GAP
            f.origin.y = UIScreen.main.bounds.height - 102
            break
        default:
            break
        }
        isoButton.frame = f
    }
    
    private func layoutWhiteBalanceButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - 102
            f.origin.y = ViewController.SCREEN_MARGIN
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - (ViewController.SCREEN_MARGIN + f.width)
            f.origin.y = UIScreen.main.bounds.height - 102
            break
        default:
            break
        }
        whiteBalanceButton.frame = f
    }
    
    private func layoutExposureButton() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 32)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = UIScreen.main.bounds.width - 102
            f.origin.y = whiteBalanceButton.frame.origin.y + whiteBalanceButton.frame.height + ViewController.CONTROL_GAP
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - (ViewController.SCREEN_MARGIN + 32 + ViewController.CONTROL_GAP + f.width)
            f.origin.y = UIScreen.main.bounds.height - 102
            break
        default:
            break
        }
        exposureButton.frame = f
    }
    
    private func layoutFocusControl() {
        var f = CGRect(x: 0, y: 0, width: 72, height: 28)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT + 4 + timerControl.frame.width + ViewController.CONTROL_GAP
            f.origin.y = UIScreen.main.bounds.height - 46
            break
        case .portrait:
            f.origin.x = ViewController.SCREEN_MARGIN
            f.origin.y = UIScreen.main.bounds.height - 150
            break
        default:
            break
        }
        focusControl.frame = f
    }
    
    private func layoutFocusSlider() {
        var f = CGRect(x: 0, y: 0, width: 72, height: 30)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.size.width = previewView.frame.width - (focusControl.frame.width + ViewController.SCREEN_MARGIN * 2 + timerControl.frame.width + ViewController.CONTROL_GAP)
            f.origin.x = (ViewController.TOP_BAR_HEIGHT + 4 + focusControl.frame.width + ViewController.SCREEN_MARGIN + timerControl.frame.width + ViewController.CONTROL_GAP)
            f.origin.y = UIScreen.main.bounds.height - 47
            break
        case .portrait:
            f.size.width = UIScreen.main.bounds.width - (ViewController.SCREEN_MARGIN + focusControl.frame.width + ViewController.SCREEN_MARGIN * 2)
            f.origin.x = (ViewController.SCREEN_MARGIN * 2 + focusControl.frame.width)
            f.origin.y = UIScreen.main.bounds.height - 151
            break
        default:
            break
        }
        focusSlider.frame = f
    }

    private func layoutCounterButton() {
        var f = CGRect(x: 0, y: 0, width: 80, height: 80)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT + (previewView.bounds.width  - f.width) / 2
            f.origin.y = (UIScreen.main.bounds.height  - f.height) / 2
            break
        case .portrait:
            f.origin.x = (UIScreen.main.bounds.width  - f.width) / 2
            f.origin.y = ViewController.TOP_BAR_HEIGHT + (previewView.bounds.height - f.height) / 2
            break
        default:
            break
        }
       counterButton.frame = f
    }
    
    private func layoutZoomLabel() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 22)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT + previewView.frame.width - f.width
            f.origin.y = 4
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - f.width
            f.origin.y = ViewController.TOP_BAR_HEIGHT + 4
            break
        default:
            break
        }
        zoomLabel.frame = f
    }
    
    private func layoutLensPositionLabel() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 17)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = focusButton.frame.origin.x + focusButton.frame.width + 4
            f.origin.y = focusButton.frame.origin.y + focusButton.frame.height / 2 - f.height / 2
            lensPositionLabel.textAlignment = .left
            break
        case .portrait:
            f.origin.x = focusButton.frame.origin.x + focusButton.frame.width / 2 - f.width / 2
            f.origin.y = focusButton.frame.origin.y + focusButton.frame.height + 4
            lensPositionLabel.textAlignment = .center
            break
        default:
            break
        }
        lensPositionLabel.frame = f
    }
    
    private func layoutShutterSpeedLabel() {
        var f = CGRect(x: 0, y: 0, width: 44, height: 17)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = shutterSpeedButton.frame.origin.x + shutterSpeedButton.frame.width + 4
            f.origin.y = shutterSpeedButton.frame.origin.y + shutterSpeedButton.frame.height / 2 - f.height / 2
            shutterSpeedLabel.textAlignment = .left
            break
        case .portrait:
            f.origin.x = shutterSpeedButton.frame.origin.x + shutterSpeedButton.frame.width / 2 - f.width / 2
            f.origin.y = shutterSpeedButton.frame.origin.y + shutterSpeedButton.frame.height + 4
            shutterSpeedLabel.textAlignment = .center
            break
        default:
            break
        }
        shutterSpeedLabel.frame = f
    }
    
    private func layoutIsoLabel() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 17)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = isoButton.frame.origin.x + isoButton.frame.width + 4
            f.origin.y = isoButton.frame.origin.y + isoButton.frame.height / 2 - f.height / 2
            isoLabel.textAlignment = .left
            break
        case .portrait:
            f.origin.x = isoButton.frame.origin.x + isoButton.frame.width / 2 - f.width / 2
            f.origin.y = isoButton.frame.origin.y + isoButton.frame.height + 4
            isoLabel.textAlignment = .center
            break
        default:
            break
        }
        isoLabel.frame = f
    }

    private func layoutExposureLabel() {
        var f = CGRect(x: 0, y: 0, width: 32, height: 17)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = exposureButton.frame.origin.x + exposureButton.frame.width + 4
            f.origin.y = exposureButton.frame.origin.y + exposureButton.frame.height / 2 - f.height / 2
            exposureLabel.textAlignment = .left
            break
        case .portrait:
            f.origin.x = exposureButton.frame.origin.x + isoButton.frame.width / 2 - f.width / 2
            f.origin.y = exposureButton.frame.origin.y + exposureButton.frame.height + 4
            exposureLabel.textAlignment = .center
            break
        default:
            break
        }
        exposureLabel.frame = f
    }

    private func layoutWhiteBalanceLabel() {
        var f = CGRect(x: 0, y: 0, width: 48, height: 17)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = whiteBalanceButton.frame.origin.x + whiteBalanceButton.frame.width + 4
            f.origin.y = whiteBalanceButton.frame.origin.y + whiteBalanceButton.frame.height / 2 - f.height / 2
            whiteBalanceLabel.textAlignment = .left
            break
        case .portrait:
            f.origin.x = whiteBalanceButton.frame.origin.x + whiteBalanceButton.frame.width / 2 - f.width / 2
            f.origin.y = whiteBalanceButton.frame.origin.y + whiteBalanceButton.frame.height + 4
            whiteBalanceLabel.textAlignment = .center
            break
        default:
            break
        }
        whiteBalanceLabel.frame = f
    }

    private func layoutSettingView() {
        var f = CGRect(x: 0, y: 0, width: 172, height: 100)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = (ViewController.TOP_BAR_HEIGHT + previewView.frame.width) - (ViewController.SCREEN_MARGIN + f.width)
            f.origin.y = focusSlider.frame.origin.y - (ViewController.SCREEN_MARGIN + f.height)
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - (ViewController.CONTROL_GAP + f.width)
            f.origin.y = focusSlider.frame.origin.y - (ViewController.SCREEN_MARGIN + f.height)
            break
        default:
            break
        }
        settingView.frame = f
    }
    
    private func hideSettingControls() {
        whiteBalanceStepper.isHidden = true
        whiteBalanceValueLabel.isHidden = true
        exposureStepper.isHidden = true
        exposureValueLabel.isHidden = true
        exposureSwitch.isHidden = true
        isoStepper.isHidden = true
        isoValueLabel.isHidden = true
        isoSwitch.isHidden = true
        shutterSpeedStepper.isHidden = true
        shutterSpeedValueLabel.isHidden = true
        shutterSpeedSwitch.isHidden = true
    }
    
    func layoutWhiteBalanceControl() {
        hideSettingControls()
        
        var f = CGRect(x: ViewController.CONTROL_GAP, y: ViewController.CONTROL_GAP, width: 120, height: 17)
        settingLabel.frame = f
        settingLabel.text = "WHITE BALANCE"

        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 17)
        f.origin.y = ViewController.CONTROL_GAP + 8 + settingLabel.frame.height
        whiteBalanceValueLabel.frame = f
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 29)
        f.origin.y = whiteBalanceValueLabel.frame.origin.y + whiteBalanceValueLabel.frame.height + 4
        whiteBalanceStepper.frame = f
        
        whiteBalanceValueLabel.isHidden = false
        whiteBalanceStepper.isHidden = false
    }
    
    func layoutExposureControl() {
        hideSettingControls()
        
        var f = CGRect(x: ViewController.CONTROL_GAP, y: ViewController.CONTROL_GAP, width: 120, height: 17)
        settingLabel.frame = f
        settingLabel.text = "EXPOSURE"
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 17)
        f.origin.y = ViewController.CONTROL_GAP + 8 + settingLabel.frame.height
        exposureValueLabel.frame = f
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 29)
        f.origin.y = exposureValueLabel.frame.origin.y +  exposureValueLabel.frame.height + 4
        exposureStepper.frame = f
        
        f = CGRect(x: 0, y: 0, width: 54, height:29)
        f.origin.x = exposureStepper.frame.origin.x + exposureStepper.frame.width + ViewController.CONTROL_GAP
        f.origin.y = exposureValueLabel.frame.origin.y + exposureValueLabel.frame.height + 4
        exposureSwitch.frame = f

        exposureValueLabel.isHidden = false
        exposureStepper.isHidden = false
        exposureSwitch.isHidden = false
    }
    
    func layoutIsoControl() {
        hideSettingControls()
        
        var f = CGRect(x: ViewController.CONTROL_GAP, y: ViewController.CONTROL_GAP, width: 120, height: 17)
        settingLabel.frame = f
        settingLabel.text = "ISO"
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 17)
        f.origin.y = ViewController.CONTROL_GAP + 8 + settingLabel.frame.height
        isoValueLabel.frame = f
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 29)
        f.origin.y = isoValueLabel.frame.origin.y + isoValueLabel.frame.height + 4
        isoStepper.frame = f
        
        f = CGRect(x: 0, y: 0, width: 54, height:29)
        f.origin.x = isoStepper.frame.origin.x + isoStepper.frame.width + ViewController.CONTROL_GAP
        f.origin.y = isoValueLabel.frame.origin.y + isoValueLabel.frame.height + 4
        isoSwitch.frame = f
        
        isoValueLabel.isHidden = false
        isoStepper.isHidden = false
        isoSwitch.isHidden = false
    }

    func layoutShutterSpeedControl() {
        hideSettingControls()
        
        var f = CGRect(x: ViewController.CONTROL_GAP, y: ViewController.CONTROL_GAP, width: 120, height: 17)
        settingLabel.frame = f
        settingLabel.text = "SHUTTER SPEED"
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 17)
        f.origin.y = ViewController.CONTROL_GAP + 8 + settingLabel.frame.height
        shutterSpeedValueLabel.frame = f
        
        f = CGRect(x: ViewController.CONTROL_GAP, y: 0, width: 94, height: 29)
        f.origin.y = shutterSpeedValueLabel.frame.origin.y + shutterSpeedValueLabel.frame.height + 4
        shutterSpeedStepper.frame = f
        
        f = CGRect(x: 0, y: 0, width: 54, height:29)
        f.origin.x = shutterSpeedStepper.frame.origin.x + shutterSpeedStepper.frame.width + ViewController.CONTROL_GAP
        f.origin.y = shutterSpeedValueLabel.frame.origin.y + shutterSpeedValueLabel.frame.height + 4
        shutterSpeedSwitch.frame = f
        
        shutterSpeedValueLabel.isHidden = false
        shutterSpeedStepper.isHidden = false
        shutterSpeedSwitch.isHidden = false
    }

}
