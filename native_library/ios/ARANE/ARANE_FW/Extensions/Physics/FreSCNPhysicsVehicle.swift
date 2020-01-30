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
// https://github.com/ctdewaters/WWDC18-Scholarship-Submission/blob/486ffee58e7ac1001ebab2c8c897d07dd68e16ef/CDeWatersWWDC18.playground/Sources/RaceCar/RaceCar.swift
// https://github.com/IJkeBotman/ARKit_Vehicle/blob/ca7f79edeb7bad70d62815f5b3079d824cc86ab0/ARKit_Vehicle/ViewController.swift
// https://github.com/darylphillip/iOS_portfolio/tree/39776bce96cf01a86ac1f5b5236ba6e068be782a/Vehicle/Vehicle
public extension SCNPhysicsVehicle {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let wheels = [SCNPhysicsVehicleWheel](rv["wheels"]),
            let chassisBody = SCNPhysicsBody(rv["chassisBody"])
            else {
                return nil
        }
        self.init(chassisBody: chassisBody, wheels: wheels)
    }
}
