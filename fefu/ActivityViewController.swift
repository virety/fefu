//
//  ActivityViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var startButton: UIButton!
    var emptyStateLabel: UILabel!
    var activities: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Активности"
        
        // Устанавливаем серый фон экрана
        self.view.backgroundColor = UIColor.systemGray6

        // Настройка белого фона для Navigation Bar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        setupTableView()
        setupStartButton()
        setupEmptyStateLabel()
        updateEmptyState()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine // Линия между ячейками
        tableView.separatorColor = .lightGray
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Отступы для ячеек

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func setupStartButton() {
        startButton = UIButton()
        startButton.setTitle("Старт", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(startButton)

        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupEmptyStateLabel() {
        emptyStateLabel = UILabel()
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    @objc func startButtonTapped() {
        if activities.isEmpty {
            activities.append(["title": "Вчера", "data": [["distance": "14.32 км", "time": "2 часа 46 минут", "type": "Велосипед", "ago": "14 часов назад"]]])
        } else {
            activities[0]["data"] = (activities[0]["data"] as! [[String: String]]) + [["distance": "14.32 км", "time": "2 часа 46 минут", "type": "Велосипед", "ago": "14 часов назад"]]
        }
        tableView.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        if activities.isEmpty {
            tableView.isHidden = true
            emptyStateLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (activities[section]["data"] as! [[String: String]]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let activity = (activities[indexPath.section]["data"] as! [[String: String]])[indexPath.row]
        cell.configure(distance: activity["distance"]!, time: activity["time"]!, type: activity["type"]!, ago: activity["ago"]!)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activities[section]["title"] as? String
    }

    // Метод для добавления отступов между ячейками
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Высота ячеек
    }

    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityDetailsVC = ActivityDetailsViewController()
        let activity = (activities[indexPath.section]["data"] as! [[String: String]])[indexPath.row]
        activityDetailsVC.activity = activity
        self.navigationController?.pushViewController(activityDetailsVC, animated: true)
    }
    
}

