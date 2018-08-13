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
}
