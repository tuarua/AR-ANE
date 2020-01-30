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

package com.tuarua.arane.physics {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

internal class PhysicsVehicle extends PhysicsBehavior {
    private var _id:String;
    private var _chassisBody:PhysicsBody;
    private var _wheels:Vector.<PhysicsVehicleWheel>;

    /** Initializes and returns a physics vehicle that applies on the physics body "chassisBody" with the given wheels.
     * A wheel can't be shared to multiple vehicle */
    public function PhysicsVehicle(chassisBody:PhysicsBody, wheels:Vector.<PhysicsVehicleWheel>) {
        trace("vehicle_create as3");
        this._chassisBody = chassisBody;
        this._wheels = wheels;
        _id = ARANEContext.context.call("vehicle_create", this) as String;
        for each (var wheel:PhysicsVehicleWheel in wheels) {
            wheel.vehicleId = _id;
        }
    }

    /** The chassis of the vehicle */
    public function get chassisBody():PhysicsBody {
        return _chassisBody;
    }

    /** The wheels of the vehicle */
    public function get wheels():Vector.<PhysicsVehicleWheel> {
        return _wheels;
    }

    /** The actual speed in kilometers per hour.*/
    public function get speedInKilometersPerHour():Number {
        return ARANEContext.context.call("vehicle_speedInKilometersPerHour", _id) as Number;
    }

    /** Applies a force on the wheel at the specified index */
    public function applyEngineForce(value:Number, forWheelAt:int):void {
        var ret:* = ARANEContext.context.call("vehicle_applyEngineForce", _id, value, forWheelAt);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Allows to control the direction of the wheel at the specified index. The steering value is expressed in radian, 0 means straight ahead. */
    public function setSteeringAngle(value:Number, forWheelAt:int):void {
        var ret:* = ARANEContext.context.call("vehicle_setSteeringAngle", _id, value, forWheelAt);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Applies a brake force on the wheel at the specified index. */
    public function applyBrakingForce(value:Number, forWheelAt:int):void {
        var ret:* = ARANEContext.context.call("vehicle_applyBrakingForce", _id, value, forWheelAt);
        if (ret is ANEError) throw ret as ANEError;
    }

}
}