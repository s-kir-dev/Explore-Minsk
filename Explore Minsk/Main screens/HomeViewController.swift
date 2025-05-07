//
//  HomeViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var seeAllRecommended: UIButton!
    
    var sortedPlaces: [Place] = Places.locations {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find things to do"
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        recommendedView.delegate = self
        recommendedView.dataSource = self
        
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        collectionView.setContentOffset(.zero, animated: true)
        switch segmented.selectedSegmentIndex {
        case 0:
            sortedPlaces = Places.locations
        case 1:
            sortedPlaces = Places.hotels
        case 2:
            sortedPlaces = Places.food
        case 3:
            sortedPlaces = Places.adventures
        default:
            sortedPlaces = Places.locations
        }
    }


}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == self.collectionView else { return }
        let place = sortedPlaces[indexPath.row]
        
        print("Нажат \(place.name)")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return sortedPlaces.count
        } else {
            return Recommended.recommended.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCollectionViewCell
            
            let place = sortedPlaces[indexPath.row]
            
            cell.layer.cornerRadius = 20
            cell.placeName.layer.cornerRadius = cell.placeName.frame.height / 2
            cell.placeRating.layer.cornerRadius = cell.placeRating.frame.height / 2
            cell.placeName.clipsToBounds = true
            cell.placeRating.clipsToBounds = true
            
            cell.placeImage.image = UIImage(named: place.image)
            cell.placeName.text = place.name
            
            countRating(place: place, showReviews: false, completion: { rating in
                cell.placeRating.text = rating
            })
            
            if favorites.contains(place) {
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.favoriteAction = {
                    favorites.remove(at: favorites.firstIndex(of: place)!)
                    cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            } else {
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.favoriteAction = {
                    favorites.append(place)
                    cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    if favorites.count > 4 && !awards.contains("award3") {
                        awards.append("award3")
                        let alert = UIAlertController(title: "Horray!", message: "You have achieved new medal in your profile!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Horray!", style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendedCollectionViewCell
            
            cell.layer.cornerRadius = 20
            
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 196, height: 253)
        } else {
            return CGSize(width: 200, height: 160)
        }
        
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            switch segmented.selectedSegmentIndex {
            case 0:
                sortedPlaces = Places.locations
            case 1:
                sortedPlaces = Places.hotels
            case 2:
                sortedPlaces = Places.food
            case 3:
                sortedPlaces = Places.adventures
            default:
                sortedPlaces = Places.locations
            }
        } else {
            sortedPlaces = sortedPlaces.filter({ $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) })
        }
    }
}
