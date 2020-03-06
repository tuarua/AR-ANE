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

public extension ARConfiguration {
    func retrieveWorldMapData(from url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
    @available(iOS 12.0, *)
    func unarchiveARWorldMap(worldMapData data: Data) -> ARWorldMap? {
        guard let unarchievedObject = ((try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self,
                                                                                from: data)) as ARWorldMap??),
            let worldMap = unarchievedObject else { return nil }
        return worldMap
    }
}
