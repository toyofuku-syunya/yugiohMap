//
//  ViewController.swift
//  YugiohMap
//
//  Created by Syunya Toyofuku on 2017/06/09.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var selectedShopNumber = 0

var shopArray = [["カードラッシュ秋葉原一号店","cardrush.jpg"]]
var sortedShopArray = [["0"]]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,MKMapViewDelegate, CLLocationManagerDelegate{
    
    var myLocationManager: CLLocationManager!
    
    var myLocation:CLLocationCoordinate2D!
    
    

    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        
        // Cell名の登録をおこなう.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 精度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            print("not determined")
            myLocationManager.requestWhenInUseAuthorization()
        }

        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()
        
        yugioh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //セルの数をshopNameArray.countの数に合わせる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedShopArray.count
    }
    
    /*
     Cellに値を設定する
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(sortedShopArray[indexPath.row][1])"
        
        // Cellに店の画像を表示する
        cell.imageView!.image = UIImage(named:sortedShopArray[indexPath.row][2])

 
        return cell
    }
    
    //セルが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        NSLog("%@が選ばれました",sortedShopArray[indexPath.row][1])
        
        _ = tableView.cellForRow(at:indexPath)
        
        shopDetail(indexPath:indexPath.row)
    }

    
    //ショップ欄がタッチされた時の処理＿別画面への遷移
    func shopDetail(indexPath:Int){
        
        print (indexPath)
        
        selectedShopNumber = indexPath
        
        
        //以下移動コード
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "shopDetail")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)
        
    }
    
    
    func gpsCal(_ gps:gps) -> String {
        var distance:Double = 0
        var width:Double = 0
        var height:Double = 0
        if myLocation != nil{
            width = myLocation.latitude - gps.lat
            width = abs(width)
            height = myLocation.longitude - gps.long
            height = abs(height)
        }
        
        distance = width * width + height * height
        distance = sqrt(distance)
        return String(distance)
    }
    
    struct gps{
        var lat:Double
        var long:Double
    }

    //店を追加するときは、構造体gpsを用いて位置情報を登録する
    //gps情報は小数点以下7程度が望ましい。精度が高すぎると、GPSが示す地点ジャストにいる際に原因不明のエラーが起こる可能性がある
    
    let cardRush = gps(lat:35.697893, long:139.771579)
    let spiral = gps(lat:35.701746,long:139.769957)
    let chibakan = gps(lat:35.675034135468195, long:140.00128984451294)
    let doukutu = gps(lat: 35.64216, long: 140.04963)
    let labotsuda = gps(lat:35.6895004, long: 140.0193357)

    
    
    
    
    //読み込み時に行う動作。配列の構成を行う。
      func yugioh(){
        
        
        //店を追加するときは、shopArray.append で、以下の様に記載する
        shopArray.append(["すぱいらる","spiral.jpeg"])
        shopArray.append(["千葉鑑定団湾岸習志野店","chibakan.jpeg"])
        shopArray.append(["トレカの洞窟秋葉原店","cardrush.jpg"])
        shopArray.append(["カードラボ津田沼店","cardrush.jpg"])
        
        //店を追加するときはこの欄に現在地情報の関数gpsCalを用いて現在地からの近さを計算（数値が少ないほど近い）して、配列の最初に追加
        shopArray[0].insert(gpsCal(cardRush), at: 0)
        shopArray[1].insert(gpsCal(spiral), at: 0)
        shopArray[2].insert(gpsCal(chibakan), at: 0)
        shopArray[3].insert(gpsCal(doukutu), at: 0)
        shopArray[4].insert(gpsCal(labotsuda), at:0)
        
        
        print(gpsCal(cardRush))
        
        print("shopArrayの中身\n",shopArray)
        
        sortedShopArray = shopArray.sorted  { $0[0] < $1[0] }
        
        print("sort後の非破壊ソート配列sortedShopArrayの中身\n",sortedShopArray)
    }
    
    //現在地が更新された時にreSortメソッドを呼び出し、現在地からの距離を再計算して配列を再構成し、その結果をTableViewに表示する
    func reSort(){
//        for i in 0...100 {
//            shopArray[i][0] = gpsCal(shopNameArray[i])
//        }
        
        shopArray[0][0] = gpsCal(cardRush)
        shopArray[1][0] = gpsCal(spiral)
        shopArray[2][0] = gpsCal(chibakan)
        shopArray[3][0] = gpsCal(doukutu)
        shopArray[4][0] = gpsCal(labotsuda)
        
        
        sortedShopArray = shopArray.sorted { $0[0] < $1[0] }
        print("reSortメソッドを実行")
        print(sortedShopArray)
    
        //TableViewの表示をリセット
        myTableView.reloadData()
    }
    
    
    //GPSから値を読み込んだ時に呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("現在の位置情報")
        
        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        myLocation = myLastLocation.coordinate
        
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        reSort()
        
    }
    
    let timer:NSTimer?
    
    func startTimer(){
        if timer == nil {
            　　　　// 0.3s 毎にTemporalEventを呼び出す
            timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector:"TemporalEvent", userInfo: nil,repeats: true)
        }
    }
    　　
    //一定タイミングで繰り返し呼び出される関数
    　 func TemporalEvent(){
        //処理を記述
    }
    
    func stopTimer(){
        if timer != nil {
            timer?.invalidate() timer = nil
        }
    }
    
    @IBOutlet var myTableView: UITableView!


    
    //ショップの写真を格納する配列

}
