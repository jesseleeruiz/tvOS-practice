//
//  ViewController.swift
//  Light Memo Game
//
//  Created by Jesse Ruiz on 8/21/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var result: UIImageView!
    
    // MARK: - Properties
    var activeCells = [IndexPath]()
    var flashSequence = [IndexPath]()
    var levelCounter = 0
    var flashSpeed = 0.25
    
    let levels = [
        [6, 7, 8], // 3 Lights
        [1, 3, 11, 13], // 4
        [5, 6, 7, 8, 9], // 5
        [0, 4, 5, 9, 10, 14], // 6
        [1, 2, 3, 7, 11, 12, 13], // 7
        [0, 2, 4, 5, 9, 10, 12, 14], // 8
        [1, 2, 3, 6, 7, 8, 11, 12, 13], // 9
        [0, 1, 2, 3, 4, 10, 11, 12, 13, 14], // 10
        [1, 2, 3, 5, 6, 7, 8, 9, 11, 12, 13], // 11
        [0, 1, 3, 4, 5, 6, 8, 9, 10, 11, 13, 14], // 12
        [0, 1, 2, 3, 4, 6, 7, 8, 10, 11, 12, 13, 14], // 13
        [0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14], // 14
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], // 15
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createLevel()
    }
    
    // MARK: - Methods
    func createLevel() {
        guard levelCounter < levels.count else { return }
        
        result.alpha = 0
        
        collectionView.visibleCells.forEach { $0.isHidden = true }
        activeCells.removeAll()
        
        for item in levels[levelCounter] {
            let indexPath = IndexPath(item: item, section: 0)
            activeCells.append(indexPath)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isHidden = false
        }
        
        activeCells.shuffle()
        
        flashSequence = Array(activeCells.dropFirst())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.flashLight()
        }
    }
    
    func flashLight() {
        // Try to remove an item from the flash sequence
        if let indexPath = flashSequence.popLast() {
            // Pull out the light at that position
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            
            // Find its image
            guard let imageView = cell.contentView.subviews.first as? UIImageView else { return }
            
            // Give it a green light
            imageView.image = UIImage(named: "greenLight")
            
            // Make it slightly smaller
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            // Start our animation
            UIView.animate(withDuration: flashSpeed, animations: {
                // Make it return to normal size
                cell.transform = .identity
            }) { _ in
                // Once the animation finishes make the light red again
                imageView.image = UIImage(named: "redLight")
                
                // Wait a tiny amount of time
                DispatchQueue.main.asyncAfter(deadline: .now() + self.flashSpeed) {
                    // Call ourselves again
                    self.flashLight()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.isUserInteractionEnabled = true
                self.setNeedsFocusUpdate()
            }
        }
    }
    
    func gameOver() {
        let alert = UIAlertController(title: "Game Over!", message: "You made it to level \(levelCounter)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Start Again", style: .default) { _ in
            self.levelCounter = 1
            self.createLevel()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Disable user interaction on our view
        view.isUserInteractionEnabled = false
        
        // Make the result image appear
        result.alpha = 1
        
        // If the user chose the correct answer
        if indexPath == activeCells[0] {
            // Make result show the "correct" image, add 1 to levelCounter, then call createLevel()
            result.image = UIImage(named: "correct")
            levelCounter += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.createLevel()
            }
        } else {
            // Otherwise the user chose wrongly, so show the "wrong" image then call gameOver()
            result.image = UIImage(named: "wrong")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.gameOver()
            }
        }
    }
    
}
