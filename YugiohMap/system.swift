//
//  system.swift
//  YugiohShops
//
//  Created by Syunya Toyofuku on 2017/09/22.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class system: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        ref.child("users/\(userID)/userName").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! String
            print("this is value \(value)")
            print(snapshot.value as! String)
            
            self.nameLabel.text = value
        })
        
        
        
    }
}
