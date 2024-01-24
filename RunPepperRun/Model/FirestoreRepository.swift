//
//  FirebaseManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreRepository {
    static let shared = FirestoreRepository()
    
    private let userRef = Firestore.firestore().collection(FirestoreCollection.history.rawValue)
}

// MARK: - User
extension FirestoreRepository {
    func getEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    func createUser(_ user: User, completion: ((Bool) -> Void)?) {
        guard let email = getEmail() else {
            completion?(false)
            return
        }
        
        do {
            try userRef.document(email).setData(from: user)
            completion?(true)
        } catch {
            
            print("유저 정보를 Firebase에 저장하는데 실패했습니다.")
            completion?(false)
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
