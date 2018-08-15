//
//  Timelapse.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/15.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import Foundation

@objc protocol TimelapseDelegate: NSObjectProtocol {
    @objc optional func timelapseWillStart(_ timelapse: Timelapse)
    @objc func timelapseDidArriveShootingTime(_ timelapse: Timelapse, counter: Int)     // counter starts from 1
    @objc optional func timelapseDidFinish(_ timelapse: Timelapse)
    @objc optional func timelapseDidCancel(_ timelapse: Timelapse)
}

class Timelapse: NSObject {
    private var _timer: Timer!
    var count: Int = 0
    var interval: TimeInterval = 0
    var running: Bool = false
    private var _delegate: TimelapseDelegate!
    private var _counter: Int = 1
    
    func initWithDelegate(_ delegate: TimelapseDelegate) {
        self._delegate = delegate
    }
    
    func run(count: Int, interval: TimeInterval) {
        self.count = count
        self.interval = interval
        self._counter = 1
        if count > 0 {
            running = true
            if _delegate != nil && _delegate.responds(to: #selector(TimelapseDelegate.timelapseWillStart(_:))) {
                _delegate.timelapseWillStart!(self)
            }
            if _delegate != nil {
                _delegate.timelapseDidArriveShootingTime(self, counter: _counter)
            }
            _timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (t) in
                if self._counter == self.count {
                    self._timer.invalidate()
                    self._timer = nil
                    self.running = false
                    if self._delegate != nil && self._delegate.responds(to: #selector(TimelapseDelegate.timelapseDidFinish(_:))) {
                        self._delegate.timelapseDidFinish!(self)
                    }
                } else {
                    self._counter += 1
                    if self._delegate != nil {
                        self._delegate.timelapseDidArriveShootingTime(self, counter: self._counter)
                    }
                }
            })
        }
    }
    
    func cancel() {
        if _timer != nil {
            _timer.invalidate()
            _timer = nil
        }
        running = false
        if _delegate != nil && _delegate.responds(to: #selector(TimelapseDelegate.timelapseDidCancel(_:))) {
            _delegate.timelapseDidCancel!(self)
        }
    }
}
