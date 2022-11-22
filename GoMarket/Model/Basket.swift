//
//  Basket.swift
//  GoMarket
//
//  Created by obss on 21.11.2022.
//

import Foundation

class Basket {
    
    var id : String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    
    }
    init (_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
}

// MARK: SAVE TO FIREBASE

func saveBasketToFirestore(_ basket: Basket) {
    FirebaseReferences(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
    
}
func basketDictionaryFrom (_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
}

//MARK: - Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
    FirebaseReferences(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}
    func updateBasketInFirestore (_ basket: Basket, withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
        FirebaseReferences(.Basket).document(basket.id).updateData(withValues) { (error) in
            
            completion(error)
        }
            
        }
        
    
    


