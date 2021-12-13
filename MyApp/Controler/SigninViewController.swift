//
//  SigninViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import RealmSwift
import FirebaseFirestore

class SigninViewController: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    var realm = try! Realm()
    var list: List<Memos>!
    let db = Firestore.firestore()
    
    
    //appデリゲート内のクライアントIDを取得
    let SignInConfig = AppDelegate.signInConfig
    let FBAuth = FirebaseAuth.Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
       //
    }
    @IBAction func skip(_ sender: Any) {
        FBAuth.signInAnonymously() { authResult, error in
            guard let user = authResult?.user else {
                return
            }
            print(user.uid)
            print("匿名ログイン")
            self.realmset()
        }
    }
    @IBAction func GoogleAuth(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: SignInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            guard let user = user else { return }
            let email = user.profile?.email
            let Name = user.profile?.name
            
            let authentication = user.authentication
                // Googleのトークンを渡し、Firebaseクレデンシャルを取得する。
            let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!,accessToken: (authentication.accessToken))

                // Firebaseにログインする。
                self.FBAuth.signIn(with: credential) { (user, error) in
                    print("ログイン成功")
                    print(self.uid as Any)
                    self.realmset()
                    sendProfileDB()
            }
            func sendProfileDB() {
                guard let uid = self.FBAuth.currentUser?.uid else { return }
                
                let docData = ["email": email as Any, "name": Name as Any] as [String : Any]
                let userRef = Firestore.firestore().collection("newuser").document(uid)
                
                userRef.setData(docData)
            }
        }
    }
    func realmset(){
        print("realmリセット")
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
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
            tabBarController.selectedIndex = 0
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    
}
