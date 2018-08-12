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
            f.origin.x = UIScreen.main.bounds.width - (f.width + 6)
            f.origin.y = UIScreen.main.bounds.height / 2 - (f.width / 2)
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width / 2 - (f.width / 2)
            f.origin.y = UIScreen.main.bounds.height - (f.width + 6)
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
        var f = CGRect(x: 0, y: 0, width: 70, height: 18)
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
        var f = CGRect(x: 0, y: 0, width: 70, height: 18)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            f.origin.x = ViewController.TOP_BAR_HEIGHT + previewView.frame.width - f.width
            f.origin.y = 4 + zoomLabel.frame.height + 4
            break
        case .portrait:
            f.origin.x = UIScreen.main.bounds.width - f.width
            f.origin.y = ViewController.TOP_BAR_HEIGHT + 4 + zoomLabel.frame.height + 4
            break
        default:
            break
        }
        lensPositionLabel.frame = f
    }
}
