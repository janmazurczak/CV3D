//
//  SceneViewController.swift
//  CV3D
//
//  Created by Jan Mazurczak on 17/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Configuration.current.explorationFlow.requestData(for: self)
    }

}

extension SceneViewController: Presenter {
    func present(_ cv: CV) {
        
    }
}

