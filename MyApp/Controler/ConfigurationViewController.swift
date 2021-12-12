//
//  ConfigurationViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import FirebaseAuth
import Firebase

class ConfigurationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func logout(_ sender: Any) {
        print("ok")
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            guard let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "firstview") else { return  } 
            self.present(tabBarController, animated: true, completion: nil)
        }catch let error as NSError {
            print("エラー",error)
        }
    }
    
}
