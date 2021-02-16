//
//  ViewController.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import UIKit
import CoreLocation

class PropertyListViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var fromDataPicker: UIDatePicker!
    @IBOutlet weak var toDataPicker: UIDatePicker!
    @IBOutlet weak var roomsButton: DropDownButton!
    
    @IBOutlet var roomsView: UIView!
    @IBOutlet weak var roomsListTableView: UITableView!
    
    @IBOutlet weak var propertyListTableView: UITableView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    var presenter: PropertyListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PropertyListPresenter(view: self)
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        // location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        roomsView.isHidden = true
        
        configTabeleView()
        setLocation()
        presenter.fetchProperty()
    }
    
    func configTabeleView() {
        propertyListTableView.register(UINib(nibName: "PropertyListTableViewCell", bundle: nil), forCellReuseIdentifier: "PropertyListCell")
        
        propertyListTableView.dataSource = self
        propertyListTableView.delegate = self
        propertyListTableView.tableFooterView = UIView(frame: .zero)
        
        roomsListTableView.register(UINib(nibName: "RoomsListTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomsListCell")
        
        roomsListTableView.dataSource = self
        roomsListTableView.delegate = self
        roomsListTableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setLocation() {
        presenter.updateLocation(with: Constants.latitude, longitude: Constants.longitude)
        handleLocationAuthorizationStatus(status: locationManager.authorizationStatus)
    }
    
    @IBAction func locationPermissionChanged(_ sender: Any) {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            debugPrint("NotDetermined")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            debugPrint("Denied")
            createSettingsAlertController(title: "", message: "Turn On Location Services to Allow PropertyBooking to Determine Your Location")
        case .restricted:
            debugPrint("Restricted")
            createSettingsAlertController(title: "", message: "Turn On Location Services to Allow PropertyBooking to Determine Your Location")
        @unknown default:
            debugPrint("Unknown")
        }
    }
    
    @IBAction func showRooms(_ sender: Any) {
        roomsView.isHidden = !roomsView.isHidden
    }
    
    @IBAction func search(_ sender: Any) {
        presenter.search(from: fromDataPicker.date, to: toDataPicker.date, rooms: roomsButton.titleLabel?.text)
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        presenter.clearSearch()
    }
    
    private func createSettingsAlertController(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func hideError() {
    }
    
    private func activityIndicatorAnimating(_ animating: Bool ) {
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
}

// MARK: - PropertyListView protocol methods
extension PropertyListViewController: PropertyListView {
    func reloadView() {
        propertyListTableView.reloadData()
    }
    
    func showErrorView(_ error: String) {
        self.showError(error)
    }
    
    func hideErrorView() {
        self.hideError()
    }
    
    func activityIndicatorAnimatingView(animating: Bool) {
        activityIndicatorAnimating(animating)
    }
    
    func updateLocationButton(permitted: Bool) {
        //updateLocationPermission(permitted: permitted)
    }
}

// MARK: - UITableViewDataSource
extension PropertyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == propertyListTableView {
            return presenter.getPropertiesCount()
        } else {
            return presenter.getRoomsCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == propertyListTableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListCell") as? PropertyListTableViewCell  else {
                fatalError("The dequeued cell is not an instance of PropertyListCell")
            }
            
            cell.delegate = self
            
            if let property =  presenter.propertyAt(indexPath: indexPath) {
                let booked = presenter.isPropertyBooked(propertyId: property.id, fromDate: fromDataPicker.date, toDate: toDataPicker.date)
                cell.setCell(with:property, isBooked: booked)
            }
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsListCell") as? RoomsListTableViewCell  else {
                fatalError("The dequeued cell is not an instance of RoomsListCell")
            }
            
            if let room =  presenter.roomAt(indexPath: indexPath) {
                cell.setCell(with:room)
            }
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate
extension PropertyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == propertyListTableView {
            return 120
        } else {
            return 30
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == propertyListTableView {
            
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) as? RoomsListTableViewCell else {
                fatalError("The dequeued cell is not an instance of RoomsListCell")
            }
            
            roomsButton.setTitle(cell.roomsLabel.text, for: .normal)
            roomsView.isHidden = true
        }
        
    }
}

// MARK: - PropertyListTableViewCellDelegate
extension PropertyListViewController: PropertyListTableViewCellDelegate {
    func didTapBooking(cell: PropertyListTableViewCell) {
        if let indexPath = propertyListTableView.indexPath(for: cell) {
            if let property =  presenter.propertyAt(indexPath: indexPath) {
                presenter.bookApartment(id: property.id, fromDate: fromDataPicker.date, toDate: toDataPicker.date)
                propertyListTableView.reloadRows(at: [indexPath],with: .fade)
            }
        }
    }
    
    func didTapBooked(cell: PropertyListTableViewCell) {
        if let indexPath = propertyListTableView.indexPath(for: cell) {
            if let property =  presenter.propertyAt(indexPath: indexPath) {
                presenter.booked(id: property.id)
                propertyListTableView.reloadRows(at: [indexPath],with: .fade)
            }
        }
    }
    
    
    
}

// MARK: - CLLocation
extension PropertyListViewController {
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        
        let locationImage = UIImage(systemName: "location")
        let locationSlashImage = UIImage(systemName: "location.slash")
        
        switch status {
        case .notDetermined:
            debugPrint("NotDetermined")
            locationButton.setImage(locationSlashImage, for: .normal)
        case .authorizedWhenInUse, .authorizedAlways:
            debugPrint("Authorized")
            locationManager.startUpdatingLocation()
            locationButton.setImage(locationImage, for: .normal)
        case .denied:
            debugPrint("Denied")
            locationButton.setImage(locationSlashImage, for: .normal)
        case .restricted:
            debugPrint("Restricted")
            locationButton.setImage(locationSlashImage, for: .normal)
        @unknown default:
            debugPrint("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: locationManager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            debugPrint(location.coordinate.latitude)
            debugPrint(location.coordinate.longitude)
            presenter.updateLocation(with: location.coordinate.latitude, longitude: location.coordinate.longitude)
            presenter.sortPropertyList()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
