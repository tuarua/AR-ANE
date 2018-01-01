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
    var TAG: String? = "Scene3DVC"
    var context: FreContextSwift!
    private var sceneView: ARSCNView!
    private var viewPort: CGRect = CGRect.zero
    private var planeDetection:Bool = false
    private var anchors: Dictionary<String, ARAnchor> = Dictionary()
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: ARSCNView) {
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
        sceneView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseSession()
    }
    
    func setDebugOptions(options: Array<String>) {
        var debugOptions:SCNDebugOptions = []
        for option in options {
            debugOptions.formUnion(SCNDebugOptions.init(rawValue: UInt(option)!))
        }
        sceneView.debugOptions = debugOptions
    }
    
    func runSession(configuration: ARWorldTrackingConfiguration, options: Array<Int>) {
        planeDetection = configuration.planeDetection.rawValue > 0
        var runOptions:ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions.init(rawValue: UInt(i)))
        }
        sceneView.session.run(configuration, options: runOptions)
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    func addAnchor(anchor:ARAnchor) {
        sceneView.session.add(anchor: anchor)
        anchors[anchor.identifier.uuidString] = anchor
    }
    
    func removeAnchor(id:String) {
        guard let anchor = anchors[id] else { return }
        sceneView.session.remove(anchor: anchor)
    }
    
    func addChildNode(parentId: String?, node: SCNNode) {
        if let pId = parentId,
            let pNode = sceneView.scene.rootNode.childNode(withName: pId, recursively: true) {
            pNode.addChildNode(node)
        } else {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func removeFromParentNode(id:String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: id, recursively: true)
            else { return }
        node.removeFromParentNode()
    }
    
    func setChildNodeProp(id:String, name: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: id, recursively: true)
            else { return }
        node.setProp(name: name, value: value)
    }
    
    func setLightProp(nodeId:String, name: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeId, recursively: true),
        let light = node.light
            else {
                return }
        light.setProp(name: name, value: value)
    }
    
    func setMaterialProp(id:String, nodeId:String, name: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeId, recursively: true)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setProp(name: name, value: value)
        }
    }
    
    func setMaterialPropertyProp(id:String, nodeId:String, type:String, name: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeId, recursively: true)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setMaterialPropertyProp(type: type, name: name, value: value)
        }
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard planeDetection else {
            return
        }
        if anchor is ARPlaneAnchor {
            node.name = UUID().uuidString
            let planeAnchor = anchor as! ARPlaneAnchor
            var props = [String: Any]()
            props["anchor"] = [
                "alignment":0,
                "id":planeAnchor.identifier.uuidString,
                "center":["x":planeAnchor.center.x,"y":planeAnchor.center.y,"z":planeAnchor.center.z],
                "extent":["x":planeAnchor.extent.x,"y":planeAnchor.extent.y,"z":planeAnchor.extent.z],
                "transform":planeAnchor.transformAsArray
            ]
            props["node"] = ["id":node.name]
            let json = JSON(props)
            sendEvent(name: AREvent.ON_PLANE_DETECTED, value: json.description)
        } else {
            return
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

