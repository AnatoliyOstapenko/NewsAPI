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
    init(text: String) {
        
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.date(from: "yyyy-MM-DD")
//        let currentDate = formatter.string(from: date)
        
        //&from=\(currentDate)
        
        let initialURL = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=5da05c606b6846f7b5dbf3bd05653340&q=world"
        
        //"https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=\(K.keyAPI)&q=\(text)"
        
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


