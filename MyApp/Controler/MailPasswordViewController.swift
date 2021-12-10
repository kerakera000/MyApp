//
//  MailPasswordViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit

class MailPasswordViewController: UIViewController {
    
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var Button: UIButton!
    var MailText = ""
    var Passwordtext = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PasswordTextField.layer.borderWidth = 1.0
    }
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Signin(_ sender: Any) {
        if let MailText = MailText as? String {
            if let PassWord = Passwordtext as? String{
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                tabBarController.selectedIndex = 0
                self.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoAllList" {
            let nextView = segue.destination as! AllListViewController
            nextView.emailtext = MailText
            nextView.passwordtest = Passwordtext
        }
    }
}
