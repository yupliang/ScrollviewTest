//
//  ViewController.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/1/28.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    var canvasView: UIView!
    var scrollView: UIScrollView!
    var drawerView: UIVisualEffectView!
    
    var drawerHeight: CGFloat {
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        switch view.traitCollection.userInterfaceIdiom {
        case .phone:
            return UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? width : height / 1.4
        default:
            return height / 1.9
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = self.view.bounds
        canvasView = UIScrollView(frame: bounds)
        canvasView.backgroundColor = UIColor.darkGray
        view.addSubview(canvasView)
        
        
        let device = view.traitCollection.userInterfaceIdiom
        addDots(count: device == .pad ? 25 : 10, toView: canvasView)
        AView.arrangeDotsRandomlyInView(containerView: canvasView)
        
        scrollView = OverlayScrollView(frame: bounds)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        drawerView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        drawerView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: drawerHeight)
        scrollView.addSubview(drawerView)
        
        self.addDots(count: 10, toView: drawerView.contentView)
        AView.arrangeDotsNeatlyInView(drawerView.contentView)
        
        scrollView.contentSize = CGSize(width: bounds.size.width, height: bounds.size.height + drawerView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: 0, y: drawerView.frame.size.height)
        view.addGestureRecognizer(scrollView.panGestureRecognizer)
        
    }

   
    private func addDots(count: Int, toView view: UIView) {
        for _ in 1...count {
            let dot = AView()
            view.addSubview(dot)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPress.cancelsTouchesInView = false
            longPress.delegate = self
            dot.addGestureRecognizer(longPress)
        }
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if let dot = gesture.view {
            switch gesture.state {
            case .began:
                grabDot(dot, withGesture: gesture)
            case .changed:
                moveDot(dot, withGesture: gesture)
            case .ended, .cancelled:
                dropDot(dot, withGesture: gesture)
            default:
                print("gesture state not implemented")
            }
        }
    }
    
    func grabDot(_ dot: UIView, withGesture gesture: UIGestureRecognizer) {
        
        let dotFromDrawer = dot.superview === drawerView.contentView
        dot.center = self.view.convert(dot.center, from: dot.superview)
        self.view.addSubview(dot)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            dot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            dot.alpha = 0.8
            self.moveDot(dot, withGesture: gesture)
        })
        
        scrollView.panGestureRecognizer.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = true
        
        if dotFromDrawer {
            AView.arrangeDotsNeatlyInViewWithNiftyAnimation(drawerView.contentView)
        }
    }
    
    func moveDot(_ dot: UIView, withGesture gesture: UIGestureRecognizer) {
        dot.center = gesture.location(in: view)
    }
    
    func dropDot(_ dot: UIView, withGesture gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            dot.transform = CGAffineTransform.identity
            dot.alpha = 1.0
        })
        
        let locationInDrawer = gesture.location(in: drawerView)
        if drawerView.bounds.contains(locationInDrawer) {
            drawerView.contentView.addSubview(dot)
        } else {
            canvasView.addSubview(dot)
        }
        dot.center = dot.superview!.convert(dot.center, from: self.view)
        
        if dot.superview === drawerView.contentView {
            AView.arrangeDotsNeatlyInViewWithNiftyAnimation(drawerView.contentView)
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
