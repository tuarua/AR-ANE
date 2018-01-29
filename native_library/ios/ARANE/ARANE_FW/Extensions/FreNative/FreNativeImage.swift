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
 */

import UIKit
import FreSwift

class FreNativeImage: UIImageView {
    private var _id: String = ""
    private var _x: CGFloat = 0
    public var x: CGFloat {
        set {
            _x = newValue
        }
        get {
            return _x
        }
    }
    
    private var _y: CGFloat = 0
    public var y: CGFloat {
        set {
            _y = newValue
        }
        get {
            return _y
        }
    }
    
    func update(prop: FREObject, value: FREObject) {
        guard let propName = String(prop)
            else {
                return
        }
        if propName == "x" {
            x = CGFloat(value) ?? 0.0
        } else if propName == "y" {
            y = CGFloat(value) ?? 0.0
        } else if propName == "alpha" {
            self.alpha = CGFloat(value) ?? 1.0
        } else if propName == "visible" {
            if let visible = Bool(value) {
                self.isHidden = !visible
            }
        }
        self.setNeedsDisplay()
    }
    
    init(freObject: FREObject, id: String) throws {
        guard let bmd = try freObject.getProp(name: "bitmapData"),
            let _x = CGFloat(freObject["x"]),
            let _y = CGFloat(freObject["y"]),
            let _visible = Bool(freObject["visible"])
            else {
                self._id = id
                super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                return
        }
        
        self._id = id
        var width = CGFloat()
        var height = CGFloat()
        var img: UIImage?
        
        let _alpha = CGFloat(freObject["alpha"]) ?? 1.0
        
        let asBitmapData = FreBitmapDataSwift.init(freObject: bmd)
        defer {
            asBitmapData.releaseData()
        }
        do {
            if let cgimg = try asBitmapData.asCGImage() {
                img = UIImage.init(cgImage: cgimg, scale: UIScreen.main.scale, orientation: .up)
                if let img = img {
                    width = img.size.width
                    height = img.size.width
                }
                
            }
        } catch {
        }
        super.init(image: img)
        self.frame = CGRect.init(x: _x, y: _y, width: width, height: height)
        x = _x
        y = _y
        alpha = _alpha
        isHidden = !_visible
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
