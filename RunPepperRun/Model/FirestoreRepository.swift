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
    
    private let userRef = Firestore.firestore().collection(FirestoreCollection.user.rawValue)
    private let historyRef = Firestore.firestore().collection(FirestoreCollection.history.rawValue)
}

// MARK: - User
extension FirestoreRepository {
    func fetchEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    func createUser(_ user: User, completion: ((Bool) -> Void)?) {
        guard let email = fetchEmail() else {
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

// MARK: - History
extension FirestoreRepository {
     func create(_ history: History, completion: ((Bool) -> Void)?) {
        do {
            try historyRef.document().setData(from: history)
            completion?(true)
        } catch {
            NSLog("러닝 내역을 저장하는데 실패했습니다.")
            completion?(false)
        }
    }
    
    func fetchHistories(email: String, limit: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<[DocumentSnapshot], HistoryError>) -> Void) {
        if let lastSnapshot = lastSnapshot {
            historyRef.whereField("email", isEqualTo: email)
                .order(by: "startDate", descending: true)
                .limit(to: 3)
                .start(afterDocument: lastSnapshot)
                .getDocuments { snapshot, error in
                    guard let snapshot = snapshot, error == nil else {
                        NSLog("Snapshot을 가져오는데 실패했습니다.")
                        completion(.failure(HistoryError.failToFetchData))
                        return
                    }
                    completion(.success(snapshot.documents))
                }
        } else {
            historyRef.whereField("email", isEqualTo: email)
                .order(by: "startDate", descending: true)
                .limit(to: 3)
                .getDocuments { snapshot, error in
                    guard let snapshot = snapshot, error == nil else {
                        NSLog("Snapshot을 가져오는데 실패했습니다.")
                        completion(.failure(.failToFetchData))
                        return
                    }
                    completion(.success(snapshot.documents))
                }
        }
    }
    
    func fetchHistories(startDate: Date, endDate: Date, completion: @escaping (Result<[DocumentSnapshot], HistoryError>) -> Void) {
        historyRef
            .whereField("startDate", isGreaterThan: startDate)
            .whereField("endDate", isLessThan: endDate)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    completion(.failure(.failToFetchData))
                    return
                }
                completion(.success(snapshot.documents))
            }
    }
}
