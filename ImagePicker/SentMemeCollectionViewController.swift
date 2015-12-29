//
//  SentMemeCollectionViewController.swift
//  ImagePicker
//
//  Created by Tina Guthmann on 11/23/15.
//  Copyright © 2015 Tina Guthmann. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    //memes from AppDelegate
    var memes: [Meme] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set variables which control how the memes will be layed
        //out on device
        let space: CGFloat = 0.5
        let w = (self.view.frame.size.width - (2 * space)) / 3.0
        let h = (self.view.frame.size.height - (2 * space)) / 3.0
 
        //the code below was found at this site:
        /* www.snip2code.com/Snippet/136447/Receive-device-orientation-notifications */
        let dimension : CGFloat = {
            switch UIDevice.currentDevice().orientation {
            case UIDeviceOrientation.Unknown: return w
            case UIDeviceOrientation.Portrait: return w
            case UIDeviceOrientation.PortraitUpsideDown: return w
            case UIDeviceOrientation.LandscapeLeft: return h
            case UIDeviceOrientation.LandscapeRight: return h
            default: return w
            }
        }()
        
        //let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    //just before view appears, hide the tab bar and call reloadData()
    //to make sure any newly created memes are displayed
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.collectionView!.reloadData()
    }
    
    //subscribe/unsubscribe to orientation notifications so that
    //view changes when user chagnes orientation
    func subscribeToOrientationNotifications(){
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "detectOrientation",
            name:UIDeviceOrientationDidChangeNotification,
            object:nil)
    }
    
    func unsubscribeFromOrientationNotifications(){
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    }

    
    //returns number of memes
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //returns a cell for the table view; in this case the table view
    //will return the memed image 
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeCollectionViewCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell

        let meme = self.memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    //passes selected meme to Detail View
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailMemeViewController") as! DetailMemeViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}