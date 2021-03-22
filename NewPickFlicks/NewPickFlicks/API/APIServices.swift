//
//  APIServices.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 3/22/21.
//

import Foundation

class MovieController {
    
    func fetchItems(completion: @escaping ([Movie]) -> Void) {
        
        // URL is just for testing. Will change based on querys and desired output.
        // Fetches top movies for the day.
        
        let baseURL = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=f5e6515f73e19e17f20b9e5f6657043c")!
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data, let movieResults = try? decoder.decode(MovieResults.self, from: data) {
                print("Data has been recieved")
                print(data)
                completion(movieResults.results)
            } else {
                print("Either no data was returned, or data was not was not serialized")
                return
            }
            
        }
        
        task.resume()
        
    }
    
    
}
