//
//  Item.swift
//  GoMarket
//
//  Created by obss on 17.10.2022.
//

import Foundation
import UIKit


class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}
func saveItemToFirestore (_ item: Item) {
    let id = UUID().uuidString
    item.id = id
    FirebaseReferences(.Items).document(id).setData(itemDictionaryFrom(item) as! [String : Any])
}
//MARK: HelperFUNCTION
func itemDictionaryFrom (_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.name, item.categoryId, item.description, item.price, item.imageLinks], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kCATEGORYID as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
}
func downloadItemsFromFirebase(withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    var itemArray: [Item] = []
    FirebaseReferences(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            for itemDic in snapshot.documents {
                //print("created new category with")
                itemArray.append(Item(_dictionary: itemDic.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
        }
    
}
    
/*func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Item])-> Void ) {
        var itemArray: [Item] = []
        FirebaseReferences(.Items).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(itemArray)
                return
            }
            
            if !snapshot.isEmpty {
                for itemDic in snapshot.documents {
                    //print("created new category with")
                    itemArray.append(Item(_dictionary: itemDic.data() as NSDictionary))
                }
            }
            
            completion(itemArray)
            
        }
        
    }*/

