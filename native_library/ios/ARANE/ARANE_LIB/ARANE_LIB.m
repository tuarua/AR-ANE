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

#import "FreMacros.h"
#import "ARANE_LIB.h"
#import <ARANE_FW/ARANE_FW.h>

#define FRE_OBJC_BRIDGE TRAKA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation ARANE_LIB
SWIFT_DECL(TRAKA) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(TRAKA) {
    SWIFT_INITS(TRAKA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRAKA, init)
        ,MAP_FUNCTION(TRAKA, initScene3D)
        ,MAP_FUNCTION(TRAKA, disposeScene3D)
        ,MAP_FUNCTION(TRAKA, setScene3DProp)
        ,MAP_FUNCTION(TRAKA, appendToLog)
        ,MAP_FUNCTION(TRAKA, displayLogging)
        ,MAP_FUNCTION(TRAKA, setDebugOptions)
        ,MAP_FUNCTION(TRAKA, runSession)
        ,MAP_FUNCTION(TRAKA, pauseSession)
        ,MAP_FUNCTION(TRAKA, addChildNode)
        ,MAP_FUNCTION(TRAKA, setChildNodeProp)
        ,MAP_FUNCTION(TRAKA, removeFromParentNode)
        ,MAP_FUNCTION(TRAKA, setGeometryProp)
        ,MAP_FUNCTION(TRAKA, setMaterialProp)
        ,MAP_FUNCTION(TRAKA, setMaterialPropertyProp)
        ,MAP_FUNCTION(TRAKA, addNativeChild)
        ,MAP_FUNCTION(TRAKA, updateNativeChild)
 
    };
    

    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRAKA) {
    //any clean up code here
}
EXTENSION_INIT(TRAKA)
EXTENSION_FIN(TRAKA)
@end
