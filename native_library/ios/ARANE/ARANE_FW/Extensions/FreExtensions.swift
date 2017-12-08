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
// http://derpturkey.com/get-property-names-of-object-in-swift/
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
    }
    
    subscript(_ name: String) -> Any? {
        get {
            do {
                let ret = try self.getProp(name: name)
                return FreObjectSwift.init(freObject: ret).value
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

public extension NSObject {
    public func setValue(freObject: FREObject?, forKey key: String) {
        guard let rv = freObject else {
            return
        }
        self.setValue(rv.value, forKey: key)
    }
}


