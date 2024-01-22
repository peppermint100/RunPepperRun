//
//  User.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/19/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserManager {
    static let shared = UserManager()
    let userRef = Firestore.firestore().collection(FirestoreCollection.user.rawValue)
    
    func getEmail() -> String? {
        let currentUser = Auth.auth().currentUser
        return currentUser?.email
    }
    
    func createUser(nickname: String, weight: Double, completion: ((Bool) -> Void)?) {
        guard let email = getEmail() else {
            completion?(false)
            return
        }
        
        let user = User(nickname: nickname, weight: weight)
        
        do {
            try userRef.document(email).setData(from: user)
            completion?(true)
        } catch {
            completion?(false)
            print("유저 정보를 Firebase에 저장하는데 실패했습니다.")
        }
    }
    
    func exists(email: String, completion: @escaping (Bool) -> Void) {
        userRef.document(email).getDocument { document, error in
            guard error == nil, let document = document else {
                completion(false)
                return
            }
            
            completion(document.exists)
        }
    }
}
