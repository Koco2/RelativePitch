//
//  GlobalFile.swift
//  RelativePitch
//
//  Created by Chen Wang on 2/9/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit

//storage
var defualts:UserDefaults!

//game progress
var score = 0
var bestScore = 0
var chance = 3
var gameOver = false


//Frame
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let keyWidth = (screenWidth+5)/7


//Color
let customRed = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1)
let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor

//Tag
let startTag = 200001

//function

public func restart(){
    score = 0
    chance = 3
    gameOver = false
}

public func whiteTransition(fromView:UIViewController, toView:UIViewController){
    let whiteScreen = UIView(frame: UIScreen.main.bounds)
    whiteScreen.backgroundColor = UIColor.white
    whiteScreen.layer.opacity = 0
    fromView.view.addSubview(whiteScreen)
    
    UIView.animate(withDuration: 0.5, animations: {
        whiteScreen.layer.opacity = 1
        
    }) { (bool) in
        fromView.navigationController?.pushViewController(toView, animated: false)
        whiteScreen.removeFromSuperview()
    }
}

public func whiteTransitionPop(fromView:UIViewController){
    let whiteScreen = UIView(frame: UIScreen.main.bounds)
    whiteScreen.backgroundColor = UIColor.white
    whiteScreen.layer.opacity = 0
    fromView.view.addSubview(whiteScreen)
    
    UIView.animate(withDuration: 0.5, animations: {
        whiteScreen.layer.opacity = 1
        
    }) { (bool) in
        fromView.navigationController?.popViewController(animated: false)
        whiteScreen.removeFromSuperview()
    }
}



public func appearFromWhite(view:UIViewController){
    let whiteScreen = UIView(frame: UIScreen.main.bounds)
    whiteScreen.backgroundColor = UIColor.white
    whiteScreen.layer.opacity = 1
    view.view.addSubview(whiteScreen)
    
    UIView.animate(withDuration: 0.5, animations: {
        whiteScreen.layer.opacity = 0
        
    }) { (bool) in
        whiteScreen.removeFromSuperview()
    }
}
