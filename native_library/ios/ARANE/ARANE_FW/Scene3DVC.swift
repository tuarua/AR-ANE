/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */

import UIKit
import FreSwift
import ARKit

class Scene3DVC: UIViewController, ARSCNViewDelegate, FreSwiftController {
    var TAG: String? = "ViewController"
    var context: FreContextSwift!
    private var sceneView: ARSCNView!
    private var viewPort: CGRect = CGRect.zero
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: ARSCNView) { //pass in session
        self.init()
        self.context = context
        self.viewPort = frame
        self.sceneView = arview
        
    }
    
    deinit {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        sceneView.delegate = self as ARSCNViewDelegate
        trace("adding session")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDebugOptions(_ options: Dictionary<String, Any>) {
        sceneView.debugOptions.remove(ARSCNDebugOptions.showFeaturePoints)
        sceneView.debugOptions.remove(ARSCNDebugOptions.showWorldOrigin)
        // TODO SCNDebugOptions
        if options["showFeaturePoints"] as! Bool {
            sceneView.debugOptions.formUnion(ARSCNDebugOptions.showFeaturePoints)
        }
        if options["showWorldOrigin"] as! Bool {
            sceneView.debugOptions.formUnion(ARSCNDebugOptions.showWorldOrigin)
        }
        
    }
    
    func runSession(configuration: ARWorldTrackingConfiguration) {
        trace("configuration", configuration.debugDescription)
        sceneView.session.run(configuration)
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    func addChildNode(parentId: String?, node: SCNNode) {
        if let pId = parentId,
            let pNode = sceneView.scene.rootNode.childNode(withName: pId, recursively: true) {
            pNode.addChildNode(node)
        } else {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func setChildNodeProp(id:String, name: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: id, recursively: true)
            else { return }
        node.setProp(name: name, value: value)
    }
    
    func setGeometryProp(type:String, nodeId:String, name:String, value:FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeId, recursively: true)
            else { return }
        
        switch type {
        case "box":
            trace("node: \(nodeId) - setting property \(name) of box to \(value.value.debugDescription)")
            if let geom:SCNBox = node.geometry as? SCNBox {
                geom.setProp(name: name, value: value)
            }
            break
        case "sphere":
            trace("node: \(nodeId) - setting property \(name) of sphere to \(value.value.debugDescription)")
            if let geom:SCNSphere = node.geometry as? SCNSphere {
                geom.setProp(name: name, value: value)
            }
            break
        case "capsule":
            trace("node: \(nodeId) - setting property \(name) of capsule to \(value.value.debugDescription)")
            if let geom:SCNCapsule = node.geometry as? SCNCapsule {
                geom.setProp(name: name, value: value)
            }
            break
        case "cone":
            trace("node: \(nodeId) - setting property \(name) of cone to \(value.value.debugDescription)")
            if let geom:SCNCone = node.geometry as? SCNCone {
                geom.setProp(name: name, value: value)
            }
            break
        case "cylinder":
            trace("node: \(nodeId) - setting property \(name) of cylinder to \(value.value.debugDescription)")
            if let geom:SCNCylinder = node.geometry as? SCNCylinder {
                geom.setProp(name: name, value: value)
            }
            break
        case "plane":
            trace("node: \(nodeId) - setting property \(name) of plane to \(value.value.debugDescription)")
            if let geom:SCNPlane = node.geometry as? SCNPlane {
                geom.setProp(name: name, value: value)
            }
            break
        case "pyramid":
            trace("node: \(nodeId) - setting property \(name) of pyramid to \(value.value.debugDescription)")
            if let geom:SCNPyramid = node.geometry as? SCNPyramid {
                geom.setProp(name: name, value: value)
            }
            break
        case "torus":
            trace("node: \(nodeId) - setting property \(name) of torus to \(value.value.debugDescription)")
            if let geom:SCNTorus = node.geometry as? SCNTorus {
                geom.setProp(name: name, value: value)
            }
            break
        case "tube":
            trace("node: \(nodeId) - setting property \(name) of tube to \(value.value.debugDescription)")
            if let geom:SCNTube = node.geometry as? SCNTube {
                geom.setProp(name: name, value: value)
            }
            break
        default:
            break
        }
    }
    
    
    
    func setScene3DProp(name: String, value: FREObject) {
        sceneView.setProp(name: name, value: value)
    }
    
    // TODO horizontal planes - check working
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // TODO if plane detection
        trace("anchor added: Delegate method", anchor.debugDescription)
        if anchor is ARPlaneAnchor {
            trace("got an ARPlaneAnchor")
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane.init(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            // sceneView.session.configuration as! ARWorldTrackingConfiguration).planeDetection
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3.init(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            plane.materials = [gridMaterial]
        } else {
            return
        }
    }
    
}

