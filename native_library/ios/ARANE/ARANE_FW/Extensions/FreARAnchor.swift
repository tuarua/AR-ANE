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

public extension ARAnchor {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let rd:FREObject = rv["transform"],
            let matrix = SCNMatrix4.init(rd)
            else { return nil }
        self.init(transform: matrix_float4x4.init(matrix))
    }
    
    var transformAsArray: Array<Float> {
        get {
            var ret = Array<Float>()
            let cols = self.transform.columns
            ret.append(cols.0.x)
            ret.append(cols.0.y)
            ret.append(cols.0.z)
            ret.append(cols.0.w)
            ret.append(cols.1.x)
            ret.append(cols.1.y)
            ret.append(cols.1.z)
            ret.append(cols.1.w)
            ret.append(cols.2.x)
            ret.append(cols.2.y)
            ret.append(cols.2.z)
            ret.append(cols.2.w)
            ret.append(cols.3.x)
            ret.append(cols.3.y)
            ret.append(cols.3.z)
            ret.append(cols.3.w)
            return ret
        }
    }
    
    
}
