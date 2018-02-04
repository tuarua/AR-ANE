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

extension Scene3DVC: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
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
        if listeners.contains(AREvent.ON_PLANE_DETECTED), planeDetection,
            let planeAnchor = anchor as? ARPlaneAnchor {
            node.name = UUID().uuidString
            var props = [String: Any]()
            props["anchor"] = [
                "alignment": 0,
                "id": planeAnchor.identifier.uuidString,
                "center": ["x": planeAnchor.center.x, "y": planeAnchor.center.y, "z": planeAnchor.center.z],
                "extent": ["x": planeAnchor.extent.x, "y": planeAnchor.extent.y, "z": planeAnchor.extent.z],
                "transform": planeAnchor.transformAsArray
            ]
            props["node"] = ["id": node.name]
            let json = JSON(props)
            sendEvent(name: AREvent.ON_PLANE_DETECTED, value: json.description)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if listeners.contains(AREvent.ON_PLANE_UPDATED), let planeAnchor = anchor as? ARPlaneAnchor {
            var props = [String: Any]()
            props["anchor"] = [
                "alignment": 0,
                "id": planeAnchor.identifier.uuidString,
                "center": ["x": planeAnchor.center.x, "y": planeAnchor.center.y, "z": planeAnchor.center.z],
                "extent": ["x": planeAnchor.extent.x, "y": planeAnchor.extent.y, "z": planeAnchor.extent.z],
                "transform": planeAnchor.transformAsArray
            ]
            props["nodeName"] = node.name
            let json = JSON(props)
            sendEvent(name: AREvent.ON_PLANE_UPDATED, value: json.description)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if listeners.contains(AREvent.ON_PLANE_REMOVED), let _ = anchor as? ARPlaneAnchor {
            var props = [String: Any]()
            props["nodeName"] = node.name
            let json = JSON(props)
            sendEvent(name: AREvent.ON_PLANE_REMOVED, value: json.description)
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
            }
        }
        let json = JSON(props)
        sendEvent(name: AREvent.ON_CAMERA_TRACKING_STATE_CHANGE, value: json.description)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        var props = [String: Any]()
        props["error"] = error.localizedDescription
        let json = JSON(props)
        sendEvent(name: AREvent.ON_SESSION_ERROR, value: json.description)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        var props = [String: Any]()
        props["error"] = ""
        let json = JSON(props)
        sendEvent(name: AREvent.ON_SESSION_INTERRUPTED, value: json.description)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        var props = [String: Any]()
        props["error"] = ""
        let json = JSON(props)
        sendEvent(name: AREvent.ON_SESSION_INTERRUPTION_ENDED, value: json.description)
    }
}
