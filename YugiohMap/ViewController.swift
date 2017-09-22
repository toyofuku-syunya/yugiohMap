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
import Firebase
import FirebaseDatabase

//現在指定されている店の配列番号を保存するグローバル変数
var selectedShopNumber = 0

//データベースから取得した店の情報を格納しているグローバル配列
var dataArray:[[String]] = [["1","1","1"]]

//上の配列を近い順にソートしてその順番に合わせて格納しているグローバル配列
var sortedDataArray:[[String]] = [["1","1","1"]]


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,MKMapViewDelegate, CLLocationManagerDelegate{
    
    var myLocationManager: CLLocationManager!
    var myLocation:CLLocationCoordinate2D!
    var nowYouAre:CLLocation!
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        importData().dataRead()
        
        
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
        
        
        if myLocation != nil {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //セルの数をshopNameArray.countの数に合わせる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDataArray.count
    }
    
    
    /*
     Cellに値を設定する
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(sortedDataArray[indexPath.row][4])"
        
        // Cellに店の画像を表示する
        cell.imageView!.image = UIImage(named:sortedDataArray[indexPath.row][1])
        
        // Return Cell Font
        cell.textLabel?.font = UIFont(name: "TT A1 Mincho Std", size: 17)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        
        return cell
    }
    
    //セルが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog("%@が選ばれました",sortedDataArray[indexPath.row][4])
        
        _ = tableView.cellForRow(at:indexPath)
        
        shopDetail(indexPath:indexPath.row)
    }
    
    
    //ショップ欄がタッチされた時の処理＿別画面への遷移
    func shopDetail(indexPath:Int){
        
        selectedShopNumber = indexPath
        
        //以下移動コード
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "shopDetail")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)
        
    }
    
    func resort(){
        nowYouAre = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
        for i in 0..<dataArray.count {
            distanceMaker(shopNum: i ,location: myLocation)
        }
        sortedDataArray = dataArray.sorted { $0[5] < $1[5] }
        myTableView.reloadData()
        print("resort終了")
    }
    
    func distanceMaker(shopNum: Int ,location: CLLocationCoordinate2D){
        let shopLocation:CLLocation = CLLocation(latitude: Double(dataArray[shopNum][2])!, longitude: Double(dataArray[shopNum][3])!)
        
        var distance:Double = 0
        
        distance = Double(nowYouAre.distance(from: shopLocation))
        distance = floor(distance)
        distance = distance/1000000
        
        dataArray[shopNum][5] = String(distance)
    }
    
    
    var locationFirst:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0 ,longitude: 0.0)
    var firstLoad:Bool = true
    
    //GPSから値を読み込んだ時に呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        myLocation = myLastLocation.coordinate
        
        //        print("現在の位置情報")
        //        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        if dataArray.isEmpty{
            print("配列dataArrayの中身は空です")
        }else{
            if firstLoad{
                resort()
                print("first Load")
                firstLoad = false
                myTableView.reloadData()
            }else{
                if fabs(locationFirst.latitude - myLocation.latitude) > 0.0005{
                    if fabs(locationFirst.longitude - myLocation.longitude) > 0.0005{
                        
                        locationFirst = myLocation
                        print("locationFirst = ")
                        print("\(locationFirst.latitude), \(locationFirst.longitude)")
                    }
                }
            }
        }
    }
}
