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
    
    let repository = FirestoreRepository.shared
    
    func getEmail() -> String? {
        return repository.fetchEmail()
    }
    
    func createUser(nickname: String, weight: Double, completion: ((Bool) -> Void)?) {
        repository.createUser(User(nickname: nickname, weight: weight)) { success in
            completion?(success)
        }
    }
    
    func exists(email: String, completion: @escaping (Bool) -> Void) {
        repository.exists(email: email) { exists in
            completion(exists)
        }
    }
}
