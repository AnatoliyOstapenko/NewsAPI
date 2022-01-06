//
//  K.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import Foundation
import UIKit

struct K {
    
    static let keyAPI = "5da05c606b6846f7b5dbf3bd05653340"
    static let sortBy = "publishedAt"
    
    
    static func customAlert(_ textAlert: String, _ viewController: UIViewController, _ vc: UIViewController) {
        
        // Create custom alert for reusing in different buttons
        let alert = UIAlertController(title: nil, message: textAlert, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
        
        
    }
}
