//
//  CameraConstants.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/11.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import Foundation
import AVFoundation

struct CameraConstants {
    
    static let ExposureDurationValues = [CMTimeMake(1, 10000), CMTimeMake(1, 8000), CMTimeMake(1, 6400), CMTimeMake(1, 5000), CMTimeMake(1, 4000), CMTimeMake(1, 3200), CMTimeMake(1, 2500), CMTimeMake(1, 2000), CMTimeMake(1, 1600), CMTimeMake(1, 1250), CMTimeMake(1, 1000), CMTimeMake(1, 800), CMTimeMake(1, 640), CMTimeMake(1, 500), CMTimeMake(1, 400), CMTimeMake(1, 320), CMTimeMake(1, 250), CMTimeMake(1, 200), CMTimeMake(1, 160), CMTimeMake(1, 125), CMTimeMake(1, 100), CMTimeMake(1, 80), CMTimeMake(1, 60), CMTimeMake(1, 50), CMTimeMake(1, 40), CMTimeMake(1, 30), CMTimeMake(1, 25), CMTimeMake(1, 20), CMTimeMake(1, 15), CMTimeMake(1, 13), CMTimeMake(1, 10), CMTimeMake(1, 8), CMTimeMake(1, 6), CMTimeMake(1, 5), CMTimeMake(1, 4), CMTimeMake(1, 3)]
    
    static let ExposureDurationLabels = ["1/10000", "1/8000", "1/6400", "1/5000", "1/4000", "1/3200", "1/2500", "1/2000", "1/1600", "1/1250", "1/1000", "1/800", "1/640", "1/500", "1/400", "1/320", "1/250", "1/200", "1/160", "1/125", "1/100", "1/80", "1/60", "1/50", "1/40", "1/30", "1/25", "1/20", "1/15", "1/13", "1/10", "1/8", "1/6", "1/5", "1/4", "1/3"]
    
    static let isoValues: [Float] = [25, 32, 40, 64, 80, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600]
    
    
}
