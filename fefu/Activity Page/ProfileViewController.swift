//
//  ProfileViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//
import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let graphView = GraphView() // Custom graph view
    private let logoImageView = UIImageView() // Boot logo
    private let weekLabel = UILabel() // "Эта неделя" label
    private let distanceTimeHeightLabel = UILabel() // "Дистанция| Время| Высота" label
    private var profileData = [[String: String]]()
    private var activitiesData: [(date: String, distance: Double, time: Double)] = []
    
    private var context: NSManagedObjectContext {
        return CoreContainer.instance.context
    }
    
    private let logoutButton = UIButton() // "Logout" button

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Профиль"
        view.backgroundColor = .white
        
        setupScrollView()
        setupLogo()
        setupWeekLabel()
        setupDistanceTimeHeightLabel()
        setupGraphView()
        setupTableView()
        setupLogoutButton()
        
        fetchUserData()
        loadActivityData()
        graphView.setData(activitiesData) // Pass data to graph
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensure horizontal scroll is disabled
        ])
    }
    
    private func setupLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "boot_logo") // Ensure you have an image with this name
        contentView.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50), // Set height for logo
            logoImageView.widthAnchor.constraint(equalToConstant: 50)  // Set width for logo
        ])
    }
    
    private func setupWeekLabel() {
        weekLabel.translatesAutoresizingMaskIntoConstraints = false
        weekLabel.text = "Эта неделя"
        weekLabel.font = UIFont.boldSystemFont(ofSize: 18)
        weekLabel.textAlignment = .center
        contentView.addSubview(weekLabel)
        
        NSLayoutConstraint.activate([
            weekLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            weekLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupDistanceTimeHeightLabel() {
        distanceTimeHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceTimeHeightLabel.text = "Дистанция| Время| Высота"
        distanceTimeHeightLabel.font = UIFont.systemFont(ofSize: 14)
        distanceTimeHeightLabel.textAlignment = .center
        contentView.addSubview(distanceTimeHeightLabel)
        
        NSLayoutConstraint.activate([
            distanceTimeHeightLabel.topAnchor.constraint(equalTo: weekLabel.bottomAnchor, constant: 10),
            distanceTimeHeightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupGraphView() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: distanceTimeHeightLabel.bottomAnchor, constant: 10), // Reduced margin
            graphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            graphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            graphView.heightAnchor.constraint(equalToConstant: 250) // Graph height
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300) // Table height
        ])
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        contentView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func logoutTapped() {
        // Reset current user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "currentUserName")
        
        // Get the main storyboard and instantiate the initial view controller (Main screen)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainViewController = storyboard.instantiateInitialViewController() {
            // Set the root view controller to the main screen
            if let window = view.window {
                window.rootViewController = mainViewController
                window.makeKeyAndVisible()
            }
        }
    }
    private func loadActivityData() {
        let fetchRequest: NSFetchRequest<ActivityData> = ActivityData.fetchRequest()
        
        // Loading data for the current user
        guard let username = UserDefaults.standard.string(forKey: "currentUserName") else {
            print("Could not get current user name from UserDefaults.")
            return
        }
        fetchRequest.predicate = NSPredicate(format: "user.name == %@", username)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)] // Sort by date
        
        do {
            let activities = try context.fetch(fetchRequest)
            
            // Ensure we have data
            print("Loaded activities: \(activities)") // Debugging line
            
            // Populate activitiesData array
            activitiesData = activities.map { activity in
                return (date: activity.date?.description ?? "Unknown", distance: activity.distance, time: activity.duration)
            }
            
            // Calculate total distance, time, and height for the week
            let totalDistance = activities.reduce(0) { $0 + $1.distance }
            let totalTime = activities.reduce(0) { $0 + $1.duration }
            let totalHeight = activities.reduce(0) { $0 + $1.height }
            
            // Convert total distance to kilometers and total time to hours
            let totalDistanceInKm = totalDistance / 1000 // Convert to kilometers
            let totalTimeInHours = totalTime / 60 // Convert time to hours
            let totalHeightInMeters = totalHeight // Assuming height is in meters already
            
            distanceTimeHeightLabel.text = "Дистанция: \(String(format: "%.2f", totalDistanceInKm)) км | Время: \(String(format: "%.2f", totalTimeInHours)) ч | Высота: \(String(format: "%.0f", totalHeightInMeters)) м"
            
            // After fetching data, ensure the graph is updated
            DispatchQueue.main.async {
                self.graphView.setData(self.activitiesData)
            }
            
        } catch {
            print("Error loading activity data: \(error)")
        }
    }


    func addNewActivity(distance: Double, duration: Double, date: Date, activityType: String) {
        let context = CoreContainer.instance.context
        let activity = ActivityData(context: context)
        
        guard let username = UserDefaults.standard.string(forKey: "currentUserName") else {
            showAlert(message: "Could not find current user information.")
            return
        }
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "name == %@", username)
        
        do {
            let users = try context.fetch(userFetchRequest)
            if let user = users.first {
                activity.user = user
            } else {
                showAlert(message: "User not found.")
                return
            }
        } catch {
            print("Error fetching user data: \(error)")
            showAlert(message: "Error finding user.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        activity.date = date
        activity.distance = distance
        activity.duration = duration
        activity.start = dateFormatter.string(from: date)
        activity.end = dateFormatter.string(from: date.addingTimeInterval(duration * 3600))
        activity.name = activityType
        
        do {
            try context.save()
            print("Activity successfully saved.")
            
            // After saving, reload data and refresh the graph
            loadActivityData()
            graphView.setData(activitiesData) // Refresh graph with new data
        } catch {
            print("Error saving data: \(error)")
            showAlert(message: "Could not save activity data.")
        }
    }
    
    private func fetchUserData() {
        guard let username = UserDefaults.standard.string(forKey: "currentUserName") else {
            print("Could not get username from UserDefaults.")
            return
        }
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "name == %@", username)
        
        do {
            let users = try context.fetch(userFetchRequest)
            if let user = users.first {
                profileData = [
                    ["Логин": user.name ?? "Unknown"],
                    ["Имя или никнейм": user.nickname ?? "Unknown"],
                    ["Пароль": user.password ?? "Unknown"],
                    ["Пол": user.gender ?? "Unknown"]
                ]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        let sectionData = profileData[indexPath.row]
        let key = Array(sectionData.keys).first ?? "Unknown"
        let value = Array(sectionData.values).first ?? "Unknown"
        
        cell.titleLabel.text = key
        cell.valueLabel.text = value
        
        return cell
    }
    
    // MARK: - Show Alert
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
