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
    }
    
    func timelapseDidArriveShootingTime(_ timelapse: Timelapse, counter: Int) {
        doShoot()
    }
    
    func timelapseDidFinish(_ timelapse: Timelapse) {
    }
    
    func timelapseDidCancel(_ timelapse: Timelapse) {
    }
}
