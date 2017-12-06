package com.tuarua.arane.materials {
public class MaterialProperty {
    public var contents:*; //color or image
    public var intensity:Number = 1.0;
    public var minificationFilter:int = FilterMode.LINEAR;
    public var magnificationFilter:int = FilterMode.LINEAR;
    public var mipFilter:int = FilterMode.NEAREST;
    public var wrapS:int = WrapMode.CLAMP;
    public var wrapT:int = WrapMode.CLAMP;
    public var mappingChannel:int = 0;
    public var maxAnisotropy:Number = 1.0;

}
}


/*



/!*!
 @property contentsTransform
 @abstract Determines the receiver's contents transform. Animatable.
 *!/
open var contentsTransform: SCNMatrix4




/!*!
 @property textureComponents
 @abstract Specifies the texture components to sample in the shader. Defaults to SCNColorMaskRed for displacement property, and to SCNColorMaskAll for other properties.
 @discussion Use this property to when using a texture that combine multiple informations in the different texture components. For example if you pack the roughness in red and metalness in blue etc... You can specify what component to use from the texture for this given material property. This property is only supported by Metal renderers.
 *!/
@available(iOS 11.0, *)
open var textureComponents: SCNColorMask
*/
