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
/** Reasons for geo tracking failure states. */
internal final class GeoTrackingStateReason {
    /** No issues reported. */
    public static const none:uint = 0;
    /** Geo tracking is not available at the location. */
    public static const notAvailableAtLocation:uint = 1;
    /** Geo tracking needs location permissions from the user. */
    public static const needLocationPermissions:uint = 2;
    /** World tracking pose is not valid yet. */
    public static const worldTrackingUnstable:uint = 3;
    /** Waiting for a location point that meets accuracy threshold before starting geo tracking. */
    public static const waitingForLocation:uint = 4;
    /** Waiting for availability check on first location point to complete. */
    public static const waitingForAvailabilityCheck:uint = 5;
    /** Geo tracking data hasn't been downloaded yet. */
    public static const geoDataNotLoaded:uint = 6;
    /** The device is pointed at an angle too far down to use geo tracking. */
    public static const devicePointedTooLow:uint = 7;
    /** Visual localization failed, but no errors were found in the input. */
    public static const visualLocalizationFailed:uint = 8;
}
}


