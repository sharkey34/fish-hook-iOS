//
//  UIImageViewExtension.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/19/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func caschURL(imageID: String){
        self.image = nil
        
        print("we in here")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/tournament%2F\(imageID).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
        
        if let image = cache.object(forKey: imageID as AnyObject) as? UIImage {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                if let data = data {
                    guard let image = UIImage(data: data) else {return}
                    cache.setObject(image, forKey: imageID as AnyObject)
                    self.image = image
                }
            }
        }.resume()
    }
}
