//
//  ImageCollectionViewCell.swift
//  GoMarket
//
//  Created by obss on 15.11.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    func setupImageWith(itemImage: UIImage) {
        imageView.image = itemImage
    }
}
