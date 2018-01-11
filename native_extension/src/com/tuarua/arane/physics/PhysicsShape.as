package com.tuarua.arane.physics {
import com.tuarua.arane.shapes.Geometry;
[RemoteClass(alias="com.tuarua.arane.physics.PhysicsShape")]
public class PhysicsShape {
    private var _geometry:*;
    private var _options:Array = [];

    public function PhysicsShape(geometry:*, options:Array = null) {
        this._geometry = geometry;
        if (options && options.length > 0) {
            this._options = options;
        }
    }


    public function get geometry():* {
        return _geometry;
    }

    public function get options():Array {
        return _options;
    }
}
}
