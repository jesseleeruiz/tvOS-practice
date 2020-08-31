//
//  GameViewController.swift
//  Language Pairs
//
//  Created by Jesse Ruiz on 8/30/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class GameViewController: UICollectionViewController {
    
    // MARK: - Properties
    var targetLanguage = "english"
    var wordType = ""
    var words: [JSON]!
    var cells = [Int: CardCollectionViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let wordsPath = Bundle.main.url(forResource: wordType, withExtension: "json"),
            let contents = try? Data(contentsOf: wordsPath) else { return }
        
        words = JSON(contents).arrayValue
        
        // 1. Create an array. The numbers 0 through 17
        var cellNumbers = Array(0..<18)
        
        // 2. Shuffle the array
        cellNumbers.shuffle()
        
        // 3. Loop from 0 through 8, which is the number of cells we have divided by 2
        for i in 0..<9 {
            // 4. Remove two numbers: one for the picture and one for the word
            let pictureNumber = cellNumbers.removeLast()
            let wordNumber = cellNumbers.removeLast()
            
            // 5. Create index paths from those numbers and cells from the index paths
            let pictureIndexPath = IndexPath(item: pictureNumber, section: 0)
            let wordIndexPath = IndexPath(item: wordNumber, section: 0)
            
            guard let wordCell = collectionView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: wordIndexPath) as? CardCollectionViewCell,
                let pictureCell = collectionView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: pictureIndexPath) as? CardCollectionViewCell else { return }
            
            // 6. Tell the first cell its word, and give it the correct foreign language word for its label
            wordCell.word = words[i]["english"].stringValue
            wordCell.textLabel.text = words[i][targetLanguage].stringValue
            
            // 7. Tell the second cell the same word, but this time give it the correct image
            pictureCell.word = wordCell.word
            pictureCell.contents.image = UIImage(named: pictureCell.word)
            
            // 8. Store both cells in our dictionary so we can use them later
            cells[pictureNumber] = pictureCell
            cells[wordNumber] = wordCell
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cells[indexPath.row]!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.flip(to: "cardFrontNormal", hideContents: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if let previous = context.previouslyFocusedView {
                previous.transform = .identity
            }
            
            if let next = context.nextFocusedView {
                next.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        })
    }
}
