//
//  MailSignupViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/14.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift
import FirebaseFirestore

class MailSignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MailTextfield: TextField!
    @IBOutlet weak var NameTextField: TextField!
    @IBOutlet weak var PasswordTextField: TextField!
    @IBOutlet weak var Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        MailTextfield.delegate = self
        NameTextField.delegate = self
        PasswordTextField.delegate = self
        
        MailTextfield.layer.borderColor = UIColor.white.cgColor
        NameTextField.layer.borderColor = UIColor.white.cgColor
        PasswordTextField.layer.borderColor = UIColor.white.cgColor
        
    }
    
    //signup
    @IBAction private func didTapSignUpButton() {
        let email = MailTextfield.text ?? ""
            let password = PasswordTextField.text ?? ""
            let name = NameTextField.text ?? ""
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                if let user = result?.user {
                    let req = user.createProfileChangeRequest()
                    req.displayName = name
                    req.commitChanges() { [weak self] error in
                        guard let self = self else { return }
                        if error == nil {
                            user.sendEmailVerification() { [weak self] error in
                                guard let self = self else { return }
                                if error == nil {
                                    // 仮登録完了画面へ遷移する処理
                                    self.performSegue(withIdentifier: "next", sender: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "next" {
                let nextVC = segue.destination as! TemporaryRegistrationViewController
                nextVC.Mail = MailTextfield.text!
                nextVC.Name = NameTextField.text!
                nextVC.Password = PasswordTextField.text!
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
}
