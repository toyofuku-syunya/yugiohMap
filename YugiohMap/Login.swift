//
//  Login.swift
//  YugiohShops
//
//  Created by Syunya Toyofuku on 2017/08/27.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController{
    
    @IBOutlet var mail:UITextField!
    @IBOutlet var password:UITextField!
    

    //UIViewControllerクラスに遷移する
    func goToNext(){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)
    }
    
    //registrationに遷移する
    func goToRegistration(){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "registration")
        
        nextVC?.modalTransitionStyle = .flipHorizontal
        
        present(nextVC!, animated: true, completion: nil)

    }
    
    //各種データを保存するユーザーデフォルト
    let LoginData:UserDefaults  = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        secondLogin()
        
        //ユーザーデフォルトに格納されているLoginSkipの中身によって、ログインをスキップする。
        if self.LoginData.object(forKey: "LoginSkip") != nil{
        let skipOrNot = self.LoginData.object(forKey: "LoginSkip") as! String
        if skipOrNot == "true" {
            print("ログインをスキップします")
            signin()
        }
        }
        
        loginSwitch.isOn = false
        loginSwitch.tintColor = UIColor.black
        
        mail.backgroundColor = UIColor.white
        mail.layer.cornerRadius = 8
        mail.clearButtonMode = UITextFieldViewMode.whileEditing
        
        password.backgroundColor = UIColor.white
        password.layer.cornerRadius = 8
        password.clearButtonMode = UITextFieldViewMode.whileEditing
        password.isSecureTextEntry = true
    }
    
    //ログインの情報記録を管理するメソッド、ユーザーデフォルトのjudgeの中身に応じて、保存してあるユーザーデータをテキストフィールドに適応させる。
    func secondLogin(){
        if self.LoginData.object(forKey: "judge") == nil{
            print("ログインは一回目です")
        }else{
            let secondLogin = self.LoginData.object(forKey: "judge") as! String
            if secondLogin == "true" {
                mail.text = "\(String(describing: self.LoginData.object(forKey: "mailAddress") as! String))"
                password.text = "\(String(describing: self.LoginData.object(forKey: "password") as! String))"
            }else{
                print("not second")
            }
        }
    }
    
    //サインインを行うクラス。サインインに成功したら、UIViewControllerに遷移する
    @IBAction func signin(){
        Auth.auth().signIn(withEmail: mail.text!, password: password.text!, completion: { user, error in
            if let error = error {
                print("サインインできません \(error)")
                return
            }
            
            if let user = user {
                print("user : \(user.email!) サインインできました")
                self.LoginData.set("\(self.mail.text!)", forKey: "mailAddress")
                self.LoginData.set("\(self.password.text!)", forKey: "password")
                self.LoginData.set("true" , forKey: "judge")
                self.LoginData.synchronize()
                print(self.LoginData)
                self.goToNext()
            }
        })
        
    }
    
    //アカウントを作成するメソッド、アカウントの作成に成功したら、registrationクラスに遷移して、ユーザー登録を行う。
    @IBAction func create(){
        Auth.auth().createUser(withEmail: mail.text!, password: password.text!, completion: { user, error in
            if let error = error {
                print("ユーザーを作れませんでした \(error)")
                return
            }
            
            if let user = user {
                print("user : \(user.email!)ユーザーを作成しました")
                self.LoginData.set("\(self.mail.text!)", forKey: "mailAddress")
                self.LoginData.set("\(self.password.text!)", forKey: "password")
                self.LoginData.set("true" , forKey: "judge")
                self.LoginData.synchronize()
                print("registrationへの遷移")
                self.goToRegistration()
            }
            
        })
        
    }
    
    
    
    @IBOutlet var loginSwitch:UISwitch!
    
    
    @IBAction func Switch(sender: UISwitch) {
        if ( sender.isOn ) {
            self.LoginData.set("true", forKey: "LoginSkip")
            print("true")
        } else {
            self.LoginData.set("false", forKey: "LoginSkip")
            print("false")
        }
    }
    
    
}
