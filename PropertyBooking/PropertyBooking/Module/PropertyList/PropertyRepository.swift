//
//  PropertyRepository.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import Foundation
import CoreData
import UIKit

typealias PropertyListCompletionHandler = ([Property]?, Error?) -> Void

class PropertyRepo {
    
    func fetchPropertyList(with format: Format, suffixURL: SuffixURL, completion: @escaping PropertyListCompletionHandler) {
        NetworkClient.makeCall(with: format, suffixURL: suffixURL, completionHandler: completion)
    }
    
    func isPropertyBooked(propertyId: String, fromDate: Date, toDate: Date) -> Bool {
        
        var booked  = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return booked
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Apartment")
        request.predicate = NSPredicate(format:"id = %@", propertyId)
        
        do {
            let result = try managedContext.fetch(request)
            
            for apartment in result as! [NSManagedObject] {
                
                if let apartmentId = apartment.value(forKey: "id") as? String {
                    
                    if propertyId == apartmentId {
                        
                        if let apartmentFromDate = apartment.value(forKey: "from_date") as? Date, let apartmentToDate = apartment.value(forKey: "to_date") as? Date {
                            let apartmentInterval = DateInterval(start: apartmentFromDate, end: apartmentToDate)
                            let propertyInterval =  DateInterval(start: fromDate, end: toDate)
                            let intersection = apartmentInterval.intersection(with: propertyInterval)
                            
                            if intersection != nil {
                                
                                debugPrint(apartment.value(forKey: "id") as! String)
                                debugPrint(apartment.value(forKey: "from_date") as! Date)
                                debugPrint(apartment.value(forKey: "to_date") as! Date)
                                
                                booked = true
                            }
                        }
                    }
                }
            }
            
        }  catch let error as NSError {
            debugPrint("Could not delete. \(error), \(error.userInfo)")
        }
        
        return booked
    }
    
    
    func bookApartment(id: String, fromDate: Date, toDate: Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Apartment", in: managedContext)!
        
        let newApartment = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newApartment.setValue(id, forKey: "id")
        newApartment.setValue(fromDate, forKey: "from_date")
        newApartment.setValue(toDate, forKey: "to_date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func booked(id: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Apartment")
        request.predicate = NSPredicate(format:"id = %@", id)
        
        do {
            let result = try managedContext.fetch(request)
            for apartment in result as! [NSManagedObject] {
                managedContext.delete(apartment)
            }
        }  catch let error as NSError {
            debugPrint("Could not cancel. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Apartment")
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "done == 1")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        batchDeleteRequest.resultType = .resultTypeCount
        
        do {
            let batchDeleteResult = try managedContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
            debugPrint("The batch delete request has deleted \(batchDeleteResult.result!) records.")
            managedContext.reset()
        } catch let error as NSError  {
            debugPrint("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
