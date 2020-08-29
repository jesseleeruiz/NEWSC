//
//  RemoteImageView.swift
//  NEWSC
//
//  Created by Jesse Ruiz on 8/28/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {
    
    // MARK: - Properties
    var url: URL?
    
    
    // MARK: - Methods
    func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func load(_ url: URL) {
        // Stash the URL away for later checking
        self.url = url
        
        // Create a safe-to-save version of this URL that will be our cache filename
        guard let savedFilename = url.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return }
        
        // Append that to the caches directory to get a complete path
        let fullPath = getCacheDirectory().appendingPathComponent(savedFilename)
        
        // If the cached image exists already
        if FileManager.default.fileExists(atPath: fullPath.path) {
            // Use it and return
            image = UIImage(contentsOfFile: fullPath.path)
            return
        }
        
        // Still here? Push work to a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            // Download the image data
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            // Write it to our cache file
            try? imageData.write(to: fullPath)
            
            // Now the image has downloaded check it's still the one we want
            if self.url == url {
                // Push work back to the main thread
                DispatchQueue.main.async {
                    // Update our image
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
