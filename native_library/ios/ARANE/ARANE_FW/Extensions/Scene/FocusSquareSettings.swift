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
 */

import UIKit
import FreSwift

class FocusSquareSettings {
    var primaryColor: UIColor
    var fillColor: UIColor
    var enabled: Bool
    init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let primaryColor = UIColor(freObjectARGB: rv["primaryColor"]),
            let fillColor = UIColor(freObjectARGB: rv["fillColor"]),
            let enabled = Bool(rv["enabled"])
            else { return nil }
        self.primaryColor = primaryColor
        self.fillColor = fillColor
        self.enabled = enabled
    }
}
