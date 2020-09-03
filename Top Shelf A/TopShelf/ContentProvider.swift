//
//  ContentProvider.swift
//  TopShelf
//
//  Created by Jesse Ruiz on 9/3/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        
        var items = [TVTopShelfItem]()
        
        for i in 1...3 {
            let id = UUID().uuidString
            
            let item = TVTopShelfItem(identifier: id)
            
            item.setImageURL(Bundle.main.url(forResource: String(i), withExtension: "jpg"), for: .screenScale1x)
            item.setImageURL(Bundle.main.url(forResource: String(i), withExtension: "jpg"), for: .screenScale2x)
            
            item.displayAction = URL(string: "TopShelfA://display/\(id)").map { TVTopShelfAction(url: $0) }
            item.playAction = URL(string: "TopShelfA://play/\(id)").map { TVTopShelfAction(url: $0) }
            
            items.append(item)
        }
        completionHandler(items as? TVTopShelfContent);
    }
}
