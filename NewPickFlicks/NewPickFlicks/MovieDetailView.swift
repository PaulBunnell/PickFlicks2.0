//
//  MovieDetailView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/31/21.
//

import SwiftUI

struct MovieDetailView: View {
        
    let movieController = MovieController()
    
    var user: User
    
    @Environment(\.presentationMode) var presentationMode
            
    @State private var isExpanded: Bool = false
    
    @State private var showingAlert = false

    @State private var movies: [Movie] = [Movie(id: 191911, title: "Jumanji", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019"), Movie(id: 919191, title: "Black Panther", overview: "Joe Gardner is a middle school teacher with a love for jazz music. After a successful gig at the Half Note Club, he suddenly gets into an accident that separates his soul from his body and is transported to the You Seminar, a center in which souls develop and gain passions before being transported to a newborn child. Joe must enlist help from the other souls-in-training, like 22, a soul who has spent eons in the You Seminar, in order to get back to Earth.", vote_average: 9.7, poster_path: "A path", release_date: "2019")]
    
    @State private var details = MovieDetails(status: "Test", tagline: "Test 2")
    
    @State var image: UIImage = UIImage(named: "app_icon")!
    
    var body: some View {
        
        HStack {
            Text(movies[0].title)
                .font(Font.custom("helvetica", size: 45))
                .bold()
                .padding(.leading)
                .padding(.top)
            Spacer()
        }
        ScrollView {
            VStack(alignment: .leading, spacing: .some(15)) {
                
                Text("Ratings: \(String(movies[0].vote_average))")
                    .bold()
                    .padding(.leading)
                Text("Release Date: \(movies[0].release_date)")
                    .bold()
                    .padding(.leading)
                    .padding(.bottom)
                
                HStack(alignment: .center) {
                    Spacer()
                    // change to api photo
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 350, alignment: .center)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 20, x: 5, y: 5 )

                    Spacer()
                }
                .padding(.top)
                .padding(.bottom)
        
                VStack (alignment: .leading){
                    
                    Text("Overview: ")
                        .bold()
                        .padding(.bottom)
                        .lineLimit(isExpanded ? nil : 3)
                                             
                    Text(movies[0].overview)
                        .padding(.bottom)
                        .lineLimit(isExpanded ? nil : 3)
                        .overlay(
                            GeometryReader { proxy in
                                Button(action: {
                                    isExpanded.toggle()
                                    }) {
                                Text(isExpanded ? "Less" : "Read More")
                                    .font(.title3).bold()
                                    .padding(.leading, 8.0)
                                    .padding(.top, 7.0)
                                    .background(Color.clear)
                                    .foregroundColor(Color.white)
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
                        .blur(radius: 70.0)
        )
        .onAppear(perform: {
            DispatchQueue.main.async {
                movies.removeAll()
                updateUI(movieInfo: MovieDetail.detailedMovie!)
                movies.append(MovieDetail.detailedMovie!)
            }
        
        })
        .padding(.top)
        
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

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView()
//            .preferredColorScheme(.light)
//    }
//}
