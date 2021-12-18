//
//  MailsigninViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift
import FirebaseFirestore

class MailsigninViewController: UIViewController, UITextFieldDelegate {
    
    var realm = try! Realm()
    var list: List<Memos>!
    let db = Firestore.firestore()
    
    @IBOutlet weak var MailTextfield: TextField!
    @IBOutlet weak var PasswordTextField: TextField!
    @IBOutlet weak var Button: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        MailTextfield.delegate = self
        PasswordTextField.delegate = self
        
        MailTextfield.layer.borderColor = UIColor.white.cgColor
        PasswordTextField.layer.borderColor = UIColor.white.cgColor
        
    }
    
    @IBAction func Signin(_ sender: Any) {
        print("タップログインボタン")
        guard let email = MailTextfield.text else { return }
        guard let password = PasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン失敗" , err)
                return
            }
            print("ログイン成功")
            let LoadDB = LoadDBModel()
            LoadDB.realmset()
            self.performSegue(withIdentifier: "next", sender: nil)
        }
        //メイン画面遷移
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
        tabBarController.selectedIndex = 0
        self.present(tabBarController, animated: true, completion: nil)
    }
}
