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
        print("webString in second time: \(webString ?? "error")")
        
        // create action when a row clicked
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "delete", style: .destructive) { (alert) in
            self.deleteData(item)
        }
        let goToWeb = UIAlertAction(title: "read news", style: .default) { (alert) in
            
            print("clicked gotoweb button")
            
//            // switch to NewsWKWebView
//            self.performSegue(withIdentifier: "goToSavedNews", sender: self)
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteButton)
        alert.addAction(goToWeb)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    // MARK: - Prepare Segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if segue.identifier == "goToSavedNews" {
//
//            let destination = segue.destination as! SavedWKViewController
//
//            guard let urlString = webString else { return }
//            destination.loadWeb(urlString)
//
//
//        }
//
//    }
    
    
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
