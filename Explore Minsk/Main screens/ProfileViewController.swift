//
//  ProfileViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 08.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        if let user = Auth.auth().currentUser {
            db.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snaphot in
                if let data = snaphot.value as? [String: Any], let name = data["name"] as? String, let email = data["email"] as? String {
                    self.nameLabel.text = name
                    self.emailLabel.text = email
                }
            })
        }
        
        profileImage.image = loadImage()
        collectionView.reloadData()
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try? Auth.auth().signOut()
            favorites = []
        }
    }
    
    @objc func editButtonTapped() {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            if let destination = segue.destination as? EditViewController {
                destination.email = emailLabel.text ?? ""
                destination.name = nameLabel.text ?? ""
                destination.image = profileImage.image ?? UIImage(systemName: "person.crop.circle")!
            }
        }
    }

}


extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RewardCollectionViewCell
        
        cell.rewardImage.image = UIImage(named: rewards[indexPath.row])
        
        
        return cell
    }
}
