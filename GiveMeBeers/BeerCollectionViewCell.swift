//
//  BeerCollectionViewCell.swift
//  GiveMeBeers
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Kingfisher

final class BeerCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        nameLabel.text = nil
    }
    
    func update(data: Beer) {
        imageView.kf.setImage(with: URL(string: data.image_url))
        nameLabel.text = data.name
    }
}
