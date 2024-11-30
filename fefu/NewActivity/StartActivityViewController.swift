//
//  StartActivityViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 27.11.2024.
//
import UIKit
import MapKit
import CoreLocation
import CoreData

protocol ActivityDelegate: AnyObject {
    func didCreateActivity(name: String, date: Date)
}

class StartActivityViewController: UIViewController {
    
    @IBOutlet weak var withbuttons: UIView!
    @IBOutlet weak var witchchoise: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityDistanceLabel: UILabel!
    @IBOutlet weak var activityTimeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var activityTypes = ["Велосипед", "Бег", "Ходьба"]
    private var coreContainer = CoreContainer.instance
    private var activityDistance: CLLocationDistance = 0
    private var activityDuration: TimeInterval = 0
    private var timer: Timer?
    private var pauseFlag: Bool = true
    private var activityDate: Date? // Начало активности
    private var selectedActivityType: String?
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    
    fileprivate var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            if oldValue != nil {
                activityDistance += userLocation.distance(from: oldValue!)
            }
            userLocHistory.append(userLocation)
            activityDistanceLabel.text = String(format: "%.2f км", activityDistance / 1000)
        }
    }
    
    fileprivate var userLocHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocHistory.map { $0.coordinate }
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(route)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CompositionalLayoutCell.nib(), forCellWithReuseIdentifier: CompositionalLayoutCell.reuseId)
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        startButton.isEnabled = false
        startButton.alpha = 0.5
    }
    
    private func setupUI() {
        withbuttons.isHidden = true
        pauseButton.layer.cornerRadius = pauseButton.bounds.size.width / 2
        finishButton.layer.cornerRadius = finishButton.bounds.size.width / 2
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard selectedActivityType != nil else {
            showAlert(message: "Пожалуйста, выберите вид активности перед стартом!")
            return
        }
        
        withbuttons.isHidden = false
        witchchoise.isHidden = true
        
        // Сохраняем время старта активности
        activityDate = Date()
        
        // Запускаем таймер и отслеживание местоположения
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpd), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if pauseFlag {
            timer?.invalidate()
            locationManager.stopUpdatingLocation()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpd), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }
        pauseFlag.toggle()
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        
        // Сохраняем время окончания активности
        let activityEnd = Date()
        
        // Вычисляем продолжительность
        activityDuration = activityEnd.timeIntervalSince(activityDate ?? Date())
        
        saveActivity()
        
        navigationController?.popViewController(animated: true)
    }
    
    private func saveActivity() {
        let context = coreContainer.context
        let activity = ActivityData(context: context)
        
        guard let username = UserDefaults.standard.string(forKey: "currentUserName") else {
            showAlert(message: "Не удалось найти информацию о текущем пользователе.")
            return
        }
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "name == %@", username)
        
        do {
            let users = try context.fetch(userFetchRequest)
            if let user = users.first {
                activity.user = user
            } else {
                showAlert(message: "Пользователь не найден.")
                return
            }
        } catch {
            print("Ошибка при извлечении данных пользователя: \(error)")
            showAlert(message: "Ошибка при поиске пользователя.")
            return
        }

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let activityStart = dateFormat.string(from: activityDate ?? Date())
        let activityEnd = dateFormat.string(from: (activityDate ?? Date()).addingTimeInterval(activityDuration))
        
        activity.date = activityDate
        activity.distance = activityDistance
        activity.duration = activityDuration
        activity.start = activityStart
        activity.end = activityEnd
        activity.name = selectedActivityType
        
        do {
            try context.save()
            print("Активность сохранена:")
            print("Имя активности: \(activity.name ?? "Не указано")")
            print("Пользователь: \(username)")
            print("Дистанция: \(String(format: "%.2f км", activityDistance / 1000))")
            print("Длительность: \(String(format: "%.0f сек", activityDuration))")
            print("Время начала: \(activityStart)")
            print("Время окончания: \(activityEnd)")
        } catch {
            print("Ошибка при сохранении активности: \(error)")
            showAlert(message: "Ошибка при сохранении активности.")
        }
    }
    
    @objc func timerUpd() {
        let timeFormat = DateComponentsFormatter()
        timeFormat.allowedUnits = [.hour, .minute, .second]
        timeFormat.zeroFormattingBehavior = .pad
        activityTimeLabel.text = timeFormat.string(from: activityDuration)
        activityDuration += 1
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension StartActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedActivityType = activityTypes[indexPath.row]
        activityNameLabel.text = selectedActivityType
        
        startButton.isEnabled = true
        startButton.alpha = 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutCell.reuseId, for: indexPath) as? CompositionalLayoutCell else {
            return UICollectionViewCell()
        }
        
        let label = activityTypes[indexPath.row]
        var iconImage: UIImage
        switch label {
        case "Ходьба":
            iconImage = UIImage(named: "walking_icon")!
        case "Бег":
            iconImage = UIImage(named: "running_icon")!
        case "Велосипед":
            iconImage = UIImage(named: "cycling_icon")!
        default:
            iconImage = UIImage(named: "cycling_icon")!
        }
        
        cell.configure(title: label, image: iconImage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityTypes.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - CLLocationManagerDelegate
extension StartActivityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        if activityDate != nil { // Начинаем отслеживание только после нажатия "Старт"
            userLocHistory.append(currentLocation)
            if userLocHistory.count > 1 {
                let previousLocation = userLocHistory[userLocHistory.count - 2]
                activityDistance += currentLocation.distance(from: previousLocation)
            }
            activityDistanceLabel.text = String(format: "%.2f км", activityDistance / 1000)
            userLocation = currentLocation
        }
    }
}

// MARK: - MKMapViewDelegate
extension StartActivityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
