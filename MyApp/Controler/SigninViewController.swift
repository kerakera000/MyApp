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
                    let sendDB = SendDBModel()
                    sendDB.Name = Name!
                    sendDB.email = email!
                    sendDB.sendProfileDB()
                    
                    let LoadDB = LoadDBModel()
                    LoadDB.realmset()
                    
                    let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                    tabBarController.selectedIndex = 0
                    self.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
}
