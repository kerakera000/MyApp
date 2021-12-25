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
            Realmset()
            self.performSegue(withIdentifier: "next", sender: nil)
        }
        func Realmset(){
            print("きたよーーーーーーー")
            try! realm.write {
                realm.deleteAll()
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            db.collection("newuser").document(uid).collection("memo").order(by: "postDateID").addSnapshotListener{(snapShot, error) in
                print("なぜ出ない",snapShot as Any)
                if error != nil{
                    print("エラー")
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    print("配列〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜＾",snapShotDoc)
                    for doc in snapShotDoc {
                        //配列化されたdocのdata内容だけを抽出してdataに入れる
                        let data = doc.data()
                        print("なぜ出ない",data)
                        if let comments = data["comments"] as? String,
                             let Capital = data["capital"] as? Bool,
                                 let yearmount = data["YearMount"] as? String,
                                     let postDateId = data["postDateID"] as? String{
                                        
                                        let item = Memos()
                                            item.Comments = comments
                                            item.PostDateID = postDateId
                                            item.CheckBool = Capital
                                            item.YearMount = yearmount
                                                try! self.realm.write() {
                                                    if self.list == nil {
                                                        let itemList = Itemlist()
                                                        itemList.list.append(item)
                                                        self.realm.add(itemList)
                                                        self.list = self.realm.objects(Itemlist.self).first?.list
                                                    } else {
                                                        self.list.append(item)
                                                    }
                                                }
                        }
                    }
                }
                self.performSegue(withIdentifier: "gotabbar", sender: nil)
            }
        }
    }
}
