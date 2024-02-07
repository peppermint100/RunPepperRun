//
//  HistoryManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import Foundation
import FirebaseFirestore

enum HistoryError: Error {
    case failToGetEmail
    case failToFetchData
    case invalidInput
}

class HistoryManager {
    static let shared = HistoryManager()
    let repository = FirestoreRepository.shared
    var isLoading = false
    var lastDocumentSnapshot: DocumentSnapshot?
    
    func create(email: String?, averageSpeed: Double, averagePace: Double, distance: Double, caloriesBurned: Double, numberOfSteps: Int, locations: [Point], startDate: Date, endDate: Date, mapSnapshot: Data
                , completion: ((Bool) -> Void)?) {
        let history = History(
            email: UserManager.shared.getEmail(),
            averageSpeed: averageSpeed, averagePace: averagePace, distance: distance,
            caloriesBurned: caloriesBurned, numberOfSteps: numberOfSteps,
            locations: locations,
            startDate: startDate, endDate: endDate, mapSnapshot: mapSnapshot)
        repository.create(history) { success in
            completion?(true)
        }
    }
    
    func clearDocuments() {
        lastDocumentSnapshot = nil
    }
    
    func getHistories(isPaginating: Bool = false, limit: Int, completion: @escaping (Result<[History], HistoryError>) -> Void) {
        guard let email = UserManager.shared.getEmail() else {
            NSLog("이메일을 읽어오는데 실패했습니다.")
            return completion(.failure(HistoryError.failToGetEmail))
        }
        
        isLoading = isPaginating
        repository.fetchHistories(email: email, limit: limit, lastSnapshot: lastDocumentSnapshot) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let documents):
                if documents.isEmpty {
                    completion(.success([]))
                } else {
                    self?.lastDocumentSnapshot = documents.last
                    let histories = strongSelf.convertSnapshotToHistories(documents: documents)
                    completion(.success(histories))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self?.isLoading = false
        }
    }
    
    func getHistories(from: Date, to: Date, completion: @escaping (Result<[History], HistoryError>) -> Void) {
        repository.fetchHistories(from: from, to: to) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let documents):
                let histories = strongSelf.convertSnapshotToHistories(documents: documents)
                completion(.success(histories))
            case .failure:
                NSLog("Firestore에서 데이터를 가져오는데 실패했습니다.")
                completion(.failure(.failToFetchData))
            }
        }
    }
        
    private func convertSnapshotToHistories(documents: [DocumentSnapshot]) -> [History] {
        var result: [History] = []
        
        for document in documents {
            guard let history = try? document.data(as: History.self) else {
                NSLog("Document를 History로 변환하는데 실패했습니다")
                continue
            }
            result.append(history)
        }
        
        return result
    }
}
