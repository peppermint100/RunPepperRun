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
}

class HistoryManager {
    static let shared = HistoryManager()
    let repository = FirestoreRepository.shared
    var isLoading = false
    var lastDocumentSnapshot: DocumentSnapshot?
    
    func create(_ history: History, completion: ((Bool) -> Void)?) {
        repository.create(history) { success in
            completion?(true)
        }
    }
    
    func clearDocuments() {
        lastDocumentSnapshot = nil
    }
    
    func getHistories(isPaginating: Bool = false, limit: Int, completion: @escaping (Result<[History], HistoryError>) -> Void) {
        isLoading = isPaginating
        repository.fetchHistories(limit: limit, lastSnapshot: lastDocumentSnapshot) { [weak self] result in
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
