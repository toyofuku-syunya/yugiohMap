//
//  registration.swift
//  YugiohShops
//
//  Created by Syunya Toyofuku on 2017/09/03.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

let userID:String = Auth.auth().currentUser!.uid

class registration:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet var imageView : UIImageView!
    
    @IBOutlet var userName:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        
        
        print("現在のユーザーは")
        print(userID)
        
        //Firebase Database サンプルコード...Appの読み込み時に実行されるので、コードからデータベースを操作したい時はここに記載する。
        //        ref.child("shopData").child("narakan").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
        //            // Get user value
        //            let value = snapshot.value as! String
        //            print("this is value \(value)")
        //            print(snapshot.value as! String)
        //        })
        //        let data = ["\(formatter)": self.sendMassage]
        //        let evaluationData = ["\(formatter)": self.evaluation]
        
        userName.backgroundColor = UIColor.white
        userName.layer.cornerRadius = 8
        userName.clearButtonMode = UITextFieldViewMode.whileEditing
        userName.text = "ユーザーネームを入力してください。"
        
        
        
        ref.child("users").child("\(userID)").updateChildValues(["userID": userID ])
        ref.child("users/\(userID)").updateChildValues(["settingFinished": "no"])
        
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        
//        imageView.image = image
//        
//        print("写真が選択されました。")
//        
//        self.dismiss(animated: true, completion: nil)
//
//        self.view.addSubview(imageView)
//    }

    var sendImage:UIImage!
    
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.sendImage = image
        
        // ビューに表示する
        self.imageView.image = image
        
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func takeImage(){

        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            
            pickerView.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerView.allowsEditing = true
            
            
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
       
        }
    }
    
    @IBAction func sendName(){
        
        print("Hello world")
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://yugiohshops-9e90b.appspot.com")
        if let data = UIImagePNGRepresentation(sendImage) {
            let riversRef = storageRef.child("images/\(userID)Icon.jpg")
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
            })
        }
        
        let userNameStr = userName.text!
        print(userNameStr)
        ref.child("users").child("\(userID)").updateChildValues(["userName" : userNameStr])
        ref.child("users/\(userID)").updateChildValues(["settingFinished": "yes"])
        
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)
        
        
    }
    
}
