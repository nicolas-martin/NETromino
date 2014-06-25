//
//  GameMenu.swift
//  TClone
//
//  Created by nma on 2014-06-08.
//
//

class GameMenu : CCNode{
    
    class func scene() -> CCScene{

        let scene = CCScene()
        let GameMenuLayer = GameMenu()
        
        scene.addChild(GameMenuLayer)
        
        return scene

    }

    init(){
        super.init()
        /*
        let mySelector: Selector = "onPlayPressed"

        var PlayButton = CCMenuItemImage(normalImage: "play.png", selectedImage: "playPressed.png", disabledImage: "play.png", target: self, selector: mySelector)
        //var MusicOn = CCMenuItemImage(normalImage: "musicOn.png", selectedImage: "musicOnPressed.png", disabledImage: "musicOn.png", target: nil, selector: nil)
        
        var MenuItems = CCMenuItem[]()
        MenuItems.append(PlayButton)
        
        var winSize = CCDirector.sharedDirector().winSize()

        
        var Menu = CCMenu(array: Array(MenuItems))
        Menu.position = CGPoint(x: winSize.width * 0.5,y: winSize.height * 0.4)
        Menu.alignItemsVerticallyWithPadding(15)
        
        self.addChild(Menu)*/
        
    }
    
    func onPlayPressed(){

        let GameLayer = GameLogicLayer.scene
        
        
        var sharedDirector = CCDirector.sharedDirector
        sharedDirector().replaceScene(GameLayer())
        
    }
    
    
}


