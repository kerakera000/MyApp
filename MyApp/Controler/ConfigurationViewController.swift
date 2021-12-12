//
//  ConfigurationViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit

class ConfigurationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func logout(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
