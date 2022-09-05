//
//  LoginSignup.swift
//  Kimusic
//
//  Created by Hieu Le Pham Ngoc on 31/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
let db = Firestore.firestore()

func signup(email: String, password: String){
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if error != nil{
        print(error!.localizedDescription)
            return
        }

        db.collection("users").document((authResult?.user.uid)!).setData([
            "email": (authResult?.user.email)!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

    }
    
}

func login(email: String, password: String){
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if error != nil{
        print(error!.localizedDescription)
        }
    }
}

func currentUser() -> FirebaseAuth.User?{
    return Auth.auth().currentUser

}

