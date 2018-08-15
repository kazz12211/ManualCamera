//
//  ViewController+TimelapseDelegate.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/15.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit

extension ViewController: TimelapseDelegate {
    
    func timelapseWillStart(_ timelapse: Timelapse) {
        startTimelapseAnimation()
    }
    
    func timelapseDidArriveShootingTime(_ timelapse: Timelapse, counter: Int) {
        doShoot()
    }
    
    
    func timelapseDidFinish(_ timelapse: Timelapse) {
        stopTimelapseAnimation()
    }
    
    func timelapseDidCancel(_ timelapse: Timelapse) {
        stopTimelapseAnimation()
    }
    
    private func startTimelapseAnimation() {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.repeat ,.allowUserInteraction], animations: {
            self.timelapseButton.alpha = 0.2
            self.takeButton.alpha = 0.2
        }, completion: nil)
    }

    private func stopTimelapseAnimation() {
        self.timelapseButton.layer.removeAllAnimations()
        self.timelapseButton.alpha = 1.0
        self.takeButton.layer.removeAllAnimations()
        self.takeButton.alpha = 1.0
    }

}
