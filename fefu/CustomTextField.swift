//
//  CustomTextField.swift
//  fefu
//
//  Created by Вадим Семибратов on 22.11.2024.
//

import UIKit

class LoginTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    private func configureTextField() {
        self.font = UIFont.systemFont(ofSize: 17)
        self.borderStyle = .roundedRect
        self.placeholder = "Логин"
        
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
    }
}

class NameOrNicknameTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    private func configureTextField() {
        self.font = UIFont.systemFont(ofSize: 17)
        self.borderStyle = .roundedRect
        self.placeholder = "Имя или никнейм"
        
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
    }
}

class PasswordTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    private func configureTextField() {
        self.font = UIFont.systemFont(ofSize: 17)
        self.borderStyle = .roundedRect
        self.placeholder = "Пароль"
        
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.isSecureTextEntry = true // Добавим это для пароля
    }
}
class ConfirmPasswordTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    private func configureTextField() {
        self.font = UIFont.systemFont(ofSize: 17)
        self.borderStyle = .roundedRect
        self.placeholder = "Повторите пароль"
        
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.isSecureTextEntry = true // Добавим это для повторения пароля
    }
}
