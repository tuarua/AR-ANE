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
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift.init(rv)
        guard let primaryColor: UIColor = fre.primaryColor,
        let fillColor: UIColor  = fre.fillColor else { return nil }
        self.primaryColor = primaryColor
        self.fillColor = fillColor
        self.enabled = fre.enabled
    }
}
