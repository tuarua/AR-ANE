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

public extension SCNCamera {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        self.name = fre.name
        self.wantsHDR = fre.wantsHDR
        self.exposureOffset = fre.exposureOffset
        self.averageGray = fre.averageGray
        self.whitePoint = fre.whitePoint
        self.minimumExposure = fre.minimumExposure
        self.maximumExposure = fre.maximumExposure
    }
    
    func copy(from: SCNCamera) {
        self.name = from.name
        self.wantsHDR = from.wantsHDR
        self.exposureOffset = from.exposureOffset
        self.averageGray = from.averageGray
        self.whitePoint = from.whitePoint
        self.minimumExposure = from.minimumExposure
        self.maximumExposure = from.maximumExposure
    }
}
