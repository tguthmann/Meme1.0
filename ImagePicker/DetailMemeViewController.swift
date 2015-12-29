//
//  DetailMemeViewController.swift
//  ImagePicker
//
//  Created by Tina Guthmann on 11/24/15.
//  Copyright © 2015 Tina Guthmann. All rights reserved.
//

import Foundation
import UIKit

//Display the detail view, which is just the memed image,
//upon clicking the image from the view controllers
class DetailMemeViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    //set the memed image and hides tab bar 
    //just before the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.memedImage
    }
    
    //redisplays tab bar just before view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

}
