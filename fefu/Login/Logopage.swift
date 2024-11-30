//
//  Logopage.swift
//  fefu
//
//  Created by Вадим Семибратов on 22.11.2024.
//
import UIKit
import CoreData

class Logopage: UIViewController {
    @IBOutlet weak var downlogo: UIImageView!
    @IBOutlet weak var avecyclist: UIImageView!
    @IBOutlet weak var toolbarRegistration: UIToolbar!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Загрузка текущего пользователя, если он уже авторизован
        if let user = getCurrentUser() {
            print("Текущий пользователь: \(user.name ?? "Нет имени")")
        } else {
            print("Текущий пользователь не найден")
        }

        // Настройка интерфейса
        let toolbarHeight: CGFloat = 140.0
        var toolbarFrame = toolbarRegistration.frame
        toolbarFrame.size.height = toolbarHeight
        toolbarRegistration.frame = toolbarFrame
        toolbarRegistration.autoresizingMask = .flexibleWidth

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        downlogo.image = UIImage(named: "downlogo")
        avecyclist.image = UIImage(named: "fefucyclist")
    }
    
    // Проверка существования пользователя в Core Data
    func checkUserExistence(username: String, password: String) -> Bool {
        let context = CoreContainer.instance.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND password == %@", username, password) // Используем 'name' для поиска
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                // Сохраняем id в UserDefaults для дальнейшего использования
                UserDefaults.standard.set(user.id, forKey: "currentUserId")
                print("Пользователь найден: \(username)")
                return true
            }
        } catch {
            print("Ошибка при проверке существующего пользователя: \(error)")
        }
        return false
    }


    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let username = txtUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            showAlert(message: "Пожалуйста, введите имя пользователя")
            return
        }
        
        guard let password = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showAlert(message: "Пожалуйста, введите пароль")
            return
        }

        if checkUserExistence(username: username, password: password) {
            // Если пользователь существует, создаем новый основной экран
            let mainVC = MainActivityViewController(nibName: "MainActivityViewController", bundle: nil)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = UINavigationController(rootViewController: mainVC)
                }, completion: nil)
            }
        } else {
            showAlert(message: "Неправильное имя пользователя или пароль.")
        }
    }

    // Отображение алерта
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func getCurrentUser() -> User? {
        let context = CoreContainer.instance.context

        // Попробуем получить URI текущего пользователя из UserDefaults
        if let currentUserURIString = UserDefaults.standard.string(forKey: "currentUserURI"),
           let currentUserURI = URL(string: currentUserURIString) {
            
            // Создаем объект NSManagedObjectID
            let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: currentUserURI)
            
            // Если объект с этим ID найден, возвращаем его
            if let objectID = objectID {
                return context.object(with: objectID) as? User
            }
        }
        
        return nil
    }
}
