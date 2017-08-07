//
//  shop.swift
//  YugiohMap
//
//  Created by Syunya Toyofuku on 2017/07/14.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//
import UIKit
import CoreLocation
import Firebase


class shopClass {
//    var id:String
    var lat:Double
    var long:Double
    var location:Double
    var name:String
    var image:String
    
    init?(lat: Double,long: Double,location: Double , name: String, image: String){
//        self.id = id
        self.lat = lat
        self.long = long
        self.location = location
        self.name = name
        self.image = image
    }
    
    func calLocation(location: CLLocationCoordinate2D){
        var distance:Double = 0
        var width:Double = 0
        var height:Double = 0
    
            width  = location.latitude - lat
            width = abs(width)
            height = location.longitude - long
            height = abs(height)
        
        distance = width * width + height * height
                distance = sqrt(distance)
        
        self.location = distance
    }

}


