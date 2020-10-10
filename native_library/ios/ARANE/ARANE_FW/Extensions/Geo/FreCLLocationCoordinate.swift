/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation
import FreSwift
import SwiftyJSON
import ARKit

public extension CLLocationCoordinate2D {
    init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let lat = CLLocationDegrees(rv["latitude"]),
            let lng = CLLocationDegrees(rv["longitude"])
            else {
                return nil
        }
        self.init(latitude: lat, longitude: lng)
    }
    func toFREObject() -> FREObject? {
        return FREObject(className: "com.tuarua.arkit.geo.Coordinate", args: Double(latitude), Double(longitude))
    }
    func toJSON() -> String {
        var props = [String: Any]()
        props["latitude"] = self.latitude
        props["longitude"] = self.longitude
        return JSON(props).description
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> CLLocationCoordinate2D? {
        get { return CLLocationCoordinate2D(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    subscript(dynamicMember name: String) -> CLLocationCoordinate2D {
        get { return CLLocationCoordinate2D(rawValue?[name]) ?? CLLocationCoordinate2D() }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    subscript(dynamicMember name: String) -> [CLLocationCoordinate2D] {
        return [CLLocationCoordinate2D](rawValue?[name]) ?? []
    }
}

public extension Array where Element == CLLocationCoordinate2D {
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        var ret = [CLLocationCoordinate2D]()
        let array = FREArray(rv)
        for item in array {
            if let v = CLLocationCoordinate2D(item) {
                ret.append(v)
            }
        }
        self = ret
    }
}
