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
package com.tuarua.arane {
import flash.geom.Matrix3D;

[RemoteClass(alias="com.tuarua.arane.ObjectAnchor")]
public class ObjectAnchor extends Anchor {
    public var referenceObject:ReferenceObject = new ReferenceObject();

    public function ObjectAnchor(id:String, sessionId:String, transform:Matrix3D = null) {
        super(id, sessionId, transform);
    }

    public function equals(objectAnchor:ObjectAnchor):Boolean {
        return (objectAnchor.referenceObject.scale.equals(this.referenceObject.scale)
                && objectAnchor.referenceObject.extent.equals(this.referenceObject.extent)
                && objectAnchor.referenceObject.center.equals(this.referenceObject.center)
                && objectAnchor.referenceObject.name == referenceObject.name);
    }
}
}
