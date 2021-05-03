//
//  SessionResults.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 4/28/21.
//

import SwiftUI

struct MovieList: Identifiable {
    var id: Int
    var title: String
    var image: UIImage
}

struct SessionResults: View {
    
    @State private var movies: [Movie] = [Movie(id: 191911, title: "Jumanji", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019")]
    
    @State private var movieList: [MovieList] = []
    
    let movieController = MovieController()
    
    @State var image: UIImage = UIImage(named: "new_icon")!

    var body: some View {
        
        VStack {
            Text("Session Results")
                .foregroundColor(.white)
                .font(Font.custom("helvetica", size: 40))
                .bold()
                .padding(.top)
            
            ScrollView {
                // Movies array will be changed to top ten movies array
                ForEach(movieList){ movie in
                    HStack {
                        Image(uiImage: movie.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 100, alignment: .center)
                            .cornerRadius(10)
                        Text("\(movie.title)")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title3)
                            .padding()
                            .padding(.leading)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.leading)
                    .padding()
                }
            }
            .padding(.bottom, 20)
            
            Button("Dismiss") {
                print("Dismiss View")
            }
            .padding(EdgeInsets(top: 20, leading: 140, bottom: 20, trailing: 140))
            .background(Color.pink)
            .foregroundColor(.white)
            .font(.title2)
            .cornerRadius(30)
            
            
        }
        .background(Image("jeff-pierre-5X5I20O_Vbg-unsplash")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .blur(radius: 7)
        )
        
        .onAppear {
            
            movieController.fetchItems(genreID: nil, numb: 28) { (movies) in
                
                self.movies = movies
                
                for movie in movies {
                    
                    updateUI(movieInfo: movie)
                    let newMovie: MovieList = MovieList(id: movie.id, title: movie.title, image: image)
                    movieList.append(newMovie)
                    print(movieList)
                    
                }
                
            }
            
        }
        
    }
    
    func updateUI(movieInfo: Movie) {
        
        let task = URLSession.shared.dataTask(with: URL(string: "http://image.tmdb.org/t/p/w500\(movieInfo.poster_path)")!) { (data, response, error) in
            
            guard let data = data, let image = UIImage(data: data) else {return}
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
        
    }
}

struct SessionResults_Previews: PreviewProvider {
    static var previews: some View {
        SessionResults()
    }
}
