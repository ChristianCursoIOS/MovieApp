//
//  APIGeneros.swift
//  MovieApp
//
//  Created by christian on 16/09/22.
//

import Foundation

func GenerosPelicula(completion: @escaping (Generos) -> Void){
    let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=0c05938dc92f16576ba9ba8862db98f3")!
    URLSession.shared.dataTask(with: url){
        data, response, error in
        if let data = data {
            if let messages = try? JSONDecoder().decode(Generos.self, from: data){
                completion(messages)
                return
            }
        }
    }.resume()
}

func fetchMessenges(completion: @escaping (Pelis) -> Void){
    let url = URL(string: "https://api.themoviedb.org/3/movie/333?language=en-US&api_key=0c05938dc92f16576ba9ba8862db98f3")!
    URLSession.shared.dataTask(with: url){
        data, response, error in
        if let data = data {
            if let messages = try? JSONDecoder().decode(Pelis.self, from: data){
                completion(messages)
                return
            }
        }
    }.resume()
}

func BuscaGenero(x : Int) -> String{
    
    var idGenero: String = "18"
    let arregloDeGeneros = [28,12,16,35,80,99,18,10751,14,36,27,10402,9648,10749,878,10770,53,10752,37]
    for y in arregloDeGeneros {
        if x == y {
            idGenero = String(y)
        }
    }
    return idGenero
}

