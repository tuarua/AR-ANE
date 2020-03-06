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

public struct AREvent {
    public static let ON_PLANE_DETECTED = "ArKit.OnPlaneDetected"
    public static let ON_PLANE_UPDATED = "ArKit.OnPlaneUpdated"
    public static let ON_PLANE_REMOVED = "ArKit.OnPlaneRemoved"
    public static let ON_CAMERA_TRACKING_STATE_CHANGE = "ArKit.OnCameraTrackingStateChange"
    
    public static let ON_SESSION_ERROR = "ArKit.OnSessionError"
    public static let ON_SESSION_INTERRUPTED = "ArKit.OnSessionInterrupted"
    public static let ON_SESSION_INTERRUPTION_ENDED = "ArKit.OnSessionInterruptionEnded"
    
    public static let ON_IMAGE_DETECTED = "ArKit.OnImageDetected"
    
    public static let ON_CURRENT_WORLDMAP = "ArKit.OnCurrentWorldMap"
    public static let ON_REFERENCE_OBJECT = "ArKit.OnReferenceObject"
    public static let ON_OBJECT_DETECTED = "ArKit.OnObjectDetected"
    public static let ON_BODY_DETECTED = "ArKit.OnBodyDetected"
    
    public static let ON_TRACKED_RAYCAST = "ArKit.OnTrackedRaycast"
    
}
