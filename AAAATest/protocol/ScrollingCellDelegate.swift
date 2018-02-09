//
//  ScrollingCellDelegate.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/8.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import Foundation
import CoreGraphics

@objc protocol ScrollingCellDelegate: NSObjectProtocol {
    func scrollingCellDidBeginPulling(cell: CollectionViewCell)
    func scrolling(cell: CollectionViewCell, offset: CGFloat)
    func scrollingCellDidEndPulling(cell: CollectionViewCell)
}
