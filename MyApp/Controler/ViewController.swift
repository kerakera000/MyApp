//
//  ViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var list: List<Memos>!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("temporaのメールチェックviewdidload")
    }
    @IBAction func Gonext(_ sender: Any) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
}

