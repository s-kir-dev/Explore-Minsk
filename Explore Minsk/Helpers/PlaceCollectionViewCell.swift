//
//  PlaceCollectionViewCell.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteAction: (() -> Void)?
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteAction?()
        uploadFavorites()
    }
}
