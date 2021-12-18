//
//  SendDBModel.swift
//  MyApp
//
//  Created by kerakera on 2021/12/18.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SendDBModel {
    var email = ""
    var Name = ""
    let FBAuth = FirebaseAuth.Auth.auth()

    func sendProfileDB() {
        guard let uid = FBAuth.currentUser?.uid else { return }
        
        let docData = ["email": email as Any, "name": Name as Any] as [String : Any]
        let userRef = Firestore.firestore().collection("newuser").document(uid)
        
        userRef.setData(docData)
        email = ""
        Name = ""
    }
}
