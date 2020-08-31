//
//  GameViewController.swift
//  Language Pairs
//
//  Created by Jesse Ruiz on 8/30/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class GameViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }

}
