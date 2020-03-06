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

package com.tuarua.arkit.coaching {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

public class CoachingOverlayView {
    public var goal:int = CoachingOverlayViewGoal.tracking;
    private var _activatesAutomatically:Boolean = true;
    private var _isActive:Boolean;

    public function CoachingOverlayView(goal:int = CoachingOverlayViewGoal.tracking) {
        this.goal = goal;
        var ret:* = ARANEContext.context.call("coaching_create", goal);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get isActive():Boolean {
        return _isActive;
    }

    public function set activatesAutomatically(value:Boolean):void {
        _activatesAutomatically = value;
        var ret:* = ARANEContext.context.call("coaching_activatesAutomatically", _activatesAutomatically);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get activatesAutomatically():Boolean {
        return _activatesAutomatically;
    }

    public function setActive(active:Boolean, animated:Boolean):void {
        _isActive = active;
        var ret:* = ARANEContext.context.call("coaching_setActive", active, animated);
        if (ret is ANEError) throw ret as ANEError;
    }


}
}
