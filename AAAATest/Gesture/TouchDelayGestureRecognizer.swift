//
//  TouchDelayGestureRecognizer.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/7.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TouchDelayGestureRecognizer: UIGestureRecognizer {
    private var timer: Timer?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        delaysTouchesBegan = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(fail), userInfo: nil, repeats: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        fail()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        fail()
    }
    
    override func reset() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func fail() {
        state = .failed
    }
}
