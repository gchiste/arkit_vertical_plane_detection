//
//  ViewController.swift
//  VerticalPlaneDetection
//
//  Created by Gregory Chiste on 1/27/18.
//  Copyright © 2018 Gregory Chiste. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    
    @IBOutlet weak var ARView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARView.delegate = self
        ARView.session.delegate = self
        ARView.showsStatistics = true
        ARView.autoenablesDefaultLighting = true
        let ARScene = SCNScene()
        ARView.scene = ARScene
        //ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    //adding viewwillappear function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setting up our scene configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical //iOS 11.3 beta ONLY!
        // running our configured session in our pianoView, at this point we can actually see things on-screen
        ARView.session.run(configuration)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var planes: [SCNNode] = []
    // function is called whenever a new ARAnchor is rendered in the scene (a.k.a. whenever a vertical plane is detected)
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let size = planes.count
        if size > 0 {
            return nil
        }
        // creating SCNNode that we are going to return
        let ARAnchorNode = SCNNode()
        let planeNode = SCNNode()
        // converting the ARAnchor to an ARPlaneAnchor to get access to ARPlaneAnchor's extent and center values
        let anchor = anchor as? ARPlaneAnchor
        // creating plane geometry
        planeNode.geometry = SCNPlane(width: CGFloat((anchor?.extent.x)!), height: CGFloat((anchor?.extent.z)!))
        // transforming node
        planeNode.position = SCNVector3((anchor?.center.x)!, 0, (anchor?.center.z)!)
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "mona+lisa+frame")
        planeNode.eulerAngles = SCNVector3(-Float.pi/2,0,0)
        
        // adding plane node as child to ARAnchorNode due to mandatory ARKit conventions
        ARAnchorNode.addChildNode(planeNode)
        //returning ARAnchorNode (must return a node from this function to add it to the scene)
        planes.append(planeNode)
        return ARAnchorNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("test2")
        // converting the ARAnchor to an ARPlaneAnchor to get access to ARPlaneAnchor's extent and center values
        let anchor = anchor as? ARPlaneAnchor
        let updatedNode = node.childNodes.first
        
        if updatedNode == planes[0]{
            // creating plane geometry
            updatedNode?.geometry = SCNPlane(width: CGFloat((anchor?.extent.x)!), height: CGFloat((anchor?.extent.z)!))
            // transforming node
            updatedNode?.position = SCNVector3((anchor?.center.x)!, 0, (anchor?.center.z)!)
            updatedNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "mona+lisa+frame")
        }
        
    }
    
    
    
}

