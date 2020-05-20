//
//  TitleNode.swift
//  CV3D
//
//  Created by Jan Mazurczak on 20/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class TitleNode: TextNode {
    
    override init(text: String) {
        super.init(text: text)
        textGeometry.font = .systemFont(ofSize: 36)
        textNode.filters = .title() + .focusing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
