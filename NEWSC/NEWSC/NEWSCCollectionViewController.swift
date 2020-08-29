//
//  NEWSCCollectionViewController.swift
//  NEWSC
//
//  Created by Jesse Ruiz on 8/27/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class NEWSCCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    let apiKey = "e2907074-4e5b-44c2-9916-6c2ad24e67e9"
    var articles = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let title = title,
            let url = URL(string: "https://content.guardianapis.com/\(title.lowercased())?api-key=\(apiKey)&show-fields=thumbnail,headline,standfirst,body") else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCollectionViewCell else { fatalError("Couldn't dequeue a cell") }
    
        let newsItem = articles[indexPath.row]
        let title = newsItem["fields"]["headline"].stringValue
        let thumbnail = newsItem["fields"]["thumbnail"].stringValue
        
        if let imageURL = URL(string: thumbnail) {
            newsCell.imageView.load(imageURL)
        }
        
        newsCell.textLabel.text = title
    
        return newsCell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - Methods
    func fetch(_ url: URL) {
        // Attempt to download the contents of this URL
        if let data = try? Data(contentsOf: url) {
            
            // Convert that to JSON and pull out the array we care about
            articles = JSON(data)["response"]["results"].arrayValue
            
            // Reload the collection view on the main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }

}
