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

public extension FREObject {
    public var value: Any? {
        get {
            if let ret = FreObjectSwift.init(freObject: self).value {
                return ret
            }
            return nil
        }
    }
    
    subscript(_ name: String) -> FREObject? {
        get {
            do {
                let ret = try self.getProp(name: name)
                return ret
            } catch{}
            return nil
        }
        set(newValue) {
            do {
                try self.setProp(name: name, value: newValue)
            } catch{}
        }
    }
}

public extension FREArray {
    subscript(index: UInt) -> FREObject? {
        get {
            do{
                return try self.at(index: index)
            }catch{}
            return nil
        }
    }
}

public extension UIColor {
    convenience init(freObjectARGB: FREObject?) {
        guard let rv = freObjectARGB else {
            self.init()
            return
        }
        if let fli = CGFloat.init(rv) {
            let rgb = Int.init(fli)
            let a = (rgb >> 24) & 0xFF
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            let aFl: CGFloat = CGFloat.init(a) / 255
            let rFl: CGFloat = CGFloat.init(r) / 255
            let gFl: CGFloat = CGFloat.init(g) / 255
            let bFl: CGFloat = CGFloat.init(b) / 255
            self.init(red: rFl, green: gFl, blue: bFl, alpha: aFl)
        } else {
            self.init()
        }
    }
}
