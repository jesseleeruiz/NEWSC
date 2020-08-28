//
//  NewsCollectionViewCell.swift
//  NEWSC
//
//  Created by Jesse Ruiz on 8/27/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var unfocusedConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var focusedConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        focusedConstraint = textLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 15)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        focusedConstraint.isActive = isFocused
        unfocusedConstraint.isActive = !isFocused
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        })
    }
    
}
