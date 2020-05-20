//
//  SceneViewController.swift
//  CV3D
//
//  Created by Jan Mazurczak on 17/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import UIKit
import SceneKit
import SafariServices
import StoreKit
import MessageUI

class SceneViewController: UIViewController {
    
    let scene = Scene()
    @IBOutlet weak var sceneView: SCNView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        Configuration.current.explorationFlow.requestData(for: self)
    }
    
    private func setupSceneView() {
        sceneView?.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.1176470588, blue: 0.1647058824, alpha: 1)
        sceneView?.scene = scene
        sceneView?.autoenablesDefaultLighting = false
        sceneView?.allowsCameraControl = false
        sceneView?.antialiasingMode = .none
        sceneView?.pointOfView = scene.camera
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene.setViewPort(size: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scene.setViewPort(size: size)
    }
    
    @IBAction func tap(with gesture: UITapGestureRecognizer) {
        let hit = sceneView?.hitTest(
            gesture.location(in: sceneView),
            options: [.boundingBoxOnly : true, .ignoreHiddenNodes : true])
        let buttons = hit?.compactMap {
            $0.node.selfOrFirstAncestor(where: { $0 is ButtonNode }) as? ButtonNode
        }
        let button = buttons?.filter {
            $0.selfOrFirstAncestor(where: { $0 == scene.blocks.last }) != nil
        }.first
        
        guard let item = button?.item else { scene.pop(); return }
        
        switch item {
        case .block(let block):
            let node = BlockNode(block: block)
            scene.push(block: node)
        case .text:
            break
        case .link(let link):
            let vc = SFSafariViewController(url: link.url)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .mail(let mail):
            guard MFMailComposeViewController.canSendMail() else { return }
            let vc = MFMailComposeViewController()
            vc.setToRecipients([mail.mail])
            vc.setSubject(mail.subject)
            vc.mailComposeDelegate = self
            present(vc, animated: true, completion: nil)
        case .appStoreLink(let item):
            let vc = SKStoreProductViewController()
            vc.delegate = self
            vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : item.itemID]) { _, _ in }
            present(vc, animated: true, completion: nil)
        }
    }
    
}

extension SceneViewController: Presenter {
    func present(_ cv: CV) {
        let node = RootNode(block: cv.root)
        scene.set(root: node)
    }
}

extension SceneViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SceneViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SceneViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SCNNode {
    func selfOrFirstAncestor(where check: (SCNNode) -> Bool) -> SCNNode? {
        if check(self) {
            return self
        } else {
            return parent?.selfOrFirstAncestor(where: check)
        }
    }
}

