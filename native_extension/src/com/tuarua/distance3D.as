package com.tuarua {
import flash.geom.Vector3D;

public function distance3D(vec1:Vector3D, vec2:Vector3D):Number {
    var distanceX:Number = vec1.x - vec2.x;
    var distanceY:Number = vec1.y - vec2.y;
    var distanceZ:Number = vec1.z - vec2.z;
    return Math.sqrt((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
}
}
