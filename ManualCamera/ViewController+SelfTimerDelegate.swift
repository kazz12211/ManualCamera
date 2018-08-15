//
//  ViewController+SelfTimerDelegate.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/15.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation

extension ViewController: SelfTimerDelegate {
    
    func selfTimerCountdown(_ timer: SelfTimer, counter: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(1113))
        counterButton.setAttributedTitle(NSAttributedString(string: "\(counter)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 48), NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        counterButton.isHidden = false
    }
    
    func selfTimerFinished(_ timer: SelfTimer) {
        counterButton.isHidden = true
        shoot()
    }
}

