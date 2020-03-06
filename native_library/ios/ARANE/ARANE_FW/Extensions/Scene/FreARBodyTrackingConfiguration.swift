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

@available(iOS 13.0, *)
public extension ARBodyTrackingConfiguration {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject, let planeDetection = [Int](rv["planeDetection"]) else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        isLightEstimationEnabled = fre.isLightEstimationEnabled
        worldAlignment = WorldAlignment(rawValue: fre.worldAlignment) ?? .gravity
        isAutoFocusEnabled = fre.isAutoFocusEnabled
        maximumNumberOfTrackedImages = fre.maximumNumberOfTrackedImages
        environmentTexturing = ARWorldTrackingConfiguration.EnvironmentTexturing(rawValue: fre.environmentTexturing)
            ?? .none
        
        if let freInitialWorldMapFile = rv["initialWorldMap"],
            let initialWorldMap = String(freInitialWorldMapFile["nativePath"]) {
            let worldMapURL = URL(fileURLWithPath: initialWorldMap)
            if let worldMapData = retrieveWorldMapData(from: worldMapURL),
                 let worldMap = unarchiveARWorldMap(worldMapData: worldMapData) {
                self.initialWorldMap = worldMap
            }
        }
        wantsHDREnvironmentTextures = fre.wantsHDREnvironmentTextures
        
        var planeDetectionSet: ARWorldTrackingConfiguration.PlaneDetection = []
        for pd in planeDetection {
            if UInt(pd) == ARWorldTrackingConfiguration.PlaneDetection.horizontal.rawValue {
                planeDetectionSet.formUnion(ARWorldTrackingConfiguration.PlaneDetection.horizontal)
            }
            if UInt(pd) == ARWorldTrackingConfiguration.PlaneDetection.vertical.rawValue {
                planeDetectionSet.formUnion(ARWorldTrackingConfiguration.PlaneDetection.vertical)
            }
        }
        
        self.planeDetection = planeDetectionSet
        if let referenceImages: Set<ARReferenceImage> = Set(fre.detectionImages) {
            detectionImages = referenceImages
        }
        automaticImageScaleEstimationEnabled = fre.automaticImageScaleEstimationEnabled
        automaticSkeletonScaleEstimationEnabled = fre.automaticSkeletonScaleEstimationEnabled
    }
}
