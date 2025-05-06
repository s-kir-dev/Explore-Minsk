//
//  Helper.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 06.05.2025.
//

import Foundation
import UIKit
import FirebaseDatabase

let db = Database.database().reference()

var userID = ""

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let startVC = storyboard.instantiateViewController(withIdentifier: "startVC") as! UIViewController

let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController


