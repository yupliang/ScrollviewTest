//
//  ViewControllerB.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/6.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {


    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if let view = sender.view {
            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    view.alpha = 0.8
                    view.center = sender.location(in: self.view)
                })
            case .ended:
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1
                })
            default:print("not implement state")
            }
        }
    }
    
}
