//
//  APIServices.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 3/22/21.
//

import Foundation

class MovieController {
    
    func fetchItems(genreID: Int?, numb: Int, completion: @escaping ([Movie]) -> Void) {
        
        // URL is just for testing. Will change based on querys and desired output.
        // Fetches top movies for the day.
        
        var baseURL = URL(string: "testForNow")!
        
        if genreID == nil {
            baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=f5e6515f73e19e17f20b9e5f6657043c&page=\(String(numb))")!
        }
        else {
            baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=f5e6515f73e19e17f20b9e5f6657043c&page=\(String(numb))&with_genres=\(String(genreID!))")!
        }
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data, let movieResults = try? decoder.decode(MovieResults.self, from: data) {
                print("Movie data has been recieved")
                completion(movieResults.results)
            } else {
                print("Either no data was returned, or data was not was not serialized")
                return
            }
            
        }
        
        task.resume()
        
    }

    
    func fetchGenre(completion: @escaping ([Genre]) -> Void) {
        
        var dataWasReturned = true
        
        let baseURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=f5e6515f73e19e17f20b9e5f6657043c&language=en-US")!
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data, let genreResults = try? decoder.decode(GenreResults.self, from: data) {
                print("Genre data has been recieved")
                completion(genreResults.genres)
            } else {
                print("Either no Genre data was returned, or data was not serialized")
                dataWasReturned = false
                return
            }
            
        }
        
        task.resume()
        
    }
    

}

class CastController {
    
    func fetchCast(movieId: Movie, completion: @escaping (MovieDetails) -> Void) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId.id)?api_key=f5e6515f73e19e17f20b9e5f6657043c&append_to_response=credits")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data, let returnedCast = try? decoder.decode(MovieDetails.self, from: data) {
                print("Data has been recieved for cast")
                completion(returnedCast)
            } else {
                print("ERROR no data was returned")
            }
            
        }
        
        task.resume()
        
    }
}
