//
//  ItemTableViewCell.swift
//  GoMarket
//
//  Created by obss on 7.11.2022.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(_ item: Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        
        //TODO: Download Image
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImage(imageUrls: [item.imageLinks.first!]) { (images) in
                self.itemImage.image = images.first as? UIImage
            }
        }
        
    }

}
