//
//  TextNode.swift
//  CV3D
//
//  Created by Jan Mazurczak on 20/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class TextNode: SCNNode {
    
    let textGeometry: SCNText
    let textNode = SCNNode()
    
    init(text: String) {
        textGeometry = SCNText(string: text, extrusionDepth: 1)
        super.init()
        textGeometry.font = .systemFont(ofSize: 20)
        textGeometry.alignmentMode = CATextLayerAlignmentMode.left.rawValue
        textGeometry.firstMaterial = SCNMaterial()
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        textNode.geometry = textGeometry
        textNode.filters = .text() + .focusing()
        addChildNode(textNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextNode: LayoutableInBlock {
    
    /// Layouts text respecting given size and returns actual size of the result
    func fit(in size: SCNVector3) -> SCNVector3 {
        textGeometry.containerFrame = CGRect(origin: .zero, size: CGSize(width: CGFloat(size.x), height: CGFloat(size.y)))
        textGeometry.truncationMode = CATextLayerTruncationMode.end.rawValue
        textGeometry.isWrapped = true
        let bounds = textGeometry.boundingBox
        textNode.position.y = -bounds.min.y
        return SCNVector3(bounds.max.x - bounds.min.x, bounds.max.y - bounds.min.y, 0)
    }
    
}
