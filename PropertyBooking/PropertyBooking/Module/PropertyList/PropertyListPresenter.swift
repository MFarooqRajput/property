//
//  PropertyListPresenter.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import Foundation
import CoreLocation

// MARK: - PropertyListView

public protocol PropertyListView: class {
    func reloadView()
    func showErrorView(_ error: String)
    func hideErrorView()
    func activityIndicatorAnimatingView(animating: Bool)
}

class PropertyListPresenter {
    
    private weak var view: PropertyListView?
    private let propertyRepo = PropertyRepo()
    var properties: [Property] = []
    var searchedProperties: [Property] = []
    var userLocation: Location?
    var searched = false
    
    var rooms = [1,2,3]
    
    public init(view: PropertyListView?) {
        self.view = view
        deleteAll()
    }
    
    func fetchProperty() {
        
        self.view?.activityIndicatorAnimatingView(animating: true)
        self.view?.hideErrorView()
        
        propertyRepo.fetchPropertyList(with: .json, suffixURL: .apartmentsList) { [weak self] propertyList, error in
            if let propertyList = propertyList {
                self?.properties = propertyList
                
                self?.view?.activityIndicatorAnimatingView(animating: false)
                self?.sortPropertyList()
            } else {
                self?.view?.activityIndicatorAnimatingView(animating: false)
                self?.view?.showErrorView(error?.localizedDescription ?? "Property data is not available")
            }
        }
    }
    
    func sortPropertyList() {
        
        if let userLocation = userLocation {
            let currentLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            if searched {
                searchedProperties.sort(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
            } else {
                properties.sort(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
            }
        }
        self.view?.reloadView()
    }
    
    func updateLocation(with latitude: Double, longitude: Double) {
        self.userLocation = Location(latitude: latitude, longitude: longitude)
    }
    
    func getPropertiesCount() -> Int {
        return searched ? searchedProperties.count : properties.count
    }
    
    func propertyAt(indexPath: IndexPath) -> Property? {
        return searched ? searchedProperties[indexPath.row] : properties[indexPath.row]
    }
    
    func getRoomsCount() -> Int {
        return rooms.count
    }
    
    func roomAt(indexPath: IndexPath) -> Int? {
        return rooms[indexPath.row]
    }
    
    func search(from: Date, to: Date, rooms: String?) {
        
        if from > to  {
            self.view?.showErrorView("From Date is later than To Date")
            return
        }
        
        searched = true
        searchedProperties.removeAll()
        
        if let rooms = rooms {
            searchedProperties = properties.filter {
                $0.bedrooms == Int(rooms)
            }
        } else {
            searchedProperties = properties
        }
        
        
        sortPropertyList()
    }
    
    func clearSearch() {
        searched = false
        sortPropertyList()
    }
    
    func isPropertyBooked(propertyId: String, fromDate: Date, toDate: Date) -> Bool {
        if fromDate > toDate  {
            self.view?.showErrorView("From Date is later than To Date")
            return false
        } else {
            return propertyRepo.isPropertyBooked(propertyId: propertyId, fromDate: fromDate, toDate: toDate)
        }
    }
    
    
    func bookApartment(id: String, fromDate: Date, toDate: Date) {
        
        if fromDate > toDate  {
            self.view?.showErrorView("From Date is later than To Date")
        } else {
            propertyRepo.bookApartment(id: id, fromDate: fromDate, toDate: toDate)
        }
    }
    
    func booked(id: String) {
        propertyRepo.booked(id: id)
    }
    
    func deleteAll() {
        propertyRepo.deleteAll()
    }
    
}
