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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let title = title,
            let url = URL(string: "https://content.guardianapis.com/\(title.lowercased())?api-key=\(apiKey)&show-fields=thumbnail,headline,standfirst,body") else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reader = storyboard?.instantiateViewController(identifier: "Reader") as? ReaderViewController else { return }
        reader.article = articles[indexPath.row]
        present(reader, animated: true)
    }
    
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

extension NEWSCCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.isEmpty {
            articles = [JSON]()
            collectionView?.reloadData()
        } else {
            guard let url = URL(string: "https://content.guardianapis.com/search?api-key=\(apiKey)&q=\(text)&show-fields=thumbnail,headline,standfirst,body") else { return }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.fetch(url)
            }
        }
    }
}
