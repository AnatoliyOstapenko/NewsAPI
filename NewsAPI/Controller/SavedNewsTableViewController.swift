//
//  SavedNewsTableViewController.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {

    var array = [NewsCoreData]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var webString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white // Back botton color is changed to white
        
        // registration nib
        tableView.register(UINib(nibName: "NewsAPITableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        loadData()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsAPITableViewCell

        let item = array[indexPath.row]
        // dispatch data from Core Data to Cell
        cell.newsDescription.text = item.newsDescription
        cell.publisher.text = item.publisher
        cell.publishedAt.text = item.publishedAt
        cell.title.text = item.title
        cell.url = item.url
        
        //convert String to UIImage data
        if let urlString = item.newsImage {
            if let url = URL(string: urlString) {
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard error == nil, let data = data else { return }
                    DispatchQueue.main.async {
                        cell.newsImage.image = UIImage(data: data)
                    }
                    
                }.resume()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = array[indexPath.row]
        
        webString = item.url

        // create action when a row clicked
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "delete", style: .destructive) { (alert) in
            self.deleteData(item)
        }
        let goToWeb = UIAlertAction(title: "read news", style: .default) { (alert) in
            
            self.goToWKWebVC()
            
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteButton)
        alert.addAction(goToWeb)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func goToWKWebVC() {

        // add a storyboard that should receive data from the current VC
        let storyboard = UIStoryboard(name: "NewsWKWeb", bundle: nil)
        // add VC that should receive data from the current VC
        guard let newsVC = storyboard.instantiateViewController(identifier: "NewsWKWeb") as? NewsWKWebViewController else { return }
         
        newsVC.url = webString
        show(newsVC, sender: nil) // switch to a next screen
    }

    
    
    //MARK: - Core Data Method
    
    func loadData() {
        do {
            array = try context.fetch(NewsCoreData.fetchRequest())
        } catch { print("loading error \(error)")}
        tableView.reloadData()
        
 
    }
    
    func saveData() {
        do {
            try context.save()
        } catch { print("saving error \(error)")}
        tableView.reloadData()
    }
    
    
    func deleteData(_ item: NewsCoreData) {
        
        context.delete(item)
        saveData()
        
    }
    


}
