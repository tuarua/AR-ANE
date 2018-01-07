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
import FreSwift

public extension UIColor {
    func toFREObjectARGB() -> FREObject? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            var colorAsUInt : UInt32 = 0
            colorAsUInt += UInt32(alpha * 255.0) << 24
                + UInt32(red * 255.0) << 16
                + UInt32(green * 255.0) << 8
                + UInt32(blue * 255.0)
            return UInt.init(colorAsUInt).toFREObject()
        }
        return nil
    }
    func toFREObject() -> FREObject? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            var colorAsUInt : UInt32 = 0
            colorAsUInt += UInt32(red * 255.0) << 16
                + UInt32(green * 255.0) << 8
                + UInt32(blue * 255.0)
            return UInt.init(colorAsUInt).toFREObject()
        }
        return nil
    }
}
