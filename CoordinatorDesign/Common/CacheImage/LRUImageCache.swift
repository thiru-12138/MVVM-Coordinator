//
//  LRUImageCache.swift
//  Pasikudhey
//
//  Created by Thirumalai Ganesh G on 16/02/26.
//

import Foundation
import UIKit

final class ImageCacheNode {
    let key: URL
    var image: UIImage
    var prev: ImageCacheNode?
    var next: ImageCacheNode?
    
    init(key: URL, image: UIImage) {
        self.key = key
        self.image = image
    }
}

final class LRUImageCache {
    static let shared = LRUImageCache(capacity: 50)
    
    private let capacity: Int
    private var cache: [URL: ImageCacheNode] = [:]
    private var head: ImageCacheNode?
    private var tail: ImageCacheNode?
    
    private let queue = DispatchQueue(label: "com.image.lru.cache",
                                      attributes: .concurrent)
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func get(_ key: URL) -> UIImage? {
        queue.sync(execute: {
            guard let node = cache[key] else { return nil }
            moveToHead(node)
            return node.image
        })
    }
    
    func set(_ key: URL, image: UIImage) {
        queue.async(flags: .barrier) {
            if let node = self.cache[key] {
                node.image = image
                self.moveToHead(node)
            } else {
                let node = ImageCacheNode(key: key, image: image)
                self.cache[key] = node
                self.addToHead(node)
                
                if self.cache.count > self.capacity {
                    self.removeLRU()
                }
            }
        }
    }
    
    // MARK: - LRU Helpers
    
    private func addToHead(_ node: ImageCacheNode) {
        node.next = head
        head?.prev = node
        head = node
        if tail == nil { tail = node }
    }
    
    private func moveToHead(_ node: ImageCacheNode) {
        guard node !== head else { return }
        remove(node)
        addToHead(node)
    }
    
    private func remove(_ node: ImageCacheNode) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
        
        if node === head { head = node.next }
        if node === tail { tail = node.prev }
        
        node.prev = nil
        node.next = nil
    }
    
    private func removeLRU() {
        guard let lru = tail else { return }
        cache[lru.key] = nil
        remove(lru)
    }    
}
