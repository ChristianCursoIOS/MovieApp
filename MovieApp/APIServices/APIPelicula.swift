//
//  APIPelicula.swift
//  MovieApp
//
//  Created by christian on 16/09/22.
//

import Foundation

func Peliculas(genero: String, completion: @escaping (resultados) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=0c05938dc92f16576ba9ba8862db98f3&language=en-US&with_genres=" + genero)!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let generosData = try? JSONDecoder().decode(resultados.self, from: data) {
                DispatchQueue.main.sync {
                    completion(generosData)
                    return
                }
            }
        }
    }.resume()
}
