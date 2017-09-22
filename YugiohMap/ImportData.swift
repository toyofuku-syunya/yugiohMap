//
//  Database.swift
//  YugiohShops
//
//  Created by Syunya Toyofuku on 2017/08/07.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreLocation


class importData:UIViewController{
    
    var databaseDictionary: Dictionary<String, Any>!
    
    var importDataArray:[String] = ["0"]
    
    func dataRead(){
        sortedDataArray = []
        dataArray = []
        
        ref.child("shopData").observeSingleEvent(of: .value, with: {(snapshot) in
            self.databaseDictionary = snapshot.value as! [String:Any]
            
            for name in self.databaseDictionary!.keys {
                let shopId = String(describing: snapshot.childSnapshot(forPath: "\(name)").childSnapshot(forPath: "id").value!)
                let shopLat = String(describing: snapshot.childSnapshot(forPath: "\(name)").childSnapshot(forPath: "lat").value!)
                let shopLong = String(describing: snapshot.childSnapshot(forPath: "\(name)").childSnapshot(forPath: "long").value!)
                let shopImage = String(describing: snapshot.childSnapshot(forPath: "\(name)").childSnapshot(forPath: "img").value!)
                let shopName = String(describing: snapshot.childSnapshot(forPath: "\(name)").childSnapshot(forPath: "name").value!)
                let shopDistance:Int = 0
                
                self.importDataArray = []
                self.importDataArray.append(shopId)
                self.importDataArray.append(shopImage)
                self.importDataArray.append(shopLat)
                self.importDataArray.append(shopLong)
                self.importDataArray.append(shopName)
                self.importDataArray.append(String(shopDistance))
                
                dataArray.append(self.importDataArray)
            }
            
            sortedDataArray = dataArray
            
        })
        print("importDataメソッドを終了")
    }
}
