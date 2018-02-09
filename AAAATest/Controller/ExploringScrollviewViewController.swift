//
//  ExploringScrollviewViewController.swift
//  AAAATest
//
//  Created by yupeiliang on 2018/2/8.
//  Copyright © 2018年 PL Technology. All rights reserved.
//

import UIKit

private let kCollectionViewCellIdentifier = "cellIdentifier"

class ExploringScrollviewViewController: UIViewController {
    @IBOutlet weak var outerScrollView: UIScrollView!
    @IBOutlet weak var buildingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            outerScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
            collectionView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0);
        }
    }
    override func viewDidLayoutSubviews() {
        print(outerScrollView)
        if #available(iOS 11.0, *) {
            
        } else {
            // Fallback on earlier versions
            collectionView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0);
        }
    }
}

extension ExploringScrollviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}

extension ExploringScrollviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellIdentifier, for: indexPath) as! CollectionViewCell
        cell.color = UIColor(red: random(), green: random(), blue: random(), alpha: 1);
        cell.delegate = self
        return cell
    }
}

extension ExploringScrollviewViewController: ScrollingCellDelegate {
    func scrollingCellDidBeginPulling(cell: CollectionViewCell) {
        outerScrollView.isScrollEnabled = false
        buildingView.backgroundColor = cell.color
    }
    
    func scrolling(cell: CollectionViewCell, offset: CGFloat) {
        outerScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
    
    func scrollingCellDidEndPulling(cell: CollectionViewCell) {
        outerScrollView.isScrollEnabled = true
    }
    
    
}

extension ExploringScrollviewViewController {
    ///0 ... 1
    func random() -> CGFloat {
        return min(CGFloat(arc4random()) / CGFloat(RAND_MAX), 0.75);
    }
}
