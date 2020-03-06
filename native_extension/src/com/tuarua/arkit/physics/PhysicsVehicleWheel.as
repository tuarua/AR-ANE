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

package com.tuarua.arkit.physics {
import com.tuarua.arkit.Node;

import flash.geom.Vector3D;

internal class PhysicsVehicleWheel {
    private var _vehicleId:String;
    private var _node:Node;
    private var _suspensionStiffness:Number = 2.0;
    private var _suspensionCompression:Number = 4.4;
    private var _suspensionDamping:Number = 2.3;
    private var _maximumSuspensionTravel:Number = 500;
    private var _frictionSlip:Number = 1;
    private var _maximumSuspensionForce:Number = 6000;
    private var _connectionPosition:Vector3D;
    private var _steeringAxis:Vector3D = new Vector3D(0, -1, 0);
    private var _axle:Vector3D = new Vector3D(-1, 0, 0);
    private var _radius:Number;
    private var _suspensionRestLength:Number = 1.6;

    public function PhysicsVehicleWheel(node:Node) {
        this._node = node;
        _connectionPosition = node.position;
    }

    public function get node():Node {
        return _node;
    }

    /** The wheel suspension damping.
     * @default 2.3 */
    public function get suspensionDamping():Number {
        return _suspensionDamping;
    }

    public function set suspensionDamping(value:Number):void {
        _suspensionDamping = value;
    }

    /** The wheel suspension stiffness.
     * @default 2.0 */
    public function get suspensionStiffness():Number {
        return _suspensionStiffness;
    }

    public function set suspensionStiffness(value:Number):void {
        _suspensionStiffness = value;
    }

    /** The wheel suspension compression.
     * @default 4.4 */
    public function get suspensionCompression():Number {
        return _suspensionCompression;
    }

    public function set suspensionCompression(value:Number):void {
        _suspensionCompression = value;
    }

    /** The wheel maximum suspension travel in centimeters.
     * @default 500 */
    public function get maximumSuspensionTravel():Number {
        return _maximumSuspensionTravel;
    }

    public function set maximumSuspensionTravel(value:Number):void {
        _maximumSuspensionTravel = value;
    }

    /** The wheel friction slip coefficient.
     * @Default 1 */
    public function get frictionSlip():Number {
        return _frictionSlip;
    }

    public function set frictionSlip(value:Number):void {
        _frictionSlip = value;
    }

    /** The wheel maximum suspension force in newtons.
     * @Default to 6000.*/
    public function get maximumSuspensionForce():Number {
        return _maximumSuspensionForce;
    }

    public function set maximumSuspensionForce(value:Number):void {
        _maximumSuspensionForce = value;
    }

    /** The wheel connection point relative to the chassis. Defaults to the node position. */
    public function get connectionPosition():Vector3D {
        return _connectionPosition;
    }

    public function set connectionPosition(value:Vector3D):void {
        _connectionPosition = value;
    }

    /** The wheel steering axis in the vehicle chassis space. Defaults to (0,-1,0). */
    public function get steeringAxis():Vector3D {
        return _steeringAxis;
    }

    public function set steeringAxis(value:Vector3D):void {
        _steeringAxis = value;
    }

    /** The wheel axle in the vehicle chassis space. Defaults to (-1,0,0). */
    public function get axle():Vector3D {
        return _axle;
    }

    public function set axle(value:Vector3D):void {
        _axle = value;
    }

    /** The wheel radius. Defaults to the half of the max dimension of the bounding box of the node. */
    public function get radius():Number {
        return _radius;
    }

    public function set radius(value:Number):void {
        _radius = value;
    }

    /** The wheel suspension rest length.
     * @default to 1.6*/
    public function get suspensionRestLength():Number {
        return _suspensionRestLength;
    }

    public function set suspensionRestLength(value:Number):void {
        _suspensionRestLength = value;
    }

    /** @private*/
    public function get vehicleId():String {
        return _vehicleId;
    }

    /** @private*/
    public function set vehicleId(value:String):void {
        _vehicleId = value;
    }
}
}