//
//  CollectionViewCell.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/8.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

private let PULL_THRESHOLD: CGFloat = 60.0
class CollectionViewCell: UICollectionViewCell {
    
    private var pulling: Bool = false
    private var decelerateToZero = false
    private var outerScrollSpeedRatio: CGFloat = 0
    private let colorView: UIView! = UIView()
    weak var delegate: ScrollingCellDelegate?
    @IBOutlet private weak var scrollView: UIScrollView!
    var color: UIColor? {
        willSet {
            if let color = newValue {
                colorView.backgroundColor = color
            }
        }
    }
    
    override func awakeFromNib() {
        scrollView.delegate = self
        scrollView.addSubview(colorView)
        scrollView.isPagingEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds

        let pageWidth: CGFloat = bounds.size.width + PULL_THRESHOLD
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: bounds.size.height)
        scrollView.contentSize = CGSize(width: pageWidth * 2, height: bounds.size.height)
        colorView.frame = bounds
    }
}

extension CollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset > PULL_THRESHOLD && !pulling {
            delegate!.scrollingCellDidBeginPulling(cell: self)
            pulling = true
        }
        if pulling {
            var pullOffset: CGFloat
            
            if decelerateToZero {
                pullOffset = offset * outerScrollSpeedRatio
            } else {
                pullOffset = max(0, offset - PULL_THRESHOLD)
            }
            
            delegate?.scrolling(cell: self, offset: pullOffset)
            scrollView.transform = CGAffineTransform.init(translationX: pullOffset, y: 0)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnded()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingEnded()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.x == 0 && scrollView.contentOffset.x > 0 {
            decelerateToZero = true
            outerScrollSpeedRatio = max(0, scrollView.contentOffset.x - PULL_THRESHOLD) / scrollView.contentOffset.x
        }
    }
    func scrollingEnded() {
        delegate?.scrollingCellDidEndPulling(cell: self)
        pulling = false
        scrollView.contentOffset = CGPoint.zero
        scrollView.transform = CGAffineTransform.identity
        decelerateToZero = false
    }
}
