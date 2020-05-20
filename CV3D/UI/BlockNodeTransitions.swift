//
//  BlockNodeTransitions.swift
//  CV3D
//
//  Created by Jan Mazurczak on 20/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

extension BlockNode {
    
    func hide() {
        runAction(.sequence([
            .group([
                .move(to: SCNVector3(0, 0, -400), duration: 0.2),
                .fadeOpacity(to: 0, duration: 0.2)
            ]),
            .hide()
        ]), forKey: "focus")
    }
    
    func unhide() {
        runAction(.sequence([
            .unhide(),
            .group([
                .move(to: SCNVector3(0, 0, -200), duration: 0.2),
                .fadeOpacity(to: 0.14, duration: 0.3)
            ])
        ]), forKey: "focus")
    }
    
    func focusOut() {
        runAction(.group([
            .move(to: SCNVector3(0, 0, -200), duration: 0.2),
            .fadeOpacity(to: 0.14, duration: 0.4)
        ]), forKey: "focus")
        animateDeeplyEachChild(.defocus(in: 0.5), with: "focusing")
    }
    
    func focusIn() {
        runAction(.group([
            .move(to: SCNVector3Zero, duration: 0.3),
            .fadeOpacity(to: 1, duration: 0.2)
        ]), forKey: "focus")
        animateDeeplyEachChild(.focus(in: 0.4), with: "focusing")
    }
    
    func jumpIn() {
        opacity = 0
        position.z = 200
        eulerAngles = SCNVector3(.random(in: -1...1), .random(in: -1...1), .random(in: -1...1))
        runAction(.sequence([
            .wait(duration: 0.2),
            .group([
                .fadeIn(duration: 0.4),
                .rotateTo(x: 0, y: 0, z: 0, duration: 0.6),
                .move(to: SCNVector3Zero, duration: 0.6)
            ])
        ]), forKey: "jump")
    }
    
    func jumpOut() {
        runAction(.sequence([
            .group([
                .fadeOut(duration: 0.4),
                .move(to: SCNVector3(0, 0, 200), duration: 0.4),
                .rotateBy(x: .random(in: -1...1), y: .random(in: -1...1), z: .random(in: -1...1), duration: 0.4)
            ]),
            .removeFromParentNode()
        ]), forKey: "jump")
    }
    
}

extension SCNNode {
    func animateDeeplyEachChild(_ animation: CAAnimation, with key: String) {
        deepOnEachChild {
            $0.addAnimation(animation, forKey: key)
        }
    }
    func deepOnEachChild(perform action: (SCNNode) -> Void) {
        for child in childNodes {
            action(child)
            child.deepOnEachChild(perform: action)
        }
    }
}
