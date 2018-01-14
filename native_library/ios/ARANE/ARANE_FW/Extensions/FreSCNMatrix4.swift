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

public extension SCNMatrix4 {
    init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let rd:FREObject = rv["rawData"]
            else { return nil }
        let freArray = FREArray.init(rd)
        
        guard freArray.length == 16,
            let m11 = Float(freArray[0]),
            let m12 = Float(freArray[1]),
            let m13 = Float(freArray[2]),
            let m14 = Float(freArray[3]),
            let m21 = Float(freArray[4]),
            let m22 = Float(freArray[5]),
            let m23 = Float(freArray[6]),
            let m24 = Float(freArray[7]),
            let m31 = Float(freArray[8]),
            let m32 = Float(freArray[9]),
            let m33 = Float(freArray[10]),
            let m34 = Float(freArray[11]),
            let m41 = Float(freArray[12]),
            let m42 = Float(freArray[13]),
            let m43 = Float(freArray[14]),
            let m44 = Float(freArray[15])
            else {
                return nil
        }
        self.init(m11: m11, m12: m12, m13: m13, m14: m14,
                  m21: m21, m22: m22, m23: m23, m24: m24,
                  m31: m31, m32: m32, m33: m33, m34: m34,
                  m41: m41, m42: m42, m43: m43, m44: m44)
        
    }
    func toFREObject() -> FREObject? {
        do {
            let dblArr:Array<Double> = [Double(self.m11), Double(self.m12), Double(self.m13), Double(self.m14),
                                        Double(self.m21), Double(self.m22), Double(self.m23), Double(self.m24),
                                        Double(self.m31), Double(self.m32), Double(self.m33), Double(self.m34),
                                        Double(self.m41), Double(self.m42), Double(self.m43), Double(self.m44)]

            let freArgs = try FREArray.init(className: "Vector.<Number>", args: dblArr.count)
            var indx:UInt = 0
            for v in dblArr {
                try freArgs.set(index: indx, value: v)
                indx = indx + 1
            }
            return try FREObject(className: "flash.geom.Matrix3D", args: freArgs.rawValue)
        } catch {
        }
        return nil
    }
}

public extension matrix_float4x4 {
    func toFREObject() -> FREObject? {
        do {
            let dblArr:Array<Double> = [Double(self.columns.0.x), Double(self.columns.0.y),
                                        Double(self.columns.0.z), Double(self.columns.0.w),
                                        Double(self.columns.1.x), Double(self.columns.1.y),
                                        Double(self.columns.1.z), Double(self.columns.1.w),
                                        Double(self.columns.2.x), Double(self.columns.2.y),
                                        Double(self.columns.2.z), Double(self.columns.2.w),
                                        Double(self.columns.3.x), Double(self.columns.3.y),
                                        Double(self.columns.3.z), Double(self.columns.3.w)]
            
            let freArgs = try FREArray.init(className: "Vector.<Number>", args: dblArr.count)
            var indx:UInt = 0
            for v in dblArr {
                try freArgs.set(index: indx, value: v)
                indx = indx + 1
            }
            return try FREObject(className: "flash.geom.Matrix3D", args: freArgs.rawValue)
        } catch {
        }
        return nil
    }
}
