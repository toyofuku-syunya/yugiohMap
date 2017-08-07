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
import Accounts
import Social
import Firebase
import FirebaseDatabase


class Detail:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var myImageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var ReviewTableView: UITableView!
    @IBOutlet var textLabel:UILabel!

    
    var detailReviewArray = ["24時間営業ですが、担当のスタッフがいない時間帯だと少し対応が雑に感じます。遊戯王の担当スタッフがいる時間帯の方が、買取の交渉もできたり、色々と話を聞けるので楽良いです。","買取が非常に高いですが、店員の対応があまり良くない。さらに、店が異常に狭い…まあ秋葉原駅から滅茶苦茶近いから仕方ない","某ラッシュ並に買取が高く、店内は広々していて、デュエルスペースもある。駅からそこそこ遠いけど、いい店です。","老舗です。秋葉原大通りで、自称初めて遊戯王を取り扱った店と言っていますが、詳細は不明。店内はごちゃごちゃしてますが、店長さんも優しくていい店です。"]


    
    @IBAction func restore(){
      self.dismiss(animated: true, completion: nil)   
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //labelに選択された店の名前を表示する
        nameLabel.text = sortedTestArray[selectedShopNumber].name
        
//        ref.child("shopData").child("\(sortedTestArray[selectedShopNumber].id)").child("name").observe(.value, with: { snapshot in
//            print("hello world")
//            let name = snapshot.value as! String
//            self.nameLabel.text = name
//            
//        })
        
        
        
        
        
        // 表示する画像を設定する
        let myImage = UIImage(named:sortedTestArray[selectedShopNumber].image)
        
        // 画像をUIImageViewに設定する.
        myImageView.image = myImage
        
        // UIImageViewをViewに追加する.
        self.view.addSubview(myImageView)
        
        
        //ReviewTableViewの設定
        // Cell名の登録をおこなう.
        ReviewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        
        // DataSourceを自身に設定する.
        ReviewTableView.dataSource = self
        
        // Delegateを自身に設定する.
        ReviewTableView.delegate = self
    
        
        // Viewに追加する.
        self.view.addSubview(ReviewTableView)

        ReviewTableView.estimatedRowHeight = 50.0
        ReviewTableView.rowHeight = UITableViewAutomaticDimension
        
        ReviewTableView.reloadData()
    }
    
    
    //自分の位置をツイートする関数
    @IBAction func TweetTwitter(sender: AnyObject) {
        var composeView:SLComposeViewController
        
        composeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        composeView.setInitialText("I'm at \(sortedTestArray[selectedShopNumber].name)  #遊戯王 #yugioh")
        
        self.present(composeView, animated: true, completion: nil)
        
        
    }

    
    //セルの数をshopNameArray.countの数に合わせる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailReviewArray.count
    }
    
    
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath as IndexPath)
        
        // textLabelの行数を0にすると、内容に応じて、任意の行数になる。
        cell.textLabel?.numberOfLines = 0
        // textLabelにテキストを入力。
        cell.textLabel?.text = detailReviewArray[indexPath.row]
            
        return cell
            
    }

}
