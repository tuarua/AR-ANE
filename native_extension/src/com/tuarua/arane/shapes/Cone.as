// Copyright 2017 Tua Rua Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Additional Terms
//  No part, or derivative of this Air Native Extensions's code is permitted
//  to be sold as the basis of a commercially packaged Air Native Extension which
//  undertakes the same purpose as this software. That is an ARKit ANE for iOS.
//  All Rights Reserved. Tua Rua Ltd.

package com.tuarua.arane.shapes {
public class Cone extends Geometry {
    public var topRadius:Number;
    public var bottomRadius:Number;
    public var height:Number;
    public var radialSegmentCount:int = 48;
    public var heightSegmentCount:int = 1;

    public function Cone(topRadius:Number = 0, bottomRadius:Number = 0.5, height:Number = 1) {
        super();
        this.topRadius = topRadius;
        this.bottomRadius = bottomRadius;
        this.height = height;
    }
}
}
