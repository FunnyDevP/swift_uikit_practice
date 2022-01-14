//
//  APIManager.swift
//  placeholder
//
//  Created by Waranchit Chaiwong on 1/14/22.
//
import Foundation

class APIManager {
    func fetchItems<T: Decodable>(url: URL,completion: @escaping (Result<[T],Error>) -> Void){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(users))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
