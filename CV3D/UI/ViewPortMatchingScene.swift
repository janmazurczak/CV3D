//
//  ViewPortMatchingScene.swift
//  CV3D
//
//  Created by Jan Mazurczak on 19/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import SceneKit

class ViewPortMatchingScene: SCNScene {
    
    let camera = SCNNode()
    
    /// Use x and y as a maximum distance from x0,y0 at z = 0 to fit in current viewport.
    private(set) var fov: SCNVector3 = SCNVector3Zero
    
    override init() {
        super.init()
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCamera()
    }
    
    private func setupCamera() {
        camera.camera = SCNCamera()
        camera.camera?.zFar = 10000
        camera.camera?.zNear = 0.1
        setupCameraToMatchViewport(width: 320)
        rootNode.addChildNode(camera)
    }
    
    /// Ensures that at z = 0 viewport will render the given number of units horizontally
    private func setupCameraToMatchViewport(width: Float) {
        camera.camera?.fieldOfView = 60
        camera.camera?.projectionDirection = .horizontal
        camera.position = SCNVector3(0, 0, width * sqrt(3) / 2)
    }
    
    func setViewPort(size: CGSize) {
        setupCameraToMatchViewport(width: Float(size.width))
        fov = SCNVector3(
            Float(size.width),
            Float(size.height),
            0
        )
        layout()
    }
    
    func layout() {
        
    }
    
}
