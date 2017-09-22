//
//  sendReview.swift
//  YugiohShops
//
//  Created by Syunya Toyofuku on 2017/08/22.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class sendReview:UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var sendMassage:String = "0"
    var evaluation:Int = 0
    
    
    // 表示する値の配列.
    let myValues: [String] = ["1","2","3","4","5"]
    
    
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var textView:UITextView!
    // UIPickerView.
    @IBOutlet var myUIPicker: UIPickerView!
    
    @IBAction func restore(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
        
        nameLabel.text = String(sortedDataArray[selectedShopNumber][4])
        
        // 枠のカラー
        textView.layer.borderColor = UIColor.red.cgColor
        
        // 枠の幅
        textView.layer.borderWidth = 1.0
        
        // 枠を角丸にする場合
        textView.layer.cornerRadius = 10.0
        textView.layer.masksToBounds = true
        
        
        // Delegateを設定する.
        myUIPicker.delegate = self
        
        // DataSourceを設定する.
        myUIPicker.dataSource = self
        
        
        self.view.addSubview(myUIPicker)
    }
    
    @IBAction func send(){
        sendMassage = textView.text!
        print("送信するメッセージ",sendMassage)
        
        if sendMassage.isEmpty {
            print("sendMassageがEmpty")
            let alert: UIAlertController = UIAlertController(title: "レビューが入力されていません。", message: "レビューを打ち込んでください。", preferredStyle:  UIAlertControllerStyle.alert)
            
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
                
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
            
        }else{
            
            
            let alert: UIAlertController = UIAlertController(title: "レビューを投稿します", message: "反映されるまでしばらく時間が掛かります。", preferredStyle:  UIAlertControllerStyle.alert)
            
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                
                let data = ["\(formatter)": self.sendMassage]
                let evaluationData = ["\(formatter)": self.evaluation]
                ref.child("shopData").child("\(sortedDataArray[selectedShopNumber][0])").child("review").updateChildValues(data)
                ref.child("shopData").child("\(sortedDataArray[selectedShopNumber][0])").child("evaluation").updateChildValues(evaluationData)
                
                
                //Detailクラスに戻った際に、テーブルビューをリロードするメソッドを呼び出す。
                let controller = self.presentingViewController as? Detail
                self.dismiss(animated: true, completion: {
                    controller?.reloadTableView()
                })
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myValues.count
    }
    
    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myValues[row]
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(myValues[row])")
        evaluation = Int(myValues[row])!
        print(evaluation)
    }
    
    
}
