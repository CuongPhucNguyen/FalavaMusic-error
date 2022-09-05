//
//  LoginSignup.swift
//  Kimusic
//
//  Created by Hieu Le Pham Ngoc on 31/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
let db = Firestore.firestore()

func signup(email: String, password: String, displayName: String, photoURL: String){
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if error != nil{
            print(error!.localizedDescription)
            return
        }
        let newUser = AppUser(name: displayName, photoURL: photoURL , email: email, followers: 0, following: 0, friendList: ["friend"], playlists: ["test": [""]])
        do {
            try db.collection("users").document(email).setData(from: newUser)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
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

func currentUser() -> AppUser?{
    let Ref = db.collection("users").document(Auth.auth().currentUser!.email!)
    var res : AppUser? = nil
    // Create a query against the collection.
    Ref.getDocument(as: AppUser.self) { result in
        // The Result type encapsulates deserialization errors or
        // successful deserialization, and can be handled as follows:
        //
        //      Result
        //        /\
        //   Error  City
        switch result {
        case .success(let user):
            // A `City` value was successfully initialized from the DocumentSnapshot.
            print("User: \(user.name)")
            res = user
        case .failure(let error):
            // A `City` value could not be initialized from the DocumentSnapshot.
            print("Error decoding User: \(error)")
        }
    }
    return res
    
}

