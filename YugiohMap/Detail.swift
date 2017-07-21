//
//  Detail.swift
//  YugiohMap
//
//  Created by Syunya Toyofuku on 2017/07/13.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//



import UIKit
import MapKit
import CoreLocation
import Foundation

class Detail:UIViewController{
    
    
    @IBOutlet var myImageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    
    @IBAction func restore(){
      self.dismiss(animated: true, completion: nil)   
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Yugioh"
        nameLabel.text = sortedTestArray[selectedShopNumber].name
        
        
        
        
        // 表示する画像を設定する.
        let myImage = UIImage(named:sortedTestArray[selectedShopNumber].image)
        
        // 画像をUIImageViewに設定する.
        myImageView.image = myImage
        
        
        // UIImageViewをViewに追加する.
        self.view.addSubview(myImageView)
    
    }
    
    
    
}
