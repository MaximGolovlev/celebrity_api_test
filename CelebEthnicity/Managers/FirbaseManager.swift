//
//  FirbaseManager.swift
//  CelebEthnicity
//
//  Created by User on 22.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Firebase

class FirbaseManager {
    
    typealias ResponseArray = ([Celebrity]?, Error?) -> ()
    typealias Response = (Celebrity?, Error?) -> ()
    
    var lastSnapshot: QueryDocumentSnapshot?
    
    let db: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()

    func fetchCelebrity(name: String, completion: @escaping Response) {
        
        let docRef = db.collection("cities").document(name)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let json = document?.data() {
                let celeb = Celebrity(JSON: json)
                completion(celeb, nil)
                
            } else {
                completion(nil, ErrorType.retrevingError(message: "Error retreving celebrities"))
            }
        }
        
    }
    
    func fetchCelebrities(limit: Int, orderedBy: String? = nil, completion: @escaping ResponseArray) {
        
        var first = db.collection("celebrities").limit(to: limit)
        
        if let query = orderedBy {
            first = first.order(by: query)
        }
        
        first.addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                let errorMessage = "Error retreving celebrities: \(error.debugDescription)"
                print(errorMessage)
                completion(nil, ErrorType.retrevingError(message: errorMessage))
                return
            }
            
            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                completion(nil, nil)
                return
            }
            
            self?.lastSnapshot = lastSnapshot
            
            let celebs = snapshot.documents.compactMap({ Celebrity(JSON: $0.data()) })
            completion(celebs, nil)
            
        }
        
    }
    
}
