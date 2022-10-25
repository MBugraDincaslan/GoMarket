//
//  ItemAddViewController.swift
//  GoMarket
//
//  Created by obss on 20.10.2022.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class ItemAddViewController: UIViewController {
    
    
    //MARK: TEXTFIELD
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    //MARK: Buttons and BackgroundTapped
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if fieldAreCompleted() {
            saveToFirebase()
        } else {
            print("Error All Fields Are Required")
        }
    }
    @IBAction func cameraButton(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: HELPER FUNC
    private func fieldAreCompleted () -> Bool {
        
        return (itemTextField.text != "" && priceTextField.text != "" && descriptionTextField.text != "")
    }
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    private func saveToFirebase() {
        let item = Item()
        item.id = UUID().uuidString
        item.name = itemTextField.text!
        item.price = Double(priceTextField.text!)
        item.categoryId = category?.id
        item.description = descriptionTextField.text!
        
        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemId: item.id) { (imageLikArray) in
                item.imageLinks = imageLikArray
                    
                    saveItemToFirestore(item)
                    self.popTheView()
                
            }
                
            
      
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
        
    }
    
    //MARK: VARS
    var category: Category!
    var itemImages: [UIImage?] = []
    
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndıcator: NVActivityIndicatorView?
    
    //var ıtemImages: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(category?.id)

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

   
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToAddItem" {
            let vc = segue.destination as! ItemAddViewController
            vc.category = category!
        }
    }*/

    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
        
    }

}
extension ItemAddViewController: GalleryControllerDelegate {
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
