//
//  NetworkManager.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation

class NetworkManager {
    
    
    func fetchJokes(completion: @escaping (Data) -> (Void)) {
        
        let url = URL(string: "https://icanhazdadjoke.com/")
        let request = NSMutableURLRequest(url: url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("bad response: \(String(describing: response))")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("http reponse: \(httpResponse.statusCode)")
                    return
            }
            
            guard err == nil else {
                print("cant fetch jokes error: \(String(describing: err))")
                return
            }
            
            guard let data = data else {
                print("bad data")
                return
            }
            
            completion(data)
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
}
