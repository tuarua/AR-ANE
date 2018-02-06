/* Copyright 2018 Tua Rua Ltd.
 
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
import AVFoundation

class PermissionController: FreSwiftController {
    var TAG: String? = "PermissionController"
    var context: FreContextSwift!
    private let requiredKey = ["NSCameraUsageDescription"]
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
    }
    
    func requestPermissions() {
        var pListDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            pListDict = NSDictionary(contentsOfFile: path)
        }
        var hasRequiredInfoAddition = false
        if let dict = pListDict {
            for key in dict.allKeys {
                if let k = key as? String, requiredKey.contains(k) {
                    hasRequiredInfoAddition = true
                    break
                }
            }
        }
        if hasRequiredInfoAddition {
            var props: [String: Any] = Dictionary()
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .restricted:
                props["status"] = PermissionEvent.RESTRICTED
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        props["status"] = PermissionEvent.ALLOWED
                    } else {
                        props["status"] = PermissionEvent.DENIED
                    }
                    let json = JSON(props)
                    self.sendEvent(name: PermissionEvent.ON_STATUS, value: json.description)
                    return
                }
            case .denied:
                props["status"] = PermissionEvent.DENIED
            case .authorized:
                props["status"] = PermissionEvent.ALLOWED
            }
            
            let json = JSON(props)
            sendEvent(name: PermissionEvent.ON_STATUS, value: json.description)
            
        } else {
            warning("Please add \(requiredKey.description) to InfoAdditions in your AIR manifest")
        }
        
    }
    
}
