//
//  MovieDetailView.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 3/22/21.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieController = MovieController()
        
    @State private var isExpanded: Bool = false
    
    @State private var movies: [Movie] = [Movie(title: "Jumanji", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019"), Movie(title: "Black Panther", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019")]
    
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
                
                Text("Release Date: \(movies[1].release_date)")
                    .bold()
                    .padding(.leading)
                Text("Ratings: \(String(movies[1].vote_average))")
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

                    Text("Cast:")
                        .bold()
                        
                    HStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(0..<5) { _ in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 150, alignment: .center)
                                        .cornerRadius(10.0)
                                }
                                
                            }
                            
                        }

                    }
                    
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
                movieController.fetchItems { (movies) in
                    
                    self.movies = movies
                    updateUI(movieInfo: self.movies[1])
                    
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

