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
    
    // create UIRefreshControl
    let newsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    
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
        
        // add UIRefreshControl to TableView
        newsTableView.refreshControl = newsRefreshControl
    }
    
    // Add update data when user pull screen
    @objc private func refresh(sender: UIRefreshControl) {
        
        updateUI()
        sender.endRefreshing()
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
    
    func goToWKWebVC() {

        // add a storyboard that should receive data from the current VC
        let storyboard = UIStoryboard(name: "NewsWKWeb", bundle: nil)
        // add VC that should receive data from the current VC
        guard let newsVC = storyboard.instantiateViewController(identifier: "NewsWKWeb") as? NewsWKWebViewController else { return }
         
        newsVC.url = webString
        
        show(newsVC, sender: nil) // switch to a next screen
        
        
        
    }
    
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
        cell.url = item.url
        
        // transfer string data to cell
        cell.newsText = item.urlToImage
        
        // Convert string to UIImage anf dispatch to cell
        guard let image = item.urlToImage else { return UITableViewCell()} // urlToImage is optional
        if let url = URL(string: image) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil, let data = data else {
                    print("No image on site")
                    DispatchQueue.main.async {
                        cell.newsImage.image = UIImage(named: "noImage")
                    }
                    return }
                
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
        webString = item.url // catch url from cell
        
        let alert = UIAlertController(title: nil, message: "Whould you like to read the article?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.goToWKWebVC() // Go to NewsWKWeb story board
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)

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

