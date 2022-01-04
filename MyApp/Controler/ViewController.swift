//
//  ViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    let memos = Memos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Itemlist.self).first?.list
    }
    @IBAction func Gonext(_ sender: Any) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
}

