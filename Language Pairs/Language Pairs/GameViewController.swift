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
    var numCorrect = 0
    var first: CardCollectionViewCell?
    var second: CardCollectionViewCell?

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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cells[indexPath.row]!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        if first == nil {
            // They flipped their first card
            first = cell
        } else if second == nil && cell != first {
            // They flipped their second card
            second = cell
            
            // Stop them from flipping more cards
            view.isUserInteractionEnabled = false
            
            // Wait a little, then check their answer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.checkAnswer()
            }
        } else {
            // They are trying to slip a third card - exit!
            return
        }
        // Perform the flip transition
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return false }
        return !cell.word.isEmpty
    }
    
    // MARK: - Methods
    func checkAnswer() {
        // 1. Make sure both first and second are set
        guard let firstCard = first,
            let secondCard = second else { return }
        
        // 2. Check the word property of both cards match
        if firstCard.word == secondCard.word {
            // 3. Clear the word property of both cards so the player can't use them again
            firstCard.word = ""
            secondCard.word = ""
            
            // 4. Make both cards flash yellow
            firstCard.card.image = UIImage(named: "cardFrontHighlighted")
            secondCard.card.image = UIImage(named: "cardFrontHighlighted")
            
            // 5. Wait 0.1 seconds then make both cards animate to a green image
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.transition(with: firstCard.card,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    firstCard.card.image = UIImage(named: "cardFrontCorrect")
                })
                
                UIView.transition(with: secondCard.card,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    secondCard.card.image = UIImage(named: "cardFrontCorrect")
                })
                
                // 6. Add 1 to their score, and check if we need to end the game
                self.numCorrect += 1
                
                if self.numCorrect == 9 {
                    self.gameOver()
                }
            }
        } else {
            // 7. Clear first and second, then re-enable user interaction
            first = nil
            second = nil
            view.isUserInteractionEnabled = true
        }
    }
    
    func gameOver() {
        // Create a new image view and add it, but make it hidden
        let imageView = UIImageView(image: UIImage(named: "youWin"))
        imageView.center = view.center
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.addSubview(imageView)
        
        // Use a spring animation to show the image view
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
                        imageView.alpha = 1
                        imageView.transform = .identity
        })
        
        // Go back to the menu after two seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
}
