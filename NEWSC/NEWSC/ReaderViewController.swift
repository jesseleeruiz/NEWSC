//
//  ReaderViewController.swift
//  NEWSC
//
//  Created by Jesse Ruiz on 8/29/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var headline: UILabel!
    @IBOutlet var imageView: RemoteImageView!
    @IBOutlet var body: UITextView!
    
    // MARK: - Properties
    var article: JSON?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let article = article else { return }
        
        if let url = article["fields"]["thumbnail"].url {
            imageView.load(url)
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.cornerRadius = 20
        }
        
        headline.text = article["fields"]["headline"].stringValue
        body.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let articleBody = article["fields"]["body"].stringValue
        let formattedArticleBody = formatHTML(articleBody)
        
        if let articleBodyData = formattedArticleBody.data(using: .utf8) {
            if let bodyText = try? NSAttributedString(data: articleBodyData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
                body.attributedText = bodyText
            }
        }
        
        body.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.indirect.rawValue] as [NSNumber]
        body.isSelectable = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods
    func formatHTML(_ html: String) -> String {
        guard let wrapperURL = Bundle.main.url(forResource: "wrapper", withExtension: "html") else { return html }
        guard let wrapper = try? String(contentsOf: wrapperURL) else { return html }
        return wrapper.replacingOccurrences(of: "%@", with: html)
    }

}
