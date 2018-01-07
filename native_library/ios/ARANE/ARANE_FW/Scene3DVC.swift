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
    private var models: Dictionary<String, SCNNode> = Dictionary()
    private var tapGestureRecogniser:UITapGestureRecognizer?
    
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
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapAt(_:)))
        self.sceneView.addGestureRecognizer(tapGestureRecogniser!)

        self.view.frame = viewPort
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        
        // setupCamera()
        
    }
    
    @objc internal func didTapAt(_ recogniser: UITapGestureRecognizer) {
        trace("did Tap at")
        
    }
    
    func getModel(modelName:String) -> SCNNode? {
        return models[modelName]
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            trace("Expected a valid `pointOfView` from the scene.")
            return
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
        
        trace(camera.debugDescription)
        
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
        //sceneView.session.delegate = (self as! ARSessionDelegate)
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
    
    func addChildNode(parentName: String?, node: SCNNode) { //TODO isModel
        if let pId = parentName,
            let pNode = sceneView.scene.rootNode.childNode(withName: pId, recursively: true) {
            pNode.addChildNode(node)
        } else {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func removeFromParentNode(name:String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true)
            else { return }
        node.removeFromParentNode()
    }
    
    func setChildNodeProp(nodeName:String, propName: String, value: FREObject) {
//        if(isModel) {
//            if let node = models[nodeName] {
//                trace("setting setChildNodeProp \(propName) on \(nodeName)")
//                node.setProp(name: propName, value: value)
//                return
//            }
//            for model in models {
//                if let node = model.value.childNode(withName: nodeName, recursively: true) {
//                    trace("setting setChildNodeProp \(propName) on \(nodeName)")
//                    node.setProp(name: propName, value: value)
//                    return
//                }
//            }
//        }
        
        
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else {
                trace("setChildNodeProp early return")
                return }
        node.setProp(name: propName, value: value)
    }
    
    func getChildNode(parentName:String?, nodeName:String) -> SCNNode? {
        var parentNode:SCNNode?
        if parentName == "root" {
            
            parentNode = sceneView.scene.rootNode
        } else {
            if let pn = parentName {
                parentNode = sceneView.scene.rootNode.childNode(withName: pn, recursively: true)
            }
        }
        trace("searching", parentNode?.name ?? "unknown", "for", nodeName)
        return parentNode?.childNode(withName: nodeName, recursively: true)
    }
    
    func addModel(url: String, nodeName: String?) -> SCNNode? {
        if let scene = SCNScene.init(named: url) {
            //var node:SCNNode
            //trace("scene.debugDescription", scene.debugDescription)
            
            if let nodeName = nodeName,
                let node = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                //node = nde
                
                // print out full node details, including geometry mats etc
                trace("add model: \(nodeName)")
                trace("add model node: \(node.debugDescription)")
                //trace("model node.light: \(node.light)")
//                trace("model node.geometry?.materials.count: \(node.geometry?.materials.count)")
//                trace("model node.geometry.firstMaterial: \(node.geometry?.firstMaterial)")
//                trace("model node.geometry.firstMaterial.diffuse.contents: \(node.geometry?.firstMaterial?.diffuse.contents)")
                //trace("model node.childNodes.count: \(node.childNodes.count)")
                
                models[nodeName] = node
                return node
            }
//            else {
//                node = scene.rootNode.childNodes[0] //or just rootNode??
//                models["model_\(url)"] = node
//            }
            //trace("node.debugDescription", node.debugDescription)
            //return node
            //node.name
        }
        
        return nil
        
        //models
    }
    
    func setLightProp(nodeName:String, propName: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true),
        let light = node.light
            else {
                return }
        light.setProp(name: propName, value: value)
    }
    
    func setMaterialProp(id:String, nodeName:String, propName: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setProp(name: propName, value: value)
        }
    }
    
    func setMaterialPropertyProp(id:String, nodeName:String, type:String, propName: String, value: FREObject) {
        trace("setMaterialPropertyProp id: \(id) nodeName: \(nodeName) type: \(type) propName: \(propName)")
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else {
                trace("setMaterialPropertyProp early return")
                return
        }
        
        trace("node found", node.debugDescription)
        
        if let mat = node.geometry?.material(named: id) {
            trace("found material named \(id)")
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
            
        } else if let mat = node.geometry?.firstMaterial {
            trace("mat first material name", mat.name ?? "dunno")
            mat.name = id
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
            trace("can't find material with name", id)
            trace("how many materials does it have?", node.geometry?.materials.count ?? "dunno")
            // use firstMaterial ??
        }
    }
    
    func setGeometryProp(type:String, nodeName:String, propName:String, value:FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        
        switch type {
        case "box":
            trace("node: \(nodeName) - setting property \(propName) of box to \(value.value.debugDescription)")
            if let geom:SCNBox = node.geometry as? SCNBox {
                geom.setProp(name: propName, value: value)
            }
            break
        case "sphere":
            trace("node: \(nodeName) - setting property \(propName) of sphere to \(value.value.debugDescription)")
            if let geom:SCNSphere = node.geometry as? SCNSphere {
                geom.setProp(name: propName, value: value)
            }
            break
        case "capsule":
            trace("node: \(nodeName) - setting property \(propName) of capsule to \(value.value.debugDescription)")
            if let geom:SCNCapsule = node.geometry as? SCNCapsule {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cone":
            trace("node: \(nodeName) - setting property \(propName) of cone to \(value.value.debugDescription)")
            if let geom:SCNCone = node.geometry as? SCNCone {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cylinder":
            trace("node: \(nodeName) - setting property \(propName) of cylinder to \(value.value.debugDescription)")
            if let geom:SCNCylinder = node.geometry as? SCNCylinder {
                geom.setProp(name: propName, value: value)
            }
            break
        case "plane":
            trace("node: \(nodeName) - setting property \(propName) of plane to \(value.value.debugDescription)")
            if let geom:SCNPlane = node.geometry as? SCNPlane {
                geom.setProp(name: propName, value: value)
            }
            break
        case "pyramid":
            trace("node: \(nodeName) - setting property \(propName) of pyramid to \(value.value.debugDescription)")
            if let geom:SCNPyramid = node.geometry as? SCNPyramid {
                geom.setProp(name: propName, value: value)
            }
            break
        case "torus":
            trace("node: \(nodeName) - setting property \(propName) of torus to \(value.value.debugDescription)")
            if let geom:SCNTorus = node.geometry as? SCNTorus {
                geom.setProp(name: propName, value: value)
            }
            break
        case "tube":
            trace("node: \(nodeName) - setting property \(propName) of tube to \(value.value.debugDescription)")
            if let geom:SCNTube = node.geometry as? SCNTube {
                geom.setProp(name: propName, value: value)
            }
            break
        case "text":
            trace("node: \(nodeName) - setting property \(propName) of text to \(value.value.debugDescription)")
            if let geom:SCNText = node.geometry as? SCNText {
                geom.setProp(name: propName, value: value)
            }
            break
        case "geometry":
            trace("node: \(nodeName) - setting property \(propName) of geometry to \(value.value.debugDescription)")
            if let geom:SCNGeometry = node.geometry {
                geom.setModelProp(name: propName, value: value)
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

