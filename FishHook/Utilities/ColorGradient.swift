//
//  ColorGradient.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

@IBDesignable
class ColorGradient: UIView {
    
    // Calling the update function when first color is set.
    @IBInspectable var First: UIColor = UIColor.clear {
        didSet{
            update()
        }
    }
    
    // Calling the update function when the second color is set.
    @IBInspectable var Second: UIColor = UIColor.clear {
        didSet {
            update()
        }
    }
    
    // Overriding to return Gradient layer.
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func update(){
        // Converting the layer to a CAGradientLayer
        let layer = self.layer as! CAGradientLayer
        
        // Setting the layers colors converting those to Core Graphic Colors.
        layer.colors = [First.cgColor, Second.cgColor]
    }
}
