//
//  Scene.swift
//  CV3D
//
//  Created by Jan Mazurczak on 19/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class Scene: ViewPortMatchingScene {
    
    private(set) var blocks = [BlockNode]()
    
    func set(root block: BlockNode) {
        blocks.forEach { $0.removeFromParentNode() }
        blocks = [block]
        rootNode.addChildNode(block)
        block.fit(in: fov)
        block.jumpIn()
    }
    
    func push(block: BlockNode) {
        if blocks.count > 1 {
            blocks[blocks.count - 2].hide()
        }
        blocks.last?.focusOut()
        blocks.append(block)
        rootNode.addChildNode(block)
        block.fit(in: fov)
        block.jumpIn()
    }
    
    func pop() {
        guard blocks.count > 1 else { return }
        let popped = blocks.removeLast()
        popped.jumpOut()
        blocks.last?.focusIn()
        if blocks.count > 1 {
            blocks[blocks.count - 2].unhide()
        }
    }
    
    override func layout() {
        for block in blocks {
            block.fit(in: fov)
        }
    }
    
}
