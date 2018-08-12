//
//  SelfTimer.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/11.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import Foundation

@objc protocol SelfTimerDelegate: NSObjectProtocol {
    @objc optional func selfTimerStarted(_ timer: SelfTimer)
    func selfTimerCountdown(_ timer: SelfTimer, counter: Int)
    func selfTimerFinished(_ timer: SelfTimer)
    @objc optional func selfTimerCancelled(_ timer: SelfTimer)
}

class SelfTimer: NSObject {
    private var _timer: Timer!
    var active: Bool = false
    private var _counter: Int = 0
    private weak var _delegate: SelfTimerDelegate!
    
    func initWithDelegate(_ delegate: SelfTimerDelegate) {
        _delegate = delegate
    }
    
    func run(_ seconds: Int) {
        active = true
        _counter = seconds
        if _delegate != nil && _delegate.responds(to: #selector(SelfTimerDelegate.selfTimerStarted(_:))) {
            _delegate.selfTimerStarted!(self)
        }
        if _delegate != nil {
            _delegate.selfTimerCountdown(self, counter: _counter)
        }
        _timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (tm) in
            self._counter = self._counter - 1;
            if self._counter == 0 && self.active == true {
                if self._delegate != nil {
                    self._delegate.selfTimerFinished(self)
                }
                self.active = false
                self._timer.invalidate()
                self._timer = nil
            } else {
                if self._delegate != nil {
                    self._delegate.selfTimerCountdown(self, counter: self._counter)
                }
            }
        })
    }
    
    func cancel() {
        if _timer != nil {
            _timer.invalidate()
            _timer = nil
        }
        active = false
        if _delegate != nil && _delegate.responds(to: #selector(SelfTimerDelegate.selfTimerCancelled(_:))) {
            self._delegate.selfTimerCancelled!(self)
        }
    }
    
}
