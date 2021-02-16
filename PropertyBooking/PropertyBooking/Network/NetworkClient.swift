//
//  NetworkClient.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import Foundation

class NetworkClient {
    
    class func baseUrl(_ suffixURL: SuffixURL, format: Format) -> URL {
        return URL(string: "\(Constants.apiBaseUrl)\(suffixURL.rawValue).\(format.rawValue)")!
    }
    
    class func makeCall<T: Decodable>(with format: Format,
                                      suffixURL: SuffixURL,
                                      completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        let url = baseUrl(suffixURL, format: format)
        debugPrint(url)
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        
                        do {
                            let property = try JSONDecoder().decode(T.self, from: data)
                            completion(property, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
