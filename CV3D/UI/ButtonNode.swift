//
//  ButtonNode.swift
//  CV3D
//
//  Created by Jan Mazurczak on 20/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class ButtonNode: TextNode {
    
    let item: CVBranch
    
    init(text: String, item: CVBranch) {
        self.item = item
        super.init(text: text)
        textGeometry.font = .systemFont(ofSize: 28)
        textNode.filters = .button() + .focusing()
        textNode.addAnimation(CAAnimation.spark(), forKey: "spark")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
