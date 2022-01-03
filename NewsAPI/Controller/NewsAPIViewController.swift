//
//  ViewController.swift
//  NewsAPI
//
//  Created by MacBook on 02.01.2022.
//

import UIKit

class NewsAPIViewController: UIViewController {
    
    
    var array = [Articles]()
    var newsManager = NewsAPIManager.init(text: "world")
    var webString: String?
    
    
    @IBOutlet weak var newsSearchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsSearchBar.delegate = self
        
        // registration nib
        newsTableView.register(UINib(nibName: "NewsAPITableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        updateUI()
    }
    
    func updateUI() {
        newsManager.getData { [weak self] result in
            switch result {
            case .success(let news):
                self?.array = news.articles
                
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if segue.identifier == "goToNewsWKWebView" {
//
//            let destination = segue.destination as! NewsWKWebViewController
//
//            guard let urlString = webString else { return }
//            destination.load(urlString)
//
//
//        }
//
//    }

    
}

// MARK: - TableView Data Source Method

extension NewsAPIViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsAPITableViewCell
        
        // delegate TableViewController to cell. It's needed to use "present" in button in TVCell
        cell.tableViewController = self
        
        // get row from tableview
        let item = array[indexPath.row]
        
        //dispatch data to cell
        cell.publisher.text = item.source.publisher
        cell.newsDescription.text = item.description
        cell.publishedAt.text = item.publishedAt
        cell.title.text = item.title
        
        // transfer string data to cell
        cell.newsText = item.urlToImage
        
        // Convert string to UIImage anf dispatch to cell
        if let url = URL(string: item.urlToImage) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil, let data = data else { return }
                
                DispatchQueue.main.async {
                    cell.newsImage.image = UIImage(data: data)
                }
            }.resume() // it's mandatory
        }
        
        return cell
        
        
        
    }
    
}
// MARK: - TableView Delegate Method

extension NewsAPIViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = array[indexPath.row]
        webString = item.url
           print("something happens....")
//        self.performSegue(withIdentifier: "goToNewsWKWebView", sender: self)
    }
}

// MARK: - UISearchBarDelegate


extension NewsAPIViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        // add text to initialString in NewsManager
        self.newsManager = NewsAPIManager.init(text: text)
        updateUI()
        
    }
    
}

