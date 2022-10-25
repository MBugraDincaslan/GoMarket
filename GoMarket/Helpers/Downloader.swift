//
//  Downloader.swift
//  GoMarket
//
//  Created by obss on 24.10.2022.
//

import Foundation
import FirebaseStorage


let storaged = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    if Reachabilty.HasConnection() {
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.1)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { imageLinks in
                
                if imageLinks != nil {
                    imageLinkArray.append(imageLinks!)
                    uploadedImagesCount += 1
                    if uploadedImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
                nameSuffix += 1
            }
    } else {
        print("No Internet Connection!")
        
    }
}

    func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLinks: String?) -> Void) {
        var task: StorageUploadTask!
        let storageRef = storaged.reference(forURL: kFILEREFENCE).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("Error Uploading Image", error!.localizedDescription)
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
    }

