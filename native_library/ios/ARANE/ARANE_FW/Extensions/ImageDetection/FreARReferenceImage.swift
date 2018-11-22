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

@available(iOS 11.3, *)
public extension ARReferenceImage {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let bmd = rv["bitmapData"],
            let physicalWidth = CGFloat(rv["physicalWidth"]),
            let o = UInt(rv["orientation"]),
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(o))
            else { return nil }
        
        var sourceImage: CGImage?
        let asBitmapData = FreBitmapDataSwift(freObject: bmd)
        defer {
            asBitmapData.releaseData()
        }
        if let cgimg = asBitmapData.asCGImage() {
            sourceImage = cgimg
        }
        
        if let si = sourceImage {
            self.init(si, orientation: orientation, physicalWidth: physicalWidth)
            self.name = String(rv["name"])
        } else {
            return nil
        }
        
    }
}

@available(iOS 11.3, *)
public extension Set where Element == ARReferenceImage {
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let groupName = String(rv["groupName"]),
            let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: groupName, bundle: nil) {
            self.formUnion(referenceImages)
        }
    }
}
