//
//  NewsAPITableViewCell.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import UIKit
import CoreData

class NewsAPITableViewCell: UITableViewCell {
    
    var coreDataList = [NewsCoreData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var newsVC = NewsAPIViewController()
    var newsText: String?
    
    // create UIViewController class to use present in button
    var tableViewController: UIViewController?


    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var title: UILabel!
    
    

    
    
    
    @IBAction func saveNewsButtonPressed(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "add news you like", message: "", preferredStyle: .alert)
        
        // add buttons
        let addButton = UIAlertAction(title: "add", style: .default) { (action) in
            
            let item = NewsCoreData(context: self.context)
            
            // Dispatch data from labels and wedString to Core Data
            item.newsDescription = self.newsDescription.text
            item.publishedAt = self.publishedAt.text
            item.publisher = self.publisher.text
            item.url = self.newsVC.webString
            item.newsImage = self.newsText
            item.title = self.title.text
            
            self.coreDataList.append(item)
            self.saveData()
        }
        
        let cancelButton = UIAlertAction(title: "cancel", style: .destructive, handler: nil)

        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        // use tableViewController?. because we in cell controller (No UIViewController class by default)
        tableViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    func saveData() {
        do {
            try context.save()
        } catch { print("saving error \(error)")}
        
    }
    
    
}
