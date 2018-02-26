package com.tuarua.arane {
import com.tuarua.ARANEContext;

import flash.geom.Vector3D;

public class Camera {
    private var _name:String;
    private var _isDefault:Boolean = true;
    private var _wantsHDR:Boolean;
    private var _exposureOffset:Number = 0;
    private var _averageGray:Number = 0.18;
    private var _whitePoint:Number = 1;
    private var _minimumExposure:Number = -15.0;
    private var _maximumExposure:Number = 15.0;

    public function Camera(name:String = null) {
        this._name = name ? name : ARANEContext.context.call("createGUID") as String;
    }

    public function get position():Vector3D {
        return ARANEContext.context.call("getCameraPosition") as Vector3D;
    }

    public function get name():String {
        return _name;
    }
    public function set name(value:String):void {
        _name = value;
    }

    /** Determines if the receiver has a high dynamic range.
     * @default false. */
    public function get wantsHDR():Boolean {
        return _wantsHDR;
    }
    public function set wantsHDR(value:Boolean):void {
        _isDefault = false;
        _wantsHDR = value;
    }

    /** Determines the logarithimc exposure biasing, in EV.
     * @default 0. */
    public function get exposureOffset():Number {
        return _exposureOffset;
    }
    public function set exposureOffset(value:Number):void {
        _isDefault = false;
        _exposureOffset = value;
    }

    /** Determines the average gray level desired in the final image.
     * @default 0.18 */
    public function get averageGray():Number {
        return _averageGray;
    }
    public function set averageGray(value:Number):void {
        _isDefault = false;
        _averageGray = value;
    }

    /** Determines the smallest luminance level that will be mapped to white in the final image.
     * @default 1 */
    public function get whitePoint():Number {
        return _whitePoint;
    }
    public function set whitePoint(value:Number):void {
        _isDefault = false;
        _whitePoint = value;
    }

    /** Determines the maximum exposure offset of the adaptation, in EV.
     * @default -15 */
    public function get maximumExposure():Number {
        return _maximumExposure;
    }
    public function set maximumExposure(value:Number):void {
        _isDefault = false;
        _maximumExposure = value;
    }

    /** Determines the minimum exposure offset of the adaptation, in EV.
     * @default -15 */
    public function get minimumExposure():Number {
        return _minimumExposure;
    }
    public function set minimumExposure(value:Number):void {
        _minimumExposure = value;
    }

    public function get isDefault():Boolean {
        return _isDefault;
    }


}
}
