//
//  ActivityCell.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit
// Кастомная ячейка
class ActivityCell: UITableViewCell {
    private let distanceLabel = UILabel()
    private let timeLabel = UILabel()
    private let typeLabel = UILabel()
    private let agoLabel = UILabel()
    private let iconView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconView.image = UIImage(systemName: "bicycle.circle.fill")
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)

        distanceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)

        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .gray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)

        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(typeLabel)

        agoLabel.font = UIFont.systemFont(ofSize: 14)
        agoLabel.textColor = .gray
        agoLabel.textAlignment = .right
        agoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(agoLabel)

        // Добавляем скругления для ячеек
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            distanceLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            timeLabel.leadingAnchor.constraint(equalTo: distanceLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5),

            typeLabel.leadingAnchor.constraint(equalTo: distanceLabel.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            agoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            agoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        func configure(distance: String, time: String, type: String, ago: String) {
            distanceLabel.text = distance
            timeLabel.text = time
            typeLabel.text = type
            agoLabel.text = ago
        }
    }
