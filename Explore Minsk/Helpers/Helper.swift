//
//  Helper.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

let db = Database.database().reference()

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let startVC = storyboard.instantiateViewController(withIdentifier: "startVC")

let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController

enum Facilities: String, Codable {
    case wifi = "Wifi"
    case parking = "Parking"
    case restaurant = "Restaurant"
    case sauna = "Sauna"
    case gym = "Gym"
    case pool = "Pool"
    case elevator = "Elevator"
}

enum PlaceType: String, Codable {
    case location = "Location"
    case hotels = "Hotels"
    case food = "Food"
    case adventure = "Adventure"
}

struct Place: Codable, Equatable {
    let name: String
    let description: String
    let image: String
    var rating: Double
    let recommendedTime: String
    let address: String
    let phoneNumber: String
    let facilities: [Facilities]
    let type: PlaceType
    let budget: Int
    let openTime: String
    var myRate: Int
    let documentID: String
    let userID: String
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Places: Codable {
    static var locations: [Place] = [
        Place(name: "Troitskoe suburb", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "троицкое", rating: 0, recommendedTime: "1-2 hours", address: "Lenina Street 70", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "National library", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "библиотека", rating: 0, recommendedTime: "1-2 hours", address: "Lenina Street 30", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Museum of the Great Patriotic War History", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "музей ВОВ", rating: 0, recommendedTime: "2-3 hours", address: "Lenina Street 40", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Bolshoy Theater of Belarus", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "театр", rating: 0, recommendedTime: "1-2 hours", address: "Lenina Street 50", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "National Art Museum", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "национальный музей", rating: 0, recommendedTime: "1-2 hours", address: "Lenina Street 20", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Komarovskyi market", description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.", image: "комаровский рынок", rating: 0, recommendedTime: "1-2 hours", address: "Lenina Street 60", phoneNumber: "+375-17-3970163", facilities: [], type: .location, budget: 0, openTime: "", myRate: 0, documentID: "", userID: "")
    ]
    static var hotels: [Place] = [
        Place(name: "Mariott", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "мариотт", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "DoubleTree by Hilton Hotel", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "хилтон", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Minsk Hotel", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "минск", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "President Hotel", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "президент", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Hotel Victoria", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "виктория", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Hotel Pekin", description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.", image: "пекин", rating: 0, recommendedTime: "", address: "", phoneNumber: "", facilities: [.wifi, .restaurant, .sauna, .pool], type: .hotels, budget: 0, openTime: "", myRate: 0, documentID: "", userID: "")
    ]
    static var food: [Place] = [
        Place(name: "Zolotoy Grebeshok", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "золотой", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 29, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Ember", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "эмбер", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 30, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Grand Cafe", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "гранд", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 35, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Chainyi Pyanica", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "чайный", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 25, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Pena Dney", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "пена", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 26, openTime: "", myRate: 0, documentID: "", userID: ""),
        Place(name: "Restaurant Malevich", description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.", image: "малевич", rating: 0, recommendedTime: "", address: "Pobeditelei Ave., 9 | 7th Floor", phoneNumber: "+375-44-507-17-29", facilities: [], type: .food, budget: 34, openTime: "", myRate: 0, documentID: "", userID: "")
    ]
    static var adventures: [Place] = [
        Place(name: "Adventure Park", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "парк развлечений", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: ""),
        Place(name: "Minsk Zoo", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "зоопарк", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: ""),
        Place(name: "Zipline", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "зиплайн", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: ""),
        Place(name: "Ninja Park", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "ниндзя парк", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: ""),
        Place(name: "Avalon VR", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "авалон", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: ""),
        Place(name: "Neurobox", description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.", image: "нейробокс", rating: 0, recommendedTime: "", address: "Tashkentskaya St., 40", phoneNumber: "+375-44-507-17-29", facilities: [], type: .adventure, budget: 0, openTime: "10:00-20:00", myRate: 0, documentID: "", userID: "")
    ]
}

var favorites = [Place]()

func uploadFavorites() {
    UserDefaults.standard.set(try? JSONEncoder().encode(favorites), forKey: "favorites-\(Auth.auth().currentUser!.uid)")
}

func downloadFavorites() {
    if let savedData = UserDefaults.standard.data(forKey: "favorites-\(Auth.auth().currentUser!.uid)") {
        favorites = try! JSONDecoder().decode([Place].self, from: savedData)
    }
}

struct RecommendedData: Codable {
    let image: String
    let name: String
    let typeImage: String
    let type: String
}

struct Recommended: Codable {
    static var recommended: [RecommendedData] = [
        RecommendedData(image: "вокзал", name: "Explore Minsk", typeImage: "arrow", type: "Hot Deal"),
        RecommendedData(image: "раубичи", name: "Luxurious Minsk", typeImage: "arrow", type: "Hot Deal"),
        RecommendedData(image: "вокзал", name: "Explore Minsk", typeImage: "arrow", type: "Hot Deal"),
        RecommendedData(image: "раубичи", name: "Luxurious Minsk", typeImage: "arrow", type: "Hot Deal"),
    ]
}


func countRating(place: Place, showReviews: Bool, completion: @escaping (String) -> Void) {
    var kolvo = 0
    var summa = 0
    
    db.child("ratings").child(place.name).observeSingleEvent(of: .value, with: { snaphot in
        
        kolvo = Int(snaphot.childrenCount)
        let group = DispatchGroup()
        
        for child in snaphot.children {
            group.enter()
            guard let userSnaphot = child as? DataSnapshot else { continue }
            
            db.child("ratings").child(place.name).child(userSnaphot.key).observeSingleEvent(of: .value, with: { snaphot in
                
                defer { group.leave() }
                
                guard let value = snaphot.value as? [String: Any], let myRate = value["myRate"] as? Int else { return }
                summa += myRate
            })
        }
        
        group.notify(queue: .main) {
            if kolvo > 0 {
                let rating = Double(summa) / Double(kolvo)
                let roundedRating = Double(rating*100).rounded()/100
                if showReviews {
                    completion("⭐️\(roundedRating) (\(kolvo)K Reviews)")
                } else {
                    completion("⭐️\(roundedRating)")
                }
            } else {
                if showReviews {
                    completion("⭐️0 (0K Reviews)")
                } else {
                    completion("⭐️0")
                }
            }
        }
    })
}


var rewards: [String] = []
