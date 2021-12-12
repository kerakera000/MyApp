//
//  ViewController.swift
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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser()
    }
    func checkUser() {
        if Auth.auth().currentUser?.uid != nil{
            performSegue(withIdentifier: "next", sender: nil)
        }else{
            print("ログインしてない")
        }
        
    }
    @IBAction func Gonext(_ sender: Any) {
        performSegue(withIdentifier: "Next", sender: nil)
    }
    
}

