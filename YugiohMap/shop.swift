//
//  shop.swift
//  YugiohMap
//
//  Created by Syunya Toyofuku on 2017/07/14.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//
import UIKit
import Foundation

class shop:UIViewController {
    
    
    
}

class FrinkClass {
    var name : String! //最初に初期値が必要になる
    var price : Int = 0
    
    init(name : String, price : Int){
        self.name = name
        self.price = price //self.で呼び出すと、そのクラスの変数　付けていないとその関数の引数などの変数を指定している
    }
}

func culcTax(tax : Float){
    print(Float(price)*tax)
    
    
}

//呼び出し
cola?.culcTax(tax:1.08)

////ViewController
//let cola = DrinkClass(name: , price : )
//drinkArray.
//
//print(Float[drinkArray[0].price) * 1.08 )
