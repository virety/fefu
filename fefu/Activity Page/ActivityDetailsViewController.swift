//
//  ActivityDetailsViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit

class ActivityDetailsViewController: UIViewController {
    
    var activityName: String?
    var activityDate: String?
    var activityDistance: Double?
    var activityDuration: TimeInterval?
    var activityStart: String?
    var activityEnd: String?
    var activityComment: String?
    var activityIcon: UIImage?
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let endTimeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let commentLabel = UILabel()
    private let commentTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dateLabel)
        
        distanceLabel.font = UIFont.systemFont(ofSize: 18)
        distanceLabel.textColor = .black
        distanceLabel.textAlignment = .left
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(distanceLabel)

        durationLabel.font = UIFont.systemFont(ofSize: 18)
        durationLabel.textColor = .black
        durationLabel.textAlignment = .left
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(durationLabel)

        startTimeLabel.font = UIFont.systemFont(ofSize: 18)
        startTimeLabel.textColor = .black
        startTimeLabel.textAlignment = .left
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(startTimeLabel)
        
        endTimeLabel.font = UIFont.systemFont(ofSize: 18)
        endTimeLabel.textColor = .black
        endTimeLabel.textAlignment = .left
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(endTimeLabel)

        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iconImageView)
        
        commentLabel.font = UIFont.italicSystemFont(ofSize: 16)
        commentLabel.textColor = .gray
        commentLabel.textAlignment = .left
        commentLabel.numberOfLines = 0
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(commentLabel)
        commentTextField.placeholder = "Ну как потренил?)"
        commentTextField.font = UIFont.systemFont(ofSize: 16)
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(commentTextField)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            distanceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            distanceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            durationLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            durationLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            startTimeLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            startTimeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            endTimeLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 10),
            endTimeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            iconImageView.topAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            commentLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            commentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            // Add constraints for the commentTextField
            commentTextField.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            commentTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            commentTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func populateData() {
        nameLabel.text = activityName
        dateLabel.text = activityDate

        if let distance = activityDistance {
            distanceLabel.text = "Дистанция: \(String(format: "%.2f км", distance))"
        }
        
        if let duration = activityDuration {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .short
            durationLabel.text = "Длительность: \(formatter.string(from: duration) ?? "0с")"
        }
        
        startTimeLabel.text = "Начало: \(activityStart ?? "Неизвестно")"
        endTimeLabel.text = "Конец: \(activityEnd ?? "Неизвестно")"
        
        iconImageView.image = activityIcon
        
        commentTextField.text = activityComment
    }
    private func getUpdatedComment() -> String {
        return commentTextField.text ?? ""
    }
}
