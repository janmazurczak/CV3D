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
        scale = SCNVector3(0.01, 0.01, 0.01)
        runAction(.sequence([
            .fadeIn(duration: 0.1),
            .group([
                .scale(to: 1, duration: 0.3),
                .sequence([
                    .rotateTo(x: -0.1, y: 0, z: 0, duration: 0.1),
                    .rotateTo(x: 0.1, y: 0, z: 0, duration: 0.2),
                    .rotateTo(x: -0.1, y: 0, z: 0, duration: 0.16),
                    .rotateTo(x: 0.1, y: 0, z: 0, duration: 0.12),
                    .rotateTo(x: 0, y: 0, z: 0, duration: 0.06)
                ])
            ])
        ]), forKey: "jump")
    }
    
    func jumpOut() {
        runAction(.sequence([
            .group([
                .fadeOut(duration: 0.2),
                .move(to: SCNVector3(0, 0, 200), duration: 0.2)
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
