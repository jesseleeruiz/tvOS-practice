//
//  CardCollectionViewCell.swift
//  Language Pairs
//
//  Created by Jesse Ruiz on 8/30/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var card: UIImageView!
    @IBOutlet var contents: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    // MARK: - Properties
    var word = "?"
    
    // MARK: - Methods
    func flip(to image: String, hideContents: Bool) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
                            self.card.image = UIImage(named: image)
                            self.contents.isHidden = hideContents
                            self.textLabel.isHidden = hideContents
        })
    }
}
