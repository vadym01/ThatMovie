//
//  MovieSection.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.11.2023.
//

import SwiftUI

struct MovieSection: View {
    
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    
    @State private var selectedMovieSection: MovieEndpoints  = .trending
    @State private var selectedMovieGenre: MovieGenre?
    @Binding var displayAllGenres: Bool
    
    
    //    @Binding var movies: MovieApiPopular?
    @Binding var page: Int
    @Binding var selectedLanguage: Language
    
    
    
    
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(MovieEndpoints.allCases) { item in
                        Button(action: {
                            if (displayAllGenres) {
                                self.displayAllGenres = false
                            }
                            selectedMovieSection = item
                            if (item == .genre) {
                                Task {
                                    await restApiMovieVm.restMovieGenreListApi(url: item.path, selectedLanguage: selectedLanguage)
                                }
                            } else {
//                                let _ = print("----=====>>>>>>>>>>>")
//                                let _ = print(selectedMovieGenre?.name)
                                Task {
                                    //                                    await restApiMovieVm.restBaseMovieApi(url: item.path, selectedLanguage: selectedLanguage, page: 1)
                                    await restApiMovieVm.restBaseMovieApi(url: ApiUrls.moviesUrl(url: item.path, page: 1, language: selectedLanguage))
                                }
                            }
                        }, label: {
                            MovieSectionItemView(movieItemName: item.movieSection, isSelected: selectedMovieSection == item)
                        })
                    }
                }
            }
            .scrollIndicators(.never)
            if (selectedMovieSection == .genre) {
                
                HStack{
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(restApiMovieVm.movieGenre?.genres ?? []) { movieGenre in
                                //                                    let _ = print("----++++--------")
                                //                                    let _ = print(movieGenre.name)
                                Button(action: {
                                    let _ = print("----++++--------")
                                    let _ = print(movieGenre.name)
                                    withAnimation {
                                        self.selectedMovieGenre = movieGenre
                                    }
//                                    let _ = print("movieGenreId: \(selectedMovieGenre!.id)")
                                    if (displayAllGenres) {
                                        self.displayAllGenres = false
                                    }
                                    let str = "/3/discover/movie?with_genres=\(movieGenre.id)"
                                    Task {
                                        await restApiMovieVm.genreRestBaseMovieApi(url: str)
                                    }
                                }, label: {
                                    MovieSectionItemView(movieItemName: movieGenre.name, isSelected: self.selectedMovieGenre == movieGenre)
                                })
                            }
                        }
                        
                    }
                    .scrollIndicators(.never)
                    Button {
                        self.displayAllGenres.toggle()
//                        ForEach(restApiMovieVm.movieGenre?.genres ?? []) { movieGenre in
//                            restApiMovieVm.movieByGenreApi(url: ApiUrls.moviesByGenreId(genreId: movieGenre.id), genre: movieGenre)
//                        }
//                        if(restApiMovieVm.movieByGenreRest.count > 0) {
                            let _ = print("___++++____ is emp")
                            restApiMovieVm.movieByGenreApi()
//                        }
                    } label: {
                        Image(systemName: self.displayAllGenres ? "chevron.up" : "chevron.down")
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
                
                
            }
        }
        .task {
//            if (selectedMovieGenreVm.selectedMovieGenre == nil) {
//                let _ = print("0000>>>>>>>>>!!!!!")
//                let _ = print(selectedMovieGenreVm.selectedMovieGenre)
//            await restApiMovieVm.restBaseMovieApi(url: ApiUrls.moviesUrl(url: MovieEndpoints.trending.path, page: 1, language: selectedLanguage))
//            }
        }
        
        
    }
    
    private func selectedMovie(selectedItem: MovieEndpoints, item: MovieEndpoints) -> Bool {
        return selectedItem == item
    }
}

//#Preview {
//    MovieSection(restApiMovieVm: .init(), selectedMovieGenre: .constant(.none), displayAllGenres: .constant(false), page: .constant(1), selectedLanguage: .constant(.de))
//}
