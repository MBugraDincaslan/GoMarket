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
            
            self.hud.textLabel.text = "ALL FIELD ARE REQUIRED!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
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
        showLoadingIndicator()
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
                self.hideLoadingIndicator()
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndıcator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballTrianglePath, color: #colorLiteral(red: 0.98, green: 0.49, blue: 0.47, alpha: 1) , padding: nil)
    }
    

    
    private func showLoadingIndicator() {
        if activityIndıcator != nil {
            self.view.addSubview(activityIndıcator!)
            activityIndıcator!.startAnimating()
        }
    }
    private func hideLoadingIndicator() {
        if activityIndıcator != nil {
            self.view.removeFromSuperview()
            activityIndıcator!.stopAnimating()
        }
    }
    
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
