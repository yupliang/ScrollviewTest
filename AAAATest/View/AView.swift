//
//  AView.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/4.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

let kMinimumDotRadius: CGFloat = 15.0
let kMaximumDotRadius: CGFloat = 50.0

class AView: UIView {

    //MARK: Properties
    let color: UIColor?
    let radius: CGFloat?
    var highlighted: Bool? {
        willSet {
            if newValue == true {
                if let c = color {
                    backgroundColor = c.darkerColorWithFactor()
                }
            } else {
                if let c = color {
                    backgroundColor = c
                }
            }
        }
    }
    var timeEnd: Int64! = 0
   
    init(color: UIColor, radius: CGFloat) {
        self.color = color
        self.radius = radius
        super.init(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        backgroundColor = color
        layer.cornerRadius = radius
    }
    
    convenience override init(frame: CGRect) {
        let randomColor = UIColor.randomVividColor()
        let randomRadius = AView.randomValueFrom(Int(kMinimumDotRadius), to: Int(kMaximumDotRadius))
        self.init(color: randomColor!, radius: randomRadius)
    }
    
    class func randomValueFrom(_ fromValue: Int, to toValue: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(toValue - fromValue)) + UInt32(fromValue))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var touchBounds = self.bounds
        if let radius = radius, radius < 22.0 {
            let expansion = 22.0 - radius
            touchBounds = touchBounds.insetBy(dx: -expansion, dy: -expansion)
        }
        return touchBounds.contains(point)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function + "\(Date().toMillis())")
       highlighted = true
        timeEnd = Date().toMillis()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function + "\(Date().toMillis())")
        highlighted = false
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function + "\(Date().toMillis())")
        let interval = Date().toMillis() - timeEnd
        if interval < 60 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(60-interval)/1000.0, execute: {
                self.highlighted = false
            })
        } else {
            highlighted = false
        }
        print(interval)
    }
    
    // MARK: - Arrange Dots
    class func arrangeDotsRandomlyInView(containerView: UIView) {
        let size = containerView.bounds.size
        for view in containerView.subviews {
            if let dot = view as? AView {
                let dotDiameter: CGFloat = dot.layer.cornerRadius * 2
                let randomX = AView.randomValueFrom(Int(dotDiameter), to: Int(size.width - dotDiameter))
                let randomY = AView.randomValueFrom(Int(dotDiameter), to: Int(size.height - dotDiameter))
                dot.center = CGPoint(x: randomX, y: randomY)
            }
        }
    }
    
    class func arrangeDotsNeatlyInView(_ containerView: UIView) {
        let width: CGFloat = containerView.bounds.size.width
        let neatFactor: CGFloat = width < 600.0 ? 0 : width < 1024.0 ? 1 : 2;
        
        let horizontalSlotCount = floor(width / (kMaximumDotRadius*2)) - neatFactor
        let totalSlotSpacing = width - (horizontalSlotCount * kMaximumDotRadius*2)
        let slotSpacing = totalSlotSpacing / horizontalSlotCount
        
        let dotSlotSide = kMaximumDotRadius*2 + slotSpacing
        let halfDotSlotSide = dotSlotSide / 2.0
        
        var initialX = halfDotSlotSide
        var initialY = halfDotSlotSide
        
        for view in containerView.subviews {
            if let dot = view as? AView {
                let neatX = initialX
                let neatY = initialY
                dot.center = CGPoint(x: neatX, y: neatY)
                
                initialX = initialX + dotSlotSide
                if initialX >= containerView.bounds.size.width {
                    initialX = halfDotSlotSide
                    initialY = initialY + dotSlotSide
                }
            }
        }
    }
    
    class func arrangeDotsNeatlyInViewWithNiftyAnimation(_ containerView: UIView) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            AView.arrangeDotsNeatlyInView(containerView)
        })
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
