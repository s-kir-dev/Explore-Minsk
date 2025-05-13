//
//  SettingsViewController.swift
//  Explore Minsk
//
//  Created by Кирилл Сысоев on 13.05.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var aboutAppView: UIView!
    @IBOutlet weak var lightTheme: UISwitch!
    @IBOutlet weak var darkTheme: UISwitch!
    @IBOutlet weak var systemTheme: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        languageView.layer.borderColor = UIColor.systemGray.cgColor
        languageView.layer.borderWidth = 1
        languageView.layer.cornerRadius = 5

        setupLanguageMenu()

        let savedTheme = UIUserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: "AppTheme"))
        updateTheme(theme: savedTheme ?? .unspecified)
    }


    @IBAction func lightTheme(_ sender: UISwitch) {
        updateTheme(theme: .light)
    }

    @IBAction func darkTheme(_ sender: UISwitch) {
        updateTheme(theme: .dark)
    }

    @IBAction func systemTheme(_ sender: UISwitch) {
        updateTheme(theme: .unspecified)
    }

    func updateTheme(theme: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme
        }

        lightTheme.setOn(theme == .light, animated: true)
        darkTheme.setOn(theme == .dark, animated: true)
        systemTheme.setOn(theme == .unspecified, animated: true)

        UserDefaults.standard.set(theme.rawValue, forKey: "AppTheme")
    }


    func setupLanguageMenu() {
        let englishLanguage = UIAction(title: "English") { _ in
            self.setLanguage("en")
        }

        let russianLanguage = UIAction(title: "Русский") { _ in
            self.setLanguage("ru")
        }

        let menu = UIMenu(title: "Выбор языка", options: .displayInline, children: [englishLanguage, russianLanguage])
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
    }

    func setLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        let alert = UIAlertController(title: "Language Changed",
                                      message: "Please restart the app to apply changes.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oк", style: .default))
        present(alert, animated: true)
    }
}
