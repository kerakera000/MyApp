//
//  MailsigninViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit

class MailsigninViewController: UIViewController {

    @IBOutlet weak var MailTextfield: UITextField!
    @IBOutlet weak var Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MailTextfield.layer.borderWidth = 1.0
    }
    @IBAction func gonext(_ sender: Any) {
        if MailTextfield.text == ""{
            Button.isEnabled = true
        } else {
            self.performSegue(withIdentifier: "topassword", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topassword" {
            let nextView = segue.destination as! MailPasswordViewController
            nextView.MailText = MailTextfield.text!
            MailTextfield.text = ""
        }
    }
    
}
