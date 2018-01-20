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
public extension SCNVector3 {
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        var x: Float = Float(0)
        var y: Float = Float(0)
        var z: Float = Float(0)
        if let xVal = Float(rv["x"]) {
            x = xVal
        }
        if let yVal = Float(rv["y"]) {
            y = yVal
        }
        if let zVal = Float(rv["z"]) {
            z = zVal
        }
        self.init(x, y, z)
    }
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "flash.geom.Vector3D",
                                    args: Double.init(self.x), Double.init(self.y), Double.init(self.z))
            return ret
        } catch {
        }
        return nil
    }
}
