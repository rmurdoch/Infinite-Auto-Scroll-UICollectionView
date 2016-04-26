//
//  ViewController.swift
//  AutoInfiniteScroll
//
//  Created by Andrew Murdoch on 4/26/16.
//  Copyright © 2016 RAM4LLC. All rights reserved.
//

import UIKit

class HorizontalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let items = ["One", "Two", "Three", "Four", "Five"]
    let dummyCount = 3
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
    }
    
// -------------------------------------------------------------------------------
//	UICollectionView DataSource
// -------------------------------------------------------------------------------
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyCount * items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let itemIndex = indexPath.item % self.items.count
        let item = self.items[itemIndex]
        
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item
        
        return cell
    }
   
// -------------------------------------------------------------------------------
//	UICollectionView Delegate
// -------------------------------------------------------------------------------
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemIndex = indexPath.item % self.items.count
        let item = self.items[itemIndex]
        print(item)
    }
    
    
// -------------------------------------------------------------------------------
//	Infinite Scroll Controls
// -------------------------------------------------------------------------------
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.centerIfNeeded()
    }
    
    func centerIfNeeded() {
        let currentOffset = collectionView.contentOffset
        let contentWidth = self.totalContentWidth
        let width = contentWidth / CGFloat(dummyCount)
        
        if 0 > currentOffset.x {
            //left scrolling
            collectionView.contentOffset = CGPointMake(width - currentOffset.x, currentOffset.y)
        } else if (currentOffset.x + cellWidth) > contentWidth {
            //right scrolling
            let difference = (currentOffset.x + cellWidth) - contentWidth
            collectionView.contentOffset = CGPointMake(width - (cellWidth + difference), currentOffset.y)
        }
    }
    
    var totalContentWidth: CGFloat {
        return CGFloat(items.count * dummyCount) * cellWidth
    }
    
    var cellWidth: CGFloat {
        return CGRectGetWidth(collectionView.frame)
    }
    
// -------------------------------------------------------------------------------
//	Timer Controls
// -------------------------------------------------------------------------------
    func startTimer() {
        if items.count > 1 && timer == nil {
            let timeInterval = 5.0;
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(HorizontalViewController.rotate), userInfo: nil, repeats: true)
            timer!.fireDate = NSDate().dateByAddingTimeInterval(timeInterval)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func rotate() {
        let offset = CGPoint(x: collectionView.contentOffset.x + cellWidth, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
}

