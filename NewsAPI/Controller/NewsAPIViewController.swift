//
//  ViewController.swift
//  NewsAPI
//
//  Created by MacBook on 02.01.2022.
//

import UIKit

class NewsAPIViewController: UIViewController {
    
    
    var array = [Articles]()
    var newsManager = NewsAPIManager.init(text: "world", sortBy: "popularity")
    var webString: String?
    var request = Request()
    var pic = 0

    
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


        //navigationController?.navigationBar.tintColor = .black // Back botton color is changed to white
        
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
                print("There is a problem with get data from url: \(error)")
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
    
    
    @IBAction func sortingButtonPressed(_ sender: UIBarButtonItem) {

        newsManager = NewsAPIManager.init(text: "world", sortBy: K.sortBy)
        print("newsManager")
        updateUI()
    }
    
    @IBAction func sourcesButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Choose a source you like to read", preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields?.first?.placeholder = "type name of source"
        let done = UIAlertAction(title: "done", style: .default) { (action) in
            
            guard let text = alert.textFields?.first?.text else {
                
                K.issueAlert("Try type any other source", self)
                return
                
            }
            
            let replacedText = text.replacingOccurrences(of: " ", with: "-") // replaced space to dash
            
            print("replaced text: \(replacedText)")
            
            self.newsManager = NewsAPIManager(sources: replacedText, country: "", category: "")
            self.updateUI()
        }
        alert.addAction(done)
        present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        
        switch sender.currentTitle {
        case "category":
            pic = 1
        case "country":
            pic = 2
        default:
            print("There is no current title")
        }

       // Create VC that contains PickerView
 
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 100)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        
        K.customAlert("First choose a country", self, vc)

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
        
        guard let source = item.source?.publisher else { return UITableViewCell() } // source is optional

        //dispatch data to cell
        cell.publisher.text = source
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
                        cell.newsImage.image = UIImage(named: "NoImage")
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == array.count - 1 {

            newsManager.getData { [weak self] result in
                    switch result {
                    case .success(let news):
                        self?.array = news.articles
                        
                        DispatchQueue.main.async {
                            self?.newsTableView.reloadData()
                        }
                    case .failure(let error):
                        print("There is a problem with get data from url: \(error)")
                    }
                }
    

            
            
            
            
        }
    }
}

// MARK: - UISearchBarDelegate

extension NewsAPIViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        // add text to initialString in NewsManager
        self.newsManager = NewsAPIManager.init(text: text, sortBy: "popularity")
        updateUI()
        
    }
    
}
// MARK:- UIPickerViewDataSource Method

extension NewsAPIViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pic {
        case 1:
            return request.category.count
        case 2:
            return request.country.count
        default:
            return 1
        }
    }
    
    
}
// MARK:- UIPickerViewAccessibilityDelegate Method

extension NewsAPIViewController: UIPickerViewAccessibilityDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pic {
        case 1:
            return request.category[row]
        case 2:
            return request.country[row]
        default:
            return "no proper request category"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pic {
        case 1:
            newsManager = NewsAPIManager(sources: "", country: request.country[row], category: request.category[row])
            updateUI()
            print(request.category[row])
        case 2:
            newsManager = NewsAPIManager(sources: "", country: request.country[row], category: "")
            updateUI()
            print(request.country[row])
        default:
            print("no proper request category")
    }
    
}

}
