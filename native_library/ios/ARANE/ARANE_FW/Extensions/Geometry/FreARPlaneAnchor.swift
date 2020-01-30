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

public extension ARPlaneAnchor {
    @objc override func toFREObject() -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arane.PlaneAnchor",
                                       args: identifier.uuidString,
                                       transform.toFREObject()) else {
            return nil
        }
        fre.alignment = alignment.rawValue
        fre.center = center
        fre.extent = extent
        
        if #available(iOS 12.0, *) {
            switch self.classification {
            case .none:
                fre.classification = 0
            case .wall:
                fre.classification = 1
            case .floor:
                fre.classification = 2
            case .ceiling:
                fre.classification = 3
            case .table:
                fre.classification = 4
            case .seat:
                fre.classification = 5
            case .window:
                fre.classification = 6
            case .door:
                fre.classification = 7
            @unknown default:
                fre.classification = 0
            }
        }
        return fre.rawValue
    }
}
