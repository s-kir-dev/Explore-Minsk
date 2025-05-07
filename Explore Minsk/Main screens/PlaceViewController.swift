//
//  PlaceViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 07.05.2025.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var facilitiesView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var floatLabel: UILabel!
    @IBOutlet weak var floatLabelValue: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var firstStar: UIButton!
    @IBOutlet weak var secondStar: UIButton!
    @IBOutlet weak var thirdStar: UIButton!
    @IBOutlet weak var fourthStar: UIButton!
    @IBOutlet weak var fifthStar: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    var place: Place = Places.locations[0]
    
    var stars: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stars = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        
        for star in stars {
            star.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        }
        
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        placeImage.layer.cornerRadius = 20
        placeImage.clipsToBounds = true
        
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        
        if favorites.contains(place) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        setupUI(type: place.type)
    }
    
    @objc func favoriteButtonTapped() {
        if favorites.contains(place) {
            favorites.remove(at: favorites.firstIndex(of: place)!)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            if favorites.count > 4 && !rewards.contains("award3") {
                rewards.append("award3")
                let alert = UIAlertController(title: "Horray!", message: "You have achieved new medal in your profile!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Horray!", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        } else {
            favorites.append(place)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        uploadFavorites()
    }
    
    @objc func readMoreButtonTapped() {
        if let url = URL(string: "https://www.google.com/search?q=\(place.name)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func starTapped(sender: UIButton) {
        if let selectedIndex = stars.firstIndex(of: sender) {
            fillStars(selectedIndex: selectedIndex)
        }
    }
    
    @objc func rateButtonTapped() {
        rateButton.isEnabled = false
        db.child("ratings").child(place.name).child(userID).setValue([
            "myRate": place.myRate
        ])
        countRating(place: place, showReviews: true) { rating in
            self.placeRating.text = "\(rating)"
        }
    }
    
    func fillStars(selectedIndex: Int) {
        var rating = 0
        for (index, star) in stars.enumerated() {
            if index <= selectedIndex {
                star.setImage(UIImage(systemName: "star.fill"), for: .normal)
                rating += 1
            } else {
                star.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        place.myRate = rating
        rateButton.isEnabled = true
    }
    
    func setMyRate() {
        db.child("ratings").child(place.name).child(userID).observeSingleEvent(of: .value, with: { snaphot in
            if let value = snaphot.value as? [String: Any] {
                if let myRate = value["myRate"] as? Int {
                    self.place.myRate = myRate
                    self.fillStars(selectedIndex: myRate-1)
                }
            }
        })
    }
    
    func setupUI(type: PlaceType) {
        placeImage.image = UIImage(named: place.image)
        placeName.text = place.name
        placeDescription.text = place.description
        countRating(place: place, showReviews: true) { rating in
            self.placeRating.text = "\(rating)"
        }
        setMyRate()
        switch type {
        case .location:
            infoView.isHidden = false
            facilitiesView.isHidden = true
            floatLabel.text = "Recommended sightseeing time"
            floatLabelValue.text = place.recommendedTime
            
        case .hotels:
            infoView.isHidden = true
            facilitiesView.isHidden = false
            
            //collectionView.reloadData()
        case.food:
            infoView.isHidden = false
            facilitiesView.isHidden = true
            floatLabel.text = "Budget"
            floatLabelValue.text = "~\(place.budget)$"
        case.adventure:
            infoView.isHidden = false
            facilitiesView.isHidden = true
            floatLabel.text = "Open time"
            floatLabelValue.text = place.openTime
        }
        
    }
    
   
}


extension PlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension PlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        place.facilities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FacilitiesCollectionViewCell
        
        cell.image.image = UIImage(systemName: "wifi")
        cell.name.text = place.facilities[indexPath.row].rawValue
        
        return cell
    }
}
