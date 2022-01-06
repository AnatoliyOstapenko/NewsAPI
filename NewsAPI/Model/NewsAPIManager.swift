//
//  NewsAPIManager.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import Foundation
struct NewsAPIManager {
 
    let initialURL: String

    // Handling text from
    init(text: String, sortBy: String) {
        
        
        let initialURL = "https://newsapi.org/v2/top-headlines?apiKey=\(K.keyAPI)&q=\(text)&sortBy=\(sortBy)&sources=&country=&cattegory="
        
        // https://newsapi.org/v2/everything?apiKey=\(K.keyAPI)&q=\(text)&sortBy=\(sortBy)
        
        print("initial URL ..... \(initialURL)")
        
        self.initialURL = initialURL
    }
    
    func getData(completion: @escaping(Result<NewsAPIModel, Error>) -> Void) {
        
        guard let url = URL(string: initialURL) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            do {
                let data = try JSONDecoder().decode(NewsAPIModel.self, from: data)
        
                    completion(.success(data))
                    
                
                
            } catch { print(error) }
        }
        dataTask.resume()
        
    }
    
    
    
    
    
}


