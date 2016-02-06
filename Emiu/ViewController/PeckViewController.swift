//
//  PeckViewController.swift
//  Emiu
//
//  Created by Triomphe on 2016/01/30.
//  Copyright © 2016年 noguchikaito. All rights reserved.
//

import Foundation
import UIKit

class PeckViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var peckCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
}