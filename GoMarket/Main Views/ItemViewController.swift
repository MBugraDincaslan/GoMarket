//
//  ItemViewController.swift
//  GoMarket
//
//  Created by obss on 15.11.2022.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelTwo: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let cellHeight: CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1
    
    
    
    //MARK: ViewLifeCYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        dowloadImages()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
    }
    private func dowloadImages() {
        if item != nil && item.imageLinks != nil {
            downloadImage(imageUrls: item.imageLinks) { (allimages) in
                if allimages.count > 0 {
                    self.itemImages = allimages as! [UIImage]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setupUI() {
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabelTwo.text = convertToCurrency(item.price)
            descriptionText.text = item.description
        }
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addToBasketButtonPressed() {
        downloadBasketFromFirestore("1234") { (basket) in
                   
                   if basket == nil {
                       self.createnewBasket()
                   } else {
                       basket!.itemIds.append(self.item.id)
                       self.updateBasket(basket: basket!, withValues: [kITEMIDS : basket!.itemIds])
                   }
               }

    }
    //MARK: Add to basket
    private func createnewBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to Basket!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func updateBasket(basket: Basket, withValues: [String: Any]) {
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
                   
                   if error != nil {
                       
                       self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                       self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                       self.hud.show(in: self.view)
                       self.hud.dismiss(afterDelay: 2.0)

                       print("error updating basket", error!.localizedDescription)
                   } else {
                       
                       self.hud.textLabel.text = "Added to basket!"
                       self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                       self.hud.show(in: self.view)
                       self.hud.dismiss(afterDelay: 2.0)
                   }
               }

        
    }
}
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        
        return cell
    }
    
  
    
}
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avaiableVidth = collectionView.frame.width - sectionInsets.left
        
        return CGSize(width: avaiableVidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
