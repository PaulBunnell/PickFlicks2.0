//
//  MovieDetailView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/31/21.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieController = MovieController()
    
    let castController = CastController()
    
//    var user: User
//    
//    let homeController = HomeController(user: user)
            
    @State private var isExpanded: Bool = false
    
    @State private var movies: [Movie] = [Movie(id: 191911, title: "Jumanji", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019"), Movie(id: 919191, title: "Black Panther", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019")]
    
    @State private var details = MovieDetails(status: "Test", tagline: "Test 2")
    
    @State var image: UIImage = UIImage(named: "app_icon")!
    
    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: .some(15)) {
                HStack {
                    Text(movies[1].title)
                        .font(Font.custom("helvetica", size: 45))
                        .padding(.leading)
                    Spacer()
                }
                
                Text("Ratings: \(String(movies[1].vote_average))")
                    .bold()
                .padding(.leading)
                Text("Status: \(details.status)")
                    .bold()
                    .padding(.leading)
                Text("Release Date: \(movies[1].release_date)")
                    .bold()
                    .padding(.leading)
                
                    
                HStack(alignment: .center) {
                    Spacer()
                    // change to api photo
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 350, alignment: .center)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    
                    Spacer()
                }
        
                VStack (alignment: .leading){
                    
                    Text(details.tagline)
                        .padding(.top)
                        .padding(.bottom)
                    
                    Text("Overview: ")
                        .bold()
                        .padding(.bottom)
                        .lineLimit(isExpanded ? nil : 3)
                                             
                    Text(movies[1].overview)
                        .padding(.bottom)
                        .lineLimit(isExpanded ? nil : 3)
                        .overlay(
                            GeometryReader { proxy in
                                Button(action: {
                                    isExpanded.toggle()
                                    }) {
                                Text(isExpanded ? "Less" : "Read More")
                                    .font(.body).bold()
                                    .padding(.leading, 8.0)
                                    .padding(.top, 4.0)
                                    .background(Color.clear)
                                    .foregroundColor(Color.black)
                                    }
                                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                            }
                        )
                    
                }
                .padding(.leading)
                .padding(.trailing)
                Spacer()
            }
            // change to api photo
            
        }
        .background(Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .blur(radius: 70.0))
        .onAppear(perform: {
            DispatchQueue.main.async {
                movieController.fetchItems(genreID: nil, numb: 1) { (movies) in
                    
                    self.movies = movies
                    
                    print(self.movies.count)
                    
                    updateUI(movieInfo: self.movies[1])
                    
                    castController.fetchCast(movieId: self.movies[1]) { (details) in
                        self.details = details
                    }
                    
                }
            }
        
        })
        
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

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView()
            .preferredColorScheme(.light)
    }
}
