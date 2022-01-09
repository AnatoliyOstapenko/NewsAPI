//
//  NewsAPIManager.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import Foundation
struct NewsAPIManager {
 
    var initialURL: String

    init(text: String, sortBy: String) {
        
        
        let urlEverything = "https://newsapi.org/v2/everything?apiKey=\(K.keyAPI)&q=\(text)&sortBy=\(sortBy)"
        // "https://newsapi.org/v2/top-headlines?apiKey=\(K.keyAPI)&q=\(text)&sortBy=\(sortBy)&sources=\(sources)&country=\(country)&cattegory=\(category)"
        // https://newsapi.org/v2/everything?apiKey=\(K.keyAPI)&q=\(text)&sortBy=\(sortBy)
        
        print("urlEverything ..... \(urlEverything)")
        
        self.initialURL = urlEverything
    }
    
    init(sources: String, country: String, category: String) {
        
        
        let urlTopHeadlines = "https://newsapi.org/v2/top-headlines?apiKey=\(K.keyAPI)&sources=\(sources)&country=\(country)&cattegory=\(category)"
        
        print("urlTopHeadlines ..... \(urlTopHeadlines)")
        
        self.initialURL = urlTopHeadlines
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


