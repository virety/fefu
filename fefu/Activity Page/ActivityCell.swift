//
//  ActivityCell.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit
class ActivityCell: UITableViewCell {
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let timeAgoLabel = UILabel()   // New label for time ago
    let distanceLabel = UILabel()  // New label for distance

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeAgoLabel.font = UIFont.systemFont(ofSize: 12)
        timeAgoLabel.textColor = .lightGray
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceLabel.font = UIFont.systemFont(ofSize: 12)
        distanceLabel.textColor = .lightGray
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeAgoLabel)  // Add timeAgoLabel
        contentView.addSubview(distanceLabel) // Add distanceLabel

        NSLayoutConstraint.activate([
            // Icon constraints
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            // Name label constraints
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Date label constraints
            dateLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Time ago label constraints (under the date label)
            timeAgoLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            timeAgoLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            timeAgoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Distance label constraints (under the time ago label)
            distanceLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            distanceLabel.topAnchor.constraint(equalTo: timeAgoLabel.bottomAnchor, constant: 5),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(name: String, date: String, timeAgo: String, distance: String, icon: UIImage?) {
        nameLabel.text = name
        dateLabel.text = date
        timeAgoLabel.text = timeAgo
        distanceLabel.text = distance
        iconView.image = icon
    }
}
