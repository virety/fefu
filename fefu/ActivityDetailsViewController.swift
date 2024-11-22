//
//  ActivityDetailsViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit

class ActivityDetailsViewController: UIViewController {
    var activity: [String: String]?

    private let distanceLabel = UILabel()
    private let agoLabel = UILabel()
    private let durationLabel = UILabel()
    private let startFinishLabel = UILabel()
    private let iconView = UIImageView()
    private let typeTimeLabel = UILabel()
    private let commentTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        // Устанавливаем заголовок в бар
        self.title = "Велосипед"
        setupUI()
        populateData()
    }

    private func setupUI() {
        // Расстояние
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 22)
        distanceLabel.textColor = .black
        distanceLabel.textAlignment = .left
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(distanceLabel)

        // Когда (сколько часов назад)
        agoLabel.font = UIFont.systemFont(ofSize: 18)
        agoLabel.textColor = .gray
        agoLabel.textAlignment = .left
        agoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(agoLabel)

        // Время (затрачено)
        durationLabel.font = UIFont.systemFont(ofSize: 18)
        durationLabel.textColor = .black
        durationLabel.textAlignment = .left
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(durationLabel)

        // Время старта и финиша
        startFinishLabel.font = UIFont.systemFont(ofSize: 18)
        startFinishLabel.textColor = .gray
        startFinishLabel.textAlignment = .left
        startFinishLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(startFinishLabel)

        // Иконка велосипеда
        iconView.image = UIImage(systemName: "bicycle.circle.fill")
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iconView)

        // Текст рядом с иконкой
        typeTimeLabel.font = UIFont.systemFont(ofSize: 18)
        typeTimeLabel.textColor = .gray
        typeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(typeTimeLabel)

        // Поле комментариев
        commentTextField.backgroundColor = UIColor.systemGray5
        commentTextField.placeholder = "Комментарий"
        commentTextField.font = UIFont.systemFont(ofSize: 16)
        commentTextField.borderStyle = .none
        commentTextField.layer.cornerRadius = 8
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(commentTextField)

        // Установка ограничений
        NSLayoutConstraint.activate([
            // Расстояние
            distanceLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            distanceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            // Когда
            agoLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5),
            agoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            // Время
            durationLabel.topAnchor.constraint(equalTo: agoLabel.bottomAnchor, constant: 5),
            durationLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            // Старт и финиш
            startFinishLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 5),
            startFinishLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            // Иконка велосипеда
            iconView.topAnchor.constraint(equalTo: startFinishLabel.bottomAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),

            // Текст рядом с иконкой
            typeTimeLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            typeTimeLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),

            // Поле комментариев
            commentTextField.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20),
            commentTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            commentTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            commentTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func populateData() {
        if let activity = activity {
            distanceLabel.text = "\(activity["distance"] ?? "Неизвестно")"
            agoLabel.text = "\(activity["ago"] ?? "Неизвестно")"
            durationLabel.text = "Время: \(activity["time"] ?? "Неизвестно")"
            startFinishLabel.text = "Старт \(activity["start"] ?? "--:--") · Финиш \(activity["finish"] ?? "--:--")"
            typeTimeLabel.text = "Велосипед · \(activity["ago"] ?? "Неизвестно")"
        }
    }

}
