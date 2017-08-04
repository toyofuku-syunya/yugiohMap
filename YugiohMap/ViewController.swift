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




var selectedShopNumber = 0

var shopArray = [["カードラッシュ秋葉原一号店","cardrush.jpg"]]
var sortedShopArray = [["0"]]
var sortedTestArray:[shopClass] = []

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,MKMapViewDelegate, CLLocationManagerDelegate{
    
    var myLocationManager: CLLocationManager!
    
    var myLocation:CLLocationCoordinate2D!
    
    var testArray:[shopClass] = []
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        
//        database = FIRDatabase.database().reference()
        
        startTimer()
        
        //起動時にもTableViewを表示できるように最初に配列を完成させる。
        addShopInformationToArray()
        //その後に、sortedTestArrayをtestArrayのコピーで仮作成する。現時点では位置情報は取得していないので、位置情報でソートしようとするとエラーになる。
        sortedTestArray = testArray.sorted { $0.location < $1.location }
        
        
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
        
        
        
        if myLocation != nil {
            TemporalEvent()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //セルの数をshopNameArray.countの数に合わせる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTestArray.count
        
    }
    
    
    /*
     Cellに値を設定する
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(sortedTestArray[indexPath.row].name)"
        
        // Cellに店の画像を表示する
        cell.imageView!.image = UIImage(named:sortedTestArray[indexPath.row].image)
        
        // Return Cell Font
        cell.textLabel?.font = UIFont(name: "TT A1 Mincho Std", size: 17)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)

        
        return cell
    }
    
    //セルが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog("%@が選ばれました",sortedTestArray[indexPath.row].name)
        
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
    
  
    //10秒ごとにreSortメソッドを呼び出し、現在地からの距離を再計算して配列を再構成し、その結果をTableViewに表示する
    
    
    //GPSから値を読み込んだ時に呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        myLocation = myLastLocation.coordinate
        
        print("現在の位置情報")
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        
        
    }
    
    //時間ごとにテーブルビューを並べ替えるコード
    var timer:Timer?
    
    func startTimer(){
        if timer == nil {
            // x秒 毎にTemporalEventを呼び出す
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(ViewController.TemporalEvent), userInfo: nil,repeats: true)
        }
    }
    
    func stopTimer(){
        if timer != nil {
            timer?.invalidate(); timer = nil
        }
    }
    
    //一定タイミングで繰り返し呼び出される関数
    func TemporalEvent(){
        cardrush?.calLocation(location: myLocation)
        supairaru?.calLocation(location: myLocation)
        narakan?.calLocation(location: myLocation)
        toredou?.calLocation(location: myLocation)
        tsudalabo?.calLocation(location: myLocation)
        chibalabo?.calLocation(location: myLocation)
        sisukan?.calLocation(location: myLocation)
        sisukan?.calLocation(location: myLocation)
        ysn?.calLocation(location: myLocation)
        ysn3?.calLocation(location: myLocation)
        karuto?.calLocation(location: myLocation)
        toreja?.calLocation(location: myLocation)
        dragonster?.calLocation(location: myLocation)
        ln?.calLocation(location: myLocation)
        ln2?.calLocation(location: myLocation)
        bgn?.calLocation(location: myLocation)
        
        
        sortedTestArray = testArray.sorted { $0.location < $1.location }
    
        //GPS情報を元にした配列の並べ替えが行われる。
        
        myTableView.reloadData()
    }
    
    func addShopInformationToArray(){
        testArray.append(cardrush!)
        testArray.append(supairaru!)
        testArray.append(narakan!)
        testArray.append(toredou!)
        testArray.append(tsudalabo!)
        testArray.append(chibalabo!)
        testArray.append(sisukan!)
        testArray.append(ysn!)
        testArray.append(ysn3!)
        testArray.append(karuto!)
        testArray.append(toreja!)
        testArray.append(dragonster!)
        testArray.append(ln!)
        testArray.append(ln2!)
        testArray.append(bgn!)
    }
    
    
    let cardrush = shopClass(lat: 35.697893, long: 139.771579, location: 0, name: "カードラッシュ秋葉原一号店", image: "cardrush.jpg")
    let supairaru = shopClass(lat: 35.701746, long: 139.769957, location: 0, name: "すぱいらる", image: "spiral.jpeg")
    let narakan = shopClass(lat: 35.675034, long: 140.001289, location: 0, name: "千葉鑑定団湾岸習志野店", image: "chibakan.jpeg")
    let toredou = shopClass(lat: 35.64216, long: 139.770000, location: 0, name: "トレカの洞窟", image: "doukutu.jpeg")
    let tsudalabo = shopClass(lat: 35.6895004, long: 140.01933, location: 0, name: "カードラボ津田沼店", image:"ltd.jpeg")
    let chibalabo = shopClass(lat: 35.607284998939605, long: 140.11920969080734, location: 0, name: "カードラボ千葉中央店", image: "chibalabo.jpg")
    let sisukan = shopClass(lat: 35.718262, long: 140.261824, location: 0, name: "千葉鑑定団酒々井店", image: "sisukan.jpeg")
    let ysn = shopClass(lat: 34.662213, long: 135.505149, location: 0, name: "イエローサブマリンなんば店", image: "ysn.jpg")
    let ysn3 = shopClass(lat: 34.6628341, long: 135.5050107, location: 0, name: "イエローサブマリンなんば3号店", image: "ysn3.jpeg")
    let karuto = shopClass(lat: 34.65447, long: 135.5008969, location: 0, name: "カードカルト大阪日本橋店", image: "karuto.jpeg")
    let toreja = shopClass(lat: 34.662505, long: 135.505141, location: 0, name: "とれじゃらすオタロード店", image: "toreja.jpeg")
    let dragonster = shopClass(lat: 34.662958, long: 135.504316, location: 0, name: "ドラゴンスター日本橋店", image: "da.jpeg")
    let ln = shopClass(lat: 34.661824, long: 135.505065, location: 0, name: "カードラボなんば店", image: "ln.jpeg")
    let ln2 = shopClass(lat: 34.552325, long: 135.503946, location: 0, name: "カードラボなんば2号店", image: "ln2.jpg")
    let bgn = shopClass(lat: 34.6627551, long: 135.5042158, location: 0, name: "BIGMAGIC なんば店", image: "bgn.jpeg")
}
