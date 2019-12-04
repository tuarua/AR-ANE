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

import Foundation
import ARKit
import SwiftyJSON

extension Scene3DVC: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard focusSquareEnabled else {
            return
        }
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
        //        guard let estimate = self.sceneView.session.currentFrame?.lightEstimate else {
        //            return
        //        }
        //        // A value of 1000 is considered neutral, lighting environment intensity normalizes
        //        // 1.0 to neutral so we need to scale the ambientIntensity value
        //        let intensity = estimate.ambientIntensity / 1000.0
        //        self.sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if listeners.contains(AREvent.ON_PLANE_DETECTED), hasPlaneDetection,
            let planeAnchor = anchor as? ARPlaneAnchor {
            planeAnchors[planeAnchor.identifier.uuidString] = planeAnchor
            node.name = UUID().uuidString
            var props = [String: Any]()
            var dict: [String: Any] = [
                "alignment": planeAnchor.alignment.rawValue,
                "id": planeAnchor.identifier.uuidString,
                "center": ["x": planeAnchor.center.x, "y": planeAnchor.center.y, "z": planeAnchor.center.z],
                "extent": ["x": planeAnchor.extent.x, "y": planeAnchor.extent.y, "z": planeAnchor.extent.z],
                "transform": planeAnchor.transformAsArray
            ]
            if #available(iOS 13.0, *) {
                dict["sessionId"] = planeAnchor.sessionIdentifier?.uuidString
            } else {
                dict["sessionId"] = nil
            }
            props["anchor"] = dict
            props["node"] = ["id": node.name]
            dispatchEvent(name: AREvent.ON_PLANE_DETECTED, value: JSON(props).description)
        }
        
        if #available(iOS 11.3, *) {
            if listeners.contains(AREvent.ON_IMAGE_DETECTED),
                let imageAnchor = anchor as? ARImageAnchor {
                let referenceImage = imageAnchor.referenceImage
                var props = [String: Any]()
                var dict: [String: Any] = [
                    "id": imageAnchor.identifier.uuidString,
                    "name": referenceImage.name ?? "",
                    "width": referenceImage.physicalSize.width,
                    "height": referenceImage.physicalSize.height,
                    "transform": imageAnchor.transformAsArray
                ]
                if #available(iOS 13.0, *) {
                    dict["sessionId"] = imageAnchor.sessionIdentifier?.uuidString
                    dict["estimatedScaleFactor"] = imageAnchor.estimatedScaleFactor
                } else {
                    dict["sessionId"] = nil
                    dict["estimatedScaleFactor"] = -1.0
                }
                props["anchor"] = dict
                node.name = UUID().uuidString
                props["node"] = ["id": node.name]
                dispatchEvent(name: AREvent.ON_IMAGE_DETECTED, value: JSON(props).description)
            }
        }
        if #available(iOS 12.0, *) {
            if listeners.contains(AREvent.ON_OBJECT_DETECTED),
                let objectAnchor = anchor as? ARObjectAnchor {
                let referenceObject = objectAnchor.referenceObject
                var props = [String: Any]()
                var dict: [String: Any] = [
                    "id": objectAnchor.identifier.uuidString,
                    "transform": objectAnchor.transformAsArray,
                    "referenceObject": [
                        "name": referenceObject.name ?? "",
                        "center": ["x": referenceObject.center.x,
                                   "y": referenceObject.center.y,
                                   "z": referenceObject.center.z],
                        "extent": ["x": referenceObject.extent.x,
                                   "y": referenceObject.extent.y,
                                   "z": referenceObject.extent.z],
                        "scale": ["x": referenceObject.scale.x,
                                  "y": referenceObject.scale.y,
                                  "z": referenceObject.scale.z]
                    ]
                ]
                if #available(iOS 13.0, *) {
                    dict["sessionId"] = objectAnchor.sessionIdentifier?.uuidString
                } else {
                    dict["sessionId"] = nil
                }
                props["anchor"] = dict
                node.name = UUID().uuidString
                props["node"] = ["id": node.name]
                dispatchEvent(name: AREvent.ON_OBJECT_DETECTED, value: JSON(props).description)
            }
        }
        if #available(iOS 13.0, *) {
            if listeners.contains(AREvent.ON_BODY_DETECTED),
            let bodyAnchor = anchor as? ARBodyAnchor {
                var props = [String: Any]()
                
                let dict: [String: Any?] = [
                    "id": bodyAnchor.identifier.uuidString,
                    "transform": bodyAnchor.transformAsArray,
                    "estimatedScaleFactor": bodyAnchor.estimatedScaleFactor,
                    "sessionId": bodyAnchor.sessionIdentifier?.uuidString,
                    "skeleton": ["jointModelTransforms": bodyAnchor.skeleton.jointLocalTransformsAsArray,
                                 "jointModelTransforms": bodyAnchor.skeleton.jointModelTransformsAsArray]
                ]
                props["anchor"] = dict
                node.name = UUID().uuidString
                props["node"] = ["id": node.name]
                dispatchEvent(name: AREvent.ON_BODY_DETECTED, value: JSON(props).description)
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if listeners.contains(AREvent.ON_PLANE_UPDATED), let planeAnchor = anchor as? ARPlaneAnchor {
            var props = [String: Any]()
            var dict: [String: Any] = [
                "alignment": planeAnchor.alignment.rawValue,
                "id": planeAnchor.identifier.uuidString,
                "center": ["x": planeAnchor.center.x, "y": planeAnchor.center.y, "z": planeAnchor.center.z],
                "extent": ["x": planeAnchor.extent.x, "y": planeAnchor.extent.y, "z": planeAnchor.extent.z],
                "transform": planeAnchor.transformAsArray
            ]
            if #available(iOS 13.0, *) {
                dict["sessionId"] = planeAnchor.sessionIdentifier?.uuidString
            } else {
                dict["sessionId"] = nil
            }
            props["anchor"] = dict
            props["nodeName"] = node.name
            dispatchEvent(name: AREvent.ON_PLANE_UPDATED, value: JSON(props).description)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if listeners.contains(AREvent.ON_PLANE_REMOVED), let planeAnchor = anchor as? ARPlaneAnchor {
            var props = [String: Any]()
            props["nodeName"] = node.name
            planeAnchors.removeValue(forKey: planeAnchor.identifier.uuidString)
            dispatchEvent(name: AREvent.ON_PLANE_REMOVED, value: JSON(props).description)
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        guard listeners.contains(AREvent.ON_CAMERA_TRACKING_STATE_CHANGE)
            else { return }
        var props = [String: Any]()
        switch camera.trackingState {
        case .notAvailable:
            props["state"] = 0
            props["reason"] = -1
        case .normal:
            props["state"] = 1
            props["reason"] = -1
        case .limited(let reason):
            props["state"] = 2
            switch reason {
            case .initializing:
                props["reason"] = 0
            case .excessiveMotion:
                props["reason"] = 1
            case .insufficientFeatures:
                props["reason"] = 2
            case .relocalizing:
                props["reason"] = 3
            @unknown default:
                props["reason"] = 0
            }
        }
        dispatchEvent(name: AREvent.ON_CAMERA_TRACKING_STATE_CHANGE, value: JSON(props).description)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        var props = [String: Any]()
        props["error"] = error.localizedDescription
        let json = JSON(props)
        dispatchEvent(name: AREvent.ON_SESSION_ERROR, value: json.description)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        var props = [String: Any]()
        props["error"] = ""
        dispatchEvent(name: AREvent.ON_SESSION_INTERRUPTED, value: JSON(props).description)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        var props = [String: Any]()
        props["error"] = ""
        dispatchEvent(name: AREvent.ON_SESSION_INTERRUPTION_ENDED, value: JSON(props).description)
    }
}
