//
//  OverlayScrollView.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/7.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

class OverlayScrollView: UIScrollView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        
        return hitView
    }

}
