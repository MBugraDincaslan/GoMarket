//
//  FirebaseCollectionReference.swift
//  GoMarket
//
//  Created by obss on 6.10.2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
    
}

func FirebaseReferences(_ collectionRefence: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRefence.rawValue)
}
