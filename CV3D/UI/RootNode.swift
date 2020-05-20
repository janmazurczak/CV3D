//
//  RootNode.swift
//  CV3D
//
//  Created by Jan Mazurczak on 20/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class RootNode: BlockNode {
    
    let box = SCNNode(geometry: SCNBox(width: 80, height: 80, length: 80, chamferRadius: 0))
    
    override init(block: CVBlock) {
        super.init(block: block)
        box.runAction(.repeatForever(.rotateBy(x: 0.6, y: -1, z: 1.1, duration: 5)))
        box.filters = .border() + .focusing()
        box.geometry?.firstMaterial = SCNMaterial()
        box.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        addChildNode(box)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fit(in size: SCNVector3) {
        super.fit(in: size)
        box.position.y = border.scale.y * 0.5 + 100
    }
    
}
