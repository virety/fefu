//
//  CompositionalLayoutCell.swift
//  fefu
//
//  Created by Вадим Семибратов on 28.11.2024.
//


import UIKit

class CompositionalLayoutCell: UICollectionViewCell {
    @IBOutlet weak var ActivityName: UILabel!
    @IBOutlet weak var ActivityImage: UIImageView!
    
    static let reuseId = "CompositionalLayoutCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        isSelected = false
        self.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 2 : 1
            self.layer.borderColor = isSelected ? UIColor.systemPurple.cgColor : UIColor.lightGray.cgColor
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CompositionalLayoutCell", bundle: nil)
    }
    
    func configure(title: String, image: UIImage) {
        ActivityName.text = title
        ActivityImage.image = image
    }
}
