//
//  NewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 22.11.2024.
//

import UIKit
import CoreData

class NewController: UIViewController {

    @IBOutlet weak var toolbarRegistration: UIToolbar!
    @IBOutlet weak var btn_select_gender: UIButton!
    @IBOutlet weak var downlogo: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtNickname: UITextField! // Добавляем поле для ника

    var selectedGender: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка высоты toolbar
        let toolbarHeight: CGFloat = 140.0
        var toolbarFrame = toolbarRegistration.frame
        toolbarFrame.size.height = toolbarHeight
        toolbarRegistration.frame = toolbarFrame
        toolbarRegistration.autoresizingMask = .flexibleWidth
        
        // Инициализация логотипа
        downlogo.image = UIImage(named: "downlogo")
        
        // Настройка меню выбора пола
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Мужчина", handler: { _ in self.updateGender("Мужчина") }),
            UIAction(title: "Женщина", handler: { _ in self.updateGender("Женщина") }),
        ])
        
        btn_select_gender.menu = menu
        btn_select_gender.showsMenuAsPrimaryAction = true
        
        // Настройка кнопки возврата
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func updateGender(_ gender: String) {
        selectedGender = gender
        btn_select_gender.setTitle(gender, for: .normal)
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        // Проверяем данные перед регистрацией
        guard let username = txtUsername.text, !username.isEmpty else {
            showAlert(message: "Пожалуйста, введите имя пользователя")
            return
        }

        guard let nickname = txtNickname.text, !nickname.isEmpty else {
            showAlert(message: "Пожалуйста, введите никнейм")
            return
        }

        guard let password = txtPassword.text, isValidPassword(password) else {
            showAlert(message: "Пароль должен быть не менее 8 символов, содержать цифры и спецсимволы.")
            return
        }

        guard let confirmPassword = txtConfirmPassword.text, password == confirmPassword else {
            showAlert(message: "Пароли не совпадают.")
            return
        }

        // Сохранение данных в Core Data
        saveUserToCoreData(username: username, nickname: nickname, password: password, gender: selectedGender)
        
        // Переход на экран главной активности с успешной регистрацией
        showAlert(message: "Вы успешно создали аккаунт!") {
            let mainVC = MainActivityViewController(nibName: "MainActivityViewController", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.keyWindow {
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = UINavigationController(rootViewController: mainVC)
                }, completion: nil)
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Пароль должен быть не менее 8 символов и содержать хотя бы одну цифру и один спецсимвол
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")
        return passwordPredicate.evaluate(with: password)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Регистрация", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func saveUserToCoreData(username: String, nickname: String, password: String, gender: String) {
        let context = CoreContainer.instance.context
        let newUser = User(context: context)
        
        newUser.name = username   // Обратите внимание, что сохраняется 'name' (или 'username')
        newUser.nickname = nickname
        newUser.password = password
        newUser.gender = gender
        newUser.id = UUID().uuidString  // Присваиваем уникальный ID
        
        do {
            try context.save()
            print("Пользователь сохранен: \(username)")
            UserDefaults.standard.set(username, forKey: "currentUserName")

        } catch {
            print("Ошибка при сохранении пользователя: \(error)")
        }
    }

}
