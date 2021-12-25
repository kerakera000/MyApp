//
//  ViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser()
        print("temporaのメールチェックviewdidload")
    }
    func checkUser() {
//        if Auth.auth().currentUser?.uid != nil{
//            performSegue(withIdentifier: "next", sender: nil)
//        }else{
//            print("ログインしてない")
//        }
    }
    @IBAction func Gonext(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
}

