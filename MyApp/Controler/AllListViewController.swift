//
//  AllListViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit

class AllListViewController: UIViewController {
    var passwordtest = ""
    var emailtext = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func NewList(_ sender: Any) {
        self.performSegue(withIdentifier: "ToNewmemo", sender: nil)
    }
}
