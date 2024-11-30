//
//  ActivityViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit
import CoreData

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActivityDelegate {
    var tableView: UITableView!
    var startButton: UIButton!
    var emptyStateLabel: UILabel!
    var activities: [ActivityData] = []
    
    // Переменная для хранения текущего пользователя
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Активности"
        self.view.backgroundColor = UIColor.systemGray6
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        // Настройка UI
        setupTableView()
        setupStartButton()
        setupEmptyStateLabel()
        
        currentUser = getCurrentUser()
        fetchActivities()
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    private func toggleUIElements(visible: Bool) {
        startButton.isHidden = !visible
        tableView.isHidden = !visible
        emptyStateLabel.isHidden = !visible
    }

    func addSampleUser() {
        let context = CoreContainer.instance.context
        let user = User(context: context)
        user.name = "Vadim" // Пример имени

        do {
            try context.save()
        } catch {
            print("Error saving user: \(error)")
        }
    }

    func getCurrentUser() -> User? {
        let context = CoreContainer.instance.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        guard let currentUserId = UserDefaults.standard.string(forKey: "currentUserId") else {
            print("Текущий пользователь не найден в UserDefaults.")
            return nil
        }
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", currentUserId)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                print("Текущий пользователь: \(user.name ?? "Нет имени")")
                return user
            } else {
                print("Текущий пользователь не найден.")
                return nil
            }
        } catch {
            print("Ошибка при извлечении пользователя: \(error)")
            return nil
        }
    }

    @objc func startButtonTapped() {
        toggleUIElements(visible: false)
        let startActivityController = StartActivityViewController(nibName: "StartActivityViewController", bundle: nil)
        navigationController?.pushViewController(startActivityController, animated: true)
    }

    func didCreateActivity(name: String, date: Date) {
        let context = CoreContainer.instance.context
        let newActivity = ActivityData(context: context)
        newActivity.name = name
        newActivity.date = date
        newActivity.distance = 150 // Пример дистанции
        newActivity.duration = 5 // Пример длительности
        newActivity.user = currentUser // Связываем с текущим пользователем
        do {
            try context.save()
            fetchActivities()
        } catch {
            print("Error saving activity: \(error)")
        }
    }

    private func updateEmptyState() {
        if activities.isEmpty {
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    private func fetchActivities() {
        guard let currentUser = currentUser else {
            print("Текущий пользователь не найден")
            return
        }

        let context = CoreContainer.instance.context
        let fetchRequest: NSFetchRequest<ActivityData> = ActivityData.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "user == %@", currentUser)

        do {
            activities = try context.fetch(fetchRequest)
            print("Найдено \(activities.count) активностей.")
            for activity in activities {
                print("Имя активности: \(activity.name ?? "Не указано")")
                print("Дата активности: \(activity.date ?? Date())")
                print("Дистанция: \(String(format: "%.2f км", activity.distance / 1000))")
                print("Длительность: \(activity.duration) сек")
            }
            tableView.reloadData()
            updateEmptyState()
        } catch {
            print("Ошибка при загрузке активностей: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let formattedDate = dateFormatter.string(from: activity.date ?? Date())

        let timeAgo = timeAgoSinceDate(activity.date ?? Date())
        let distance: String
        if activity.distance < 1000 {
            distance = String(format: "%.0f м", activity.distance)
        } else {
            distance = String(format: "%.2f км", activity.distance / 1000)
        }

        let icon: UIImage?
        switch activity.name?.lowercased() {
        case "ходьба":
            icon = UIImage(systemName: "figure.walk.circle.fill")
        case "бег":
            icon = UIImage(systemName: "figure.run.circle.fill")
        case "велосипед":
            icon = UIImage(systemName: "bicycle.circle.fill")
        default:
            icon = UIImage(systemName: "questionmark.circle.fill")
        }

        cell.configure(
            name: activity.name ?? "Неизвестно",
            date: formattedDate,
            timeAgo: timeAgo,
            distance: distance,
            icon: icon
        )

        return cell
    }

    func timeAgoSinceDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) год(а) назад"
        } else if let month = components.month, month > 0 {
            return "\(month) месяц(ев) назад"
        } else if let day = components.day, day > 0 {
            return "\(day) день(я) назад"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) час(а) назад"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) мин. назад"
        } else if let second = components.second, second > 0 {
            return "\(second) сек. назад"
        } else {
            return "Только что"
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let activity = activities[indexPath.row]
        let detailsVC = ActivityDetailsViewController()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let dateStr = dateFormatter.string(from: activity.date ?? Date())

        detailsVC.activityName = activity.name ?? "Неизвестно"
        detailsVC.activityDate = dateStr

        navigationController?.pushViewController(detailsVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleUIElements(visible: true)
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupEmptyStateLabel() {
        emptyStateLabel = UILabel()
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
