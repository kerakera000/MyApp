//
//  TemporaryRegistrationViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/14.
//

import UIKit
import RealmSwift

class TemporaryRegistrationViewController: UIViewController,UIWindowSceneDelegate {
    
    var Mail = ""
    var Name = ""
    var Password = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("temporaのメールチェックviewdidload")
    }
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().currentUser?.reload()
    }
    @IBAction func Check(_ sender: Any) {
        
        Auth.auth().currentUser?.reload()
        let User = Auth.auth().currentUser?.isEmailVerified
        if User == false {
            reloadUser()
        }
        print(User as Any)
        
        if User == true {
            //メイン画面遷移
            nextview()
        }else{
            print("ユーザーなし")
            //このまま
        }
    }
    func reloadUser() {
        let User = Auth.auth().currentUser?.isEmailVerified
        print(User as Any)
        if User == false {
            Auth.auth().currentUser?.reload()
        }
    }
    
    @IBAction func Retransmission(_ sender: Any) {
        let Mail = Mail
        let Name = Name
        let Password = Password
        Auth.auth().createUser(withEmail: Mail, password: Password) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user {
                let req = user.createProfileChangeRequest()
                req.displayName = Name
                req.commitChanges() { [weak self] error in
                    guard let self = self else { return }
                    if error == nil {
                        user.sendEmailVerification() { [weak self] error in
                            guard let self = self else { return }
                            if error == nil {
                                // 仮登録完了画面へ遷移する処理
                                
                            }
                            self.showErrorIfNeeded(error)
                        }
                    }
                    self.showErrorIfNeeded(error)
                }
            }
            self.showErrorIfNeeded(error)
        }
    }
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard errorOrNil != nil else { return }
        
        let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func nextview() {
        performSegue(withIdentifier: "tabbar", sender: nil)
    }
    
}
