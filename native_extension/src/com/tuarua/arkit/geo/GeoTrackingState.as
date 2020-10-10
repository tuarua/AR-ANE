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

 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */
// Mark as internal
// only 5 US cities are currently supported: San Francisco Bay Area, Los Angeles, New York, Chicago, Miami
// Will need a resident of these cities to complete this development
package com.tuarua.arkit.geo {
/** A value describing geo tracking state. */
internal final class GeoTrackingState {
    /** Geo tracking is not available. */
    public static const notAvailable:uint = 0;
    /** Geo tracking is being initialized. */
    public static const initializing:uint = 1;
    /** Geo tracking is attempting to localize against a Map. */
    public static const localizing:uint = 2;
    /** Geo tracking is localized. */
    public static const localized:uint = 3;
}
}
