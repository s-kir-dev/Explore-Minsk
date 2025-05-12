//
//  EditViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 12.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var name = String()
    var email = String()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        profileImage.image = image
        nameTextField.text = name
        emailTextField.text = email
        
        changeImageButton.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
        saveChangesButton.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
    }
    
    @objc func changeImageTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func saveChangesTapped() {
        db.child("users").child(Auth.auth().currentUser!.uid).updateChildValues([
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? ""
        ])
        saveImageLocally(image: profileImage.image!)
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Успешно", message: "Данные аккаунта успешно изменены", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    

    func saveImageLocally(image: UIImage) {
        guard let data = image.pngData(), let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let path = directory.appendingPathComponent("image-\(Auth.auth().currentUser!.uid).png")
        
        do {
            try data.write(to: path)
            
            UserDefaults.standard.set(path.path, forKey: "image-\(Auth.auth().currentUser!.uid).png")
        } catch {
            print("Ошибка: \(error)")
        }
    }

}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImage.image = selectedImage
            self.dismiss(animated: true)
        }
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
