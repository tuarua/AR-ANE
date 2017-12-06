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

package com.tuarua.arane {
public class DebugOptions {
    public var showFeaturePoints:Boolean;
    public var showWorldOrigin:Boolean;
    public var showConstraints:Boolean;
    public var showLightExtents:Boolean;
    public var showPhysicsShapes:Boolean;
    public var showBoundingBoxes:Boolean;
    public var showLightInfluences:Boolean;
    public var showPhysicsFields:Boolean;
    public var showWireframe:Boolean;
    public var renderAsWireframe:Boolean;
    public var showSkeletons:Boolean;
    public var showCreases:Boolean;
    public var showCameras:Boolean;

    //aka ARSCNDebugOptions
    public function DebugOptions(showFeaturePoints:Boolean = false, showWorldOrigin:Boolean = false,
                                 showConstraints:Boolean = false, showLightExtents:Boolean = false,
                                 showPhysicsShapes:Boolean = false, showBoundingBoxes:Boolean = false,
                                 showLightInfluences:Boolean = false, showPhysicsFields:Boolean = false,
                                 showWireframe:Boolean = false, renderAsWireframe:Boolean = false,
                                 showSkeletons:Boolean = false, showCreases:Boolean = false,
                                 showCameras:Boolean = false) {
        this.showFeaturePoints = showFeaturePoints;
        this.showWorldOrigin = showWorldOrigin;
        this.showConstraints = showConstraints;
        this.showLightExtents = showLightExtents;
        this.showPhysicsShapes = showPhysicsShapes;
        this.showBoundingBoxes = showBoundingBoxes;
        this.showLightInfluences = showLightInfluences;
        this.showPhysicsFields = showPhysicsFields;
        this.showWireframe = showWireframe;
        this.renderAsWireframe = renderAsWireframe;
        this.showSkeletons = showSkeletons;
        this.showCreases = showCreases;
        this.showCameras = showCameras;

    }
}
}

/*


    public static var showLightInfluences: SCNDebugOptions { get } //show objects's light influences

    public static var showPhysicsFields: SCNDebugOptions { get } //show SCNPhysicsFields forces and extents

    public static var showWireframe: SCNDebugOptions { get } //show wireframe on top of objects

    @available(iOS 11.0, *)
    public static var renderAsWireframe: SCNDebugOptions { get } //render objects as wireframe

    @available(iOS 11.0, *)
    public static var showSkeletons: SCNDebugOptions { get } //show skinning bones

    @available(iOS 11.0, *)
    public static var showCreases: SCNDebugOptions { get } //show subdivision creases

    @available(iOS 11.0, *)
    public static var showCameras: SCNDebugOptions { get } //show cameras
 */
