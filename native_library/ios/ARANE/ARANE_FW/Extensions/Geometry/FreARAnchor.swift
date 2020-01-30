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
            let rd = rv["transform"],
            let matrix = SCNMatrix4(rd)
            else { return nil }
        self.init(transform: matrix_float4x4(matrix))
    }
    
    var transformAsArray: [Float] {
        let cols = self.transform.columns
        let ret: [Float] = [cols.0.x, cols.0.y, cols.0.z, cols.0.w,
                                cols.1.x, cols.1.y, cols.1.z, cols.1.w,
                                cols.2.x, cols.2.y, cols.2.z, cols.2.w,
                                cols.3.x, cols.3.y, cols.3.z, cols.3.w]
        return ret
    }
    
    @objc func toFREObject() -> FREObject? {
        var _sessionIdentifier: String?
        if #available(iOS 13.0, *) {
            _sessionIdentifier = sessionIdentifier?.uuidString
        }
        return FREObject(className: "com.tuarua.arane.Anchor", args: identifier.uuidString,
                         _sessionIdentifier, transform.toFREObject())
    }

}
