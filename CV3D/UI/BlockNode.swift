//
//  BlockNode.swift
//  CV3D
//
//  Created by Jan Mazurczak on 19/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

protocol LayoutableInBlock: SCNNode {
    /// Layouts text respecting given size and returns actual size of the result
    func fit(in size: SCNVector3) -> SCNVector3
}

class BlockNode: SCNNode {
    
    let elements: [LayoutableInBlock]
    let elementsOrigin = SCNNode()
    let border = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    init(block: CVBlock) {
        elements = [TitleNode(text: block.title)] + block.items.map {
            switch $0 {
            case .block(let block):
                return ButtonNode(text: block.title, item: $0)
            case .text(let text):
                return TextNode(text: text)
            case .link(let link):
                return ButtonNode(text: link.name, item: $0)
            case .mail(let mail):
                return ButtonNode(text: mail.name, item: $0)
            case .appStoreLink(let item):
                return ButtonNode(text: item.name, item: $0)
            }
        }
        super.init()
        
        for element in elements {
            elementsOrigin.addChildNode(element)
        }
        addChildNode(elementsOrigin)
        
        border.filters = .border() + .focusing()
        border.position.z = -2
        border.geometry?.firstMaterial = SCNMaterial()
        border.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        addChildNode(border)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fit(in size: SCNVector3) {
        let spacing: Float = 26
        let margin: Float = 50
        let maxWidth = min(size.x - (2 * margin), 600)
        var width: Float = 0
        var height = -spacing
        for element in elements.reversed() {
            height += spacing
            element.position.y = height
            let elementSize = element.fit(in: SCNVector3(maxWidth, size.y, 0))
            width = max(width, elementSize.x)
            height += elementSize.y
        }
        elementsOrigin.position.x = -0.5 * width
        elementsOrigin.position.y = -0.5 * height
        border.scale.x = width + margin
        border.scale.y = height + margin
    }
}
