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
    @IBOutlet var evaluationLabel:UILabel!
    @IBOutlet var distanceLabel:UILabel!
    
    //Firebaseデータベースからレビュー階層以下のデータを取得して保存するディクショナリデータ
    var detailDictionary: Dictionary<String, Any>!
    //データベースから取得したレビューのデータをString型で保存する配列
    var detailReviewArray = [String]()
    
    @IBAction func restore(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReview(){
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "sendReview")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readReviewFromDataBase()
        
        //distanceLabelに数値を表示
        var distance:Double = Double(sortedDataArray[selectedShopNumber][5])!
        distance = distance * 1000
        distanceLabel.text = String(format: "%.1f km", distance)
//        self.evaluationLabel.text = String(format: "%.2f", evAve)

        
        //labelに選択された店の名前を表示する
        nameLabel.text = sortedDataArray[selectedShopNumber][4]
        
        // 表示する画像を設定する
        let myImage = UIImage(named:sortedDataArray[selectedShopNumber][1])
        
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
        
        composeView.setInitialText("I'm at \(sortedDataArray[selectedShopNumber][4])  #遊戯王 #YugiohShops ")
        
        self.present(composeView, animated: true, completion: nil)
        
    }
    
    func readReviewFromDataBase(){
        detailReviewArray = []
        ref.child("shopData").child("\(sortedDataArray[selectedShopNumber][0])").child("review").observeSingleEvent(of: .value, with: {(snapshot) in
            self.detailDictionary = snapshot.value as! [String:Any]
            
            for name in self.detailDictionary!.keys  {
                let review = String(describing: snapshot.childSnapshot(forPath: "\(name)").value!)
                self.detailReviewArray.append(review)
            }
            self.ReviewTableView.reloadData()
        })
        
        
        ref.child("shopData").child("\(sortedDataArray[selectedShopNumber][0])").child("evaluation").observeSingleEvent(of: .value, with: {(snapshot) in
            self.detailDictionary = [:]
            self.detailDictionary = snapshot.value as! [String:Any]
            var evSum:Double = 0
            var evAve:Double = 0
            for name in self.detailDictionary!.keys  {
                let eva = String(describing: snapshot.childSnapshot(forPath: "\(name)").value!)
                evSum = evSum + Double(eva)!
                evAve = evAve + 1
            }
            evAve = evSum / evAve
            print("評価evaluationの合計",evSum)
            print("評価evaluationの平均",evAve)
            self.evaluationLabel.text = String(format: "%.2f", evAve)
        })
    }
    
    //セルの数をshopNameArray.countの数に合わせる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailReviewArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath as IndexPath)
        
        //textLabelの行数を0にすると、内容に応じて、任意の行数になる。
        cell.textLabel?.numberOfLines = 0
        // textLabelにテキストを入力。
        cell.textLabel?.text = detailReviewArray[indexPath.row]
        
        return cell
        
    }
    
    func reloadTableView(){
        readReviewFromDataBase()
        ReviewTableView.reloadData()
        print("reloadTableViewが呼び出されました")
    }
    
    
    
}
