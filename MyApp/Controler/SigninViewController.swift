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
    
    let Uid = Auth.auth().currentUser?.uid
    var realm = try! Realm()
    var list: List<Memos>!
    let db = Firestore.firestore()
    
    //appデリゲート内のクライアントIDを取得
    let SignInConfig = AppDelegate.signInConfig
    let FBAuth = FirebaseAuth.Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Itemlist.self).first?.list
    }
    @IBAction func skip(_ sender: Any) {
        FBAuth.signInAnonymously() { authResult, error in
            guard let user = authResult?.user else {
                return
            }
            print("匿名ログイン")
            self.performSegue(withIdentifier: "Tabbar", sender: nil)
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
            }
            Realmset()
            sendProfileDB()
            
            func sendProfileDB() {
                guard let uid = self.FBAuth.currentUser?.uid else { return }
                
                let docData = ["email": email as Any, "name": Name as Any] as [String : Any]
                let userRef = Firestore.firestore().collection("newuser").document(uid)
                
                userRef.setData(docData)
                self.performSegue(withIdentifier: "Tabbar", sender: nil)
                
            }
            func Realmset(){
                print("きたよーーーーーーー")
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                self.db.collection("newuser").document(uid).collection("memo").order(by: "postDateID").addSnapshotListener{(snapShot, error) in
                    print("なぜ出ない",snapShot as Any)
                    if error != nil{
                        print("エラー")
                        return
                    }
                    if let snapShotDoc = snapShot?.documents{
                        for doc in snapShotDoc {
                            //配列化されたdocのdata内容だけを抽出してdataに入れる
                            let data = doc.data()
                            
                            let memos = Memos()
                            memos.CheckBool = data["capital"] as! Bool
                            memos.PostDateID = data["postDateID"] as? String
                            memos.Comments = data["comments"] as? String
                            memos.YearMount = data["YearMount"] as? String
                            
                            try! self.realm.write() {
                                if self.list == nil {
                                    print("true")
                                let itemList = Itemlist()
                                    itemList.list.append(memos)
                                    self.realm.add(itemList)
                                    self.list = self.realm.objects(Itemlist.self).first?.list
                                        } else {
                                        print("else")
                                        self.list.append(memos)
                                    }
                            }
                            print("なぜ出ない",data)
                        }
                    }
                    self.performSegue(withIdentifier: "Tabbar", sender: nil)
                }
            }
        }
    }
}
