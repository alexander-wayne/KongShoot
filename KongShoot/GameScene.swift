//
//  GameScene.swift
//  KongShoot
//
//  Created by Alex Wayne on 4/7/20.
//  Copyright © 2020 Wayne Apps. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

struct pc {
    static let none: UInt32 = 0x1 << 0
    static let player: UInt32 = 0x1 << 1
    static let barrel: UInt32 = 0x1 << 2
    static let nextBarrel: UInt32 = 0x1 << 3
    static let ui: UInt32 = 0x1 << 4
}

class GameScene: SKScene {
    
    public var controller = GameViewController()
    
    var player = SKShapeNode()
    var arrow = SKSpriteNode(imageNamed: "arrow")
    var barrel = SKShapeNode()
    var nextBarrel = SKShapeNode()
    
    var scoreLabel = SKLabelNode(text: "0")
    
    var gameOverMenu = SKShapeNode()
    var gameOverLabel = SKLabelNode(text: "Game Over")
    var ttpLabel = SKLabelNode(text: "tap to retry")
    var gameOverScore = SKLabelNode(text: "Score: 0")
    var highScoreLabel = SKLabelNode(text: "High Score: 0")
    var shareButton = SKSpriteNode()
    var gameOverImage = UIImage()
    var gameOverTexture = SKTexture()
    var gameOverSprite = SKSpriteNode()
    var overlayView = UIView()
    
    
    var continuing = false
    var continueMenu = SKShapeNode()
    var continueLabel = SKLabelNode(text: "Continue?")
    var continueTimerShape = SKShapeNode()
    var continueTimerNode = SKLabelNode()
    var yesButton = SKLabelNode(text: "Yes")
    var noButton = SKLabelNode(text: "no thanks")
    
    var shareMenu = SKShapeNode()
    var messageButton = SKSpriteNode(imageNamed: "imessage")
    var fbButton = SKSpriteNode(imageNamed: "facebook")
    var igButton = SKSpriteNode(imageNamed: "instagram")
    var scButton = SKSpriteNode(imageNamed: "snapchat")
    var twitterButton = SKSpriteNode(imageNamed: "twitter")
    var moreButton = SKSpriteNode(imageNamed: "more")
    
//    var titleLabel = SKLabelNode(text: "Doot")
    var linkLabel = SKLabelNode(text: "wayneapps.com/doot")

    var score: Int = 0
    var timesPlayed: Int = 0
    
    let outlineAttrib = [
    NSAttributedString.Key.strokeColor : UIColor.black,
    NSAttributedString.Key.foregroundColor : UIColor.white,
    NSAttributedString.Key.strokeWidth : -4.0,
    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 44)] as [NSAttributedString.Key : Any]
    
    let colors: [UIColor] = [#colorLiteral(red: 1, green: 0.2980392157, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 1, green: 0.4980392157, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 1, green: 0.3623184419, blue: 1, alpha: 1), #colorLiteral(red: 0.5, green: 1, blue: 0.5, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0.4300726232, alpha: 1), #colorLiteral(red: 0.2941176471, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.1758637764, green: 0.5916043134, blue: 0.9767275528, alpha: 1), #colorLiteral(red: 0.6037081866, green: 0.3030919894, blue: 1, alpha: 1)]
    
    var spinSpeed: CGFloat = 0.07
    var clockwise = true
    var pointingDown = false
    
    var canShoot = true
    var hasShot = false
    var dead = false
    var success = false
    var transitioning = false
    
    var hasScreenshot = false
    var shareImage = UIImage()
    
    var shouldShowAd = false
    var shouldShowRewardAd = false
    
    var timer: Int = 10
    
    var hasShownRewardThisGame = false
    
    var sound = SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)
    
    func getPositionForBarrel() -> CGPoint {
        let x = CGFloat.random(in: -view!.bounds.width / 2 + 50 ... view!.bounds.width / 2 - 50)
        let y = CGFloat.random(in: -view!.bounds.height / 2 + 50 ... view!.bounds.height / 2 - 50)

        return CGPoint(x: x, y: y)
    }
    
    func getPositionForNextBarrel() -> CGPoint {
        
        let x = CGFloat.random(in: -view!.bounds.width / 2 + 50 ... view!.bounds.width / 2 - 50)
        var y: CGFloat = 0
        
        if barrel.position.y >= view!.bounds.height / 4 - 50 {
            y = CGFloat.random(in: -view!.bounds.height / 2 + 50 ... -50)
            
        } else if barrel.position.y >= 0 {
            y = CGFloat.random(in: -view!.bounds.height / 2 + 50 ...  -view!.frame.height / 4 - 50)
            
        } else if barrel.position.y >= -view!.bounds.height / 4 {
            y = CGFloat.random(in: view!.bounds.height / 4 + 50 ... view!.frame.height / 2 - 50)
            
        } else {
            y = CGFloat.random(in: 0 ... view!.bounds.height / 4 + 50)
        }
        
        

        return CGPoint(x: x, y: y)
    }
    
    func getRandomColor() -> UIColor {
        let x = Int.random(in: 0 ... colors.count - 1)
        
        return colors[x]
    }
    
    func setupGame(){
   //     anchorPoint = CGPoint(x: 0, y: 0)
        
        barrel = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius:  10)
        barrel.fillColor = getRandomColor()
        barrel.strokeColor = .clear
        barrel.zPosition = 2
        barrel.position = getPositionForBarrel()
        
        self.addChild(barrel)
        
        arrow.anchorPoint = CGPoint(x: 0.75, y: 0.5)
        arrow.zRotation = 0.5 * CGFloat.pi
        arrow.zPosition = barrel.zPosition - 1
        arrow.color = .red
        arrow.position = barrel.position
        
        self.addChild(arrow)
        
        player = SKShapeNode(circleOfRadius: 35)
        player.fillColor = .white
        player.strokeColor = .black
        player.lineWidth = 3
        player.position = barrel.position
        player.zPosition = barrel.zPosition + 1
                
        self.addChild(player)
        
        nextBarrel = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius:  10)
        nextBarrel.fillColor = getRandomColor()
        nextBarrel.strokeColor = .clear
        nextBarrel.zPosition = barrel.zPosition
        nextBarrel.position = getPositionForNextBarrel()
        
        
        self.addChild(nextBarrel)
        
        scoreLabel.position = CGPoint(x: 0, y: view!.frame.height / 2 - 100)
        scoreLabel.fontSize = 48
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.attributedText = NSMutableAttributedString(string: "\(score)", attributes: outlineAttrib )
        scoreLabel.zPosition = 50
        self.addChild(scoreLabel)
        
        gameOverMenu = SKShapeNode(rectOf: CGSize(width: (view?.frame.width)! , height: (view?.frame.height)!))
        gameOverMenu.fillColor = .darkGray
        gameOverMenu.strokeColor = .clear
        
        gameOverMenu.position = CGPoint(x: 0, y: 0)
        gameOverMenu.zPosition = 50
        gameOverMenu.isHidden = true
        
        self.addChild(gameOverMenu)
        
        
        gameOverLabel.position = CGPoint(x: 0, y: view!.frame.height / 2 - 75)
        gameOverLabel.fontSize = 82
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.attributedText = NSMutableAttributedString(string: "Game Over", attributes: outlineAttrib )
        gameOverMenu.addChild(gameOverLabel)
        
        
        ttpLabel.position = CGPoint(x: 0, y: highScoreLabel.position.y - 145)
        ttpLabel.horizontalAlignmentMode = .center
        ttpLabel.fontName = "AvenirNext-Bold"
        ttpLabel.attributedText = NSMutableAttributedString(string: "tap to retry", attributes: outlineAttrib )
        gameOverMenu.addChild(ttpLabel)
        
        gameOverSprite = SKSpriteNode(color: .black, size: CGSize(width: 120, height: 240))
        gameOverSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameOverSprite.position = CGPoint(x: 0, y: gameOverLabel.position.y - 145)
        gameOverSprite.zPosition = gameOverMenu.zPosition + 1
        gameOverMenu.addChild(gameOverSprite)

        
        gameOverScore.position = CGPoint(x: 0, y: gameOverSprite.position.y - 165)
        gameOverScore.fontSize = 32
        gameOverScore.fontName = "AvenirNext-Bold"
        gameOverScore.horizontalAlignmentMode = .center
        gameOverScore.attributedText = NSMutableAttributedString(string: "Score: \(score)", attributes: outlineAttrib )
        
        gameOverMenu.addChild(gameOverScore)
        
        highScoreLabel.position = CGPoint(x: 0, y: gameOverScore.position.y - 45)
        highScoreLabel.fontSize = 32
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.attributedText = NSMutableAttributedString(string: "High Score: 0", attributes: outlineAttrib )
        score = 0
        
        if UserDefaults.standard.object(forKey: "HighScore") == nil {
            newHighScore()
        }

        gameOverMenu.addChild(highScoreLabel)
        
        shareButton = SKSpriteNode(imageNamed: "share")
        shareButton.size = CGSize(width: 75, height: 75)
        shareButton.name = "share"
        shareButton.position = CGPoint(x: 0, y: -(view!.frame.height / 2) * 0.75)
        self.addChild(shareButton)
        //gameOverMenu.addChild(shareButton)
        shareButton.isHidden = true
        
        gameOverMenu.isHidden = true
        
        continueMenu = SKShapeNode(rect: CGRect(x: -view!.bounds.width / 2, y: -view!.frame.height / 2, width: view!.frame.width * 1, height: view!.frame.height * 1), cornerRadius: 75)
        continueMenu.fillColor = .darkGray
        continueMenu.strokeColor = .black
        //  continueMenu.position = CGPoint(x: -view!.frame.width / 2, y: -view!.bounds.height)
        continueMenu.zPosition = gameOverMenu.zPosition + 5
        self.addChild(continueMenu)
        
        continueLabel.position = CGPoint(x: 0, y: 200)
        continueLabel.attributedText = NSAttributedString(string: "Continue?", attributes: [
    //    NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)] as [NSAttributedString.Key : Any])
        continueLabel.zPosition = continueMenu.zPosition + 1
        continueMenu.addChild(continueLabel)
        
        continueTimerShape = SKShapeNode(circleOfRadius: 50)
        continueTimerShape.fillColor = .clear
        continueTimerShape.strokeColor = .white
        continueTimerShape.lineWidth = 10
        continueTimerShape.position = CGPoint(x: 0, y: 50)
        continueTimerShape.zPosition = continueMenu.zPosition + 1
        continueMenu.addChild(continueTimerShape)
        
        continueTimerNode.position = CGPoint(x: 0, y: -25)
        continueTimerNode.attributedText = NSAttributedString(string: "10", attributes: [
       // NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
      //  NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)] as [NSAttributedString.Key : Any])
        continueTimerNode.zPosition = continueMenu.zPosition + 1
        continueTimerShape.addChild(continueTimerNode)
        
        yesButton.position = CGPoint(x: 0, y: -200)
        yesButton.name = "yes"
        yesButton.attributedText = NSAttributedString(string: "Yes", attributes: [
     //   NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)] as [NSAttributedString.Key : Any])
        yesButton.zPosition = continueMenu.zPosition + 1
        continueMenu.addChild(yesButton)
        
        noButton.position = CGPoint(x: 0, y: -300)
        noButton.name = "no"
        noButton.attributedText = NSAttributedString(string: "no thanks", attributes: [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -0.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32)] as [NSAttributedString.Key : Any])
        noButton.zPosition = continueMenu.zPosition + 1
        continueMenu.addChild(noButton)
        
        continueMenu.isHidden = true
        
        shareMenu = SKShapeNode(rect: CGRect(x: -view!.frame.width / 2, y: -view!.frame.height / 2, width: view!.frame.width, height: 215))
        shareMenu.fillColor = .clear
        shareMenu.zPosition = gameOverMenu.zPosition + 1
        shareMenu.strokeColor = .clear
        gameOverMenu.addChild(shareMenu)
        
        messageButton.size = CGSize(width: 65, height: 65)
        messageButton.position = CGPoint(x: (-view!.frame.width / 4), y: -view!.frame.height / 2 + 155)
        messageButton.zPosition = shareMenu.zPosition + 1
        messageButton.name = "message"
        shareMenu.addChild(messageButton)
        
        scButton.size = CGSize(width: 65, height: 65)
        scButton.position = CGPoint(x: 0, y: -view!.frame.height / 2 + 155)
        scButton.zPosition = shareMenu.zPosition + 1
        scButton.name = "sc"
        shareMenu.addChild(scButton)
        
        twitterButton.size = CGSize(width: 65, height: 65)
        twitterButton.position = CGPoint(x: (view!.frame.width / 4), y: -view!.frame.height / 2 + 155)
        twitterButton.zPosition = shareMenu.zPosition + 1
        twitterButton.name = "twitter"
        shareMenu.addChild(twitterButton)
        
        fbButton.size = CGSize(width: 65, height: 65)
        fbButton.position = CGPoint(x: (-view!.frame.width / 4), y: -view!.frame.height / 2 + 80)
        fbButton.zPosition = shareMenu.zPosition + 1
        fbButton.name = "fb"
        shareMenu.addChild(fbButton)
        
        igButton.size = CGSize(width: 65, height: 65)
        igButton.position = CGPoint(x: 0, y: -view!.frame.height / 2 + 80)
        igButton.zPosition = shareMenu.zPosition + 1
        igButton.name = "ig"
        shareMenu.addChild(igButton)
        
        moreButton.size = CGSize(width: 65, height: 65)
        moreButton.position = CGPoint(x: (view!.frame.width / 4), y: -view!.frame.height / 2 + 80)
        moreButton.zPosition = shareMenu.zPosition + 1
        moreButton.name = "more"
        shareMenu.addChild(moreButton)
        
        shareMenu.isHidden = true
//
//        titleLabel.numberOfLines = 2
//        titleLabel.attributedText = NSAttributedString(string: "Doot", attributes: [
//           NSAttributedString.Key.strokeColor : UIColor.black,
//           NSAttributedString.Key.foregroundColor : UIColor.white,
//           NSAttributedString.Key.strokeWidth : -2.0,
//           NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 44)] as [NSAttributedString.Key : Any])
//        titleLabel.position = CGPoint(x: -view!.frame.width / 4 , y: igButton.position.y + 25)
//        titleLabel.zPosition = 50
//        self.addChild(titleLabel)
//        titleLabel.isHidden = true
        
        linkLabel.numberOfLines = 2
        linkLabel.attributedText = NSAttributedString(string: "wayneapps.com/doot", attributes: [
           NSAttributedString.Key.strokeColor : UIColor.black,
           NSAttributedString.Key.foregroundColor : UIColor.white,
           NSAttributedString.Key.strokeWidth : -2.0,
           NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 36)] as [NSAttributedString.Key : Any])
        linkLabel.position = CGPoint(x: 0 , y: igButton.position.y + 25)
        linkLabel.zPosition = 100
        self.addChild(linkLabel)
        linkLabel.isHidden = true

        
        if barrel.position.y > nextBarrel.position.y {
            pointingDown = true
            arrow.zRotation = .pi * 0.5
        } else {
            pointingDown = false
            arrow.zRotation = .pi * 1.5
        }
    }
    
    func resetGame(){
        
        barrel.position = getPositionForBarrel()
                
        
        arrow.position = barrel.position
                

        player.position = barrel.position
                        
        nextBarrel.fillColor = getRandomColor()
        nextBarrel.position = getPositionForNextBarrel()

//        shareButton.isHidden = false

        gameOverMenu.isHidden = true
        continueMenu.isHidden = true
        shareMenu.isHidden = true
        hasScreenshot = false

        if barrel.position.y > nextBarrel.position.y {
            pointingDown = true
            arrow.zRotation = .pi * 0.5
        } else {
            pointingDown = false
            arrow.zRotation = .pi * 1.5
        }
        
        spinSpeed = 0.07
        
        score = 0
        scoreLabel.attributedText = NSMutableAttributedString(string: "\(score)", attributes: outlineAttrib )
        scoreLabel.isHidden = false
        
        timesPlayed += 1
        
        success = false
        dead = false
        hasShot = false
        transitioning = false
        shouldShowAd = false
        shouldShowRewardAd = false
        hasShownRewardThisGame = false
        
        if timesPlayed == 7 {
            controller.askForRating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.canShoot = true
        }
    }
    
    func startNext(){
        
        spinSpeed = spinSpeed + (spinSpeed * 0.05)

        if spinSpeed >= 0.12 {
            spinSpeed = 0.12
        }
        
        barrel.position = getPositionForBarrel()
                
        arrow.isHidden = true
        arrow.position = barrel.position

        
        player.position = barrel.position
                        
        nextBarrel.fillColor = getRandomColor()
        nextBarrel.position = getPositionForNextBarrel()
        
        
        gameOverMenu.isHidden = true
        continueMenu.isHidden = true
        shareMenu.isHidden = true
        shouldShowAd = false
        shouldShowRewardAd = false
        
        if barrel.position.y > nextBarrel.position.y {
            pointingDown = true
            arrow.zRotation = .pi * 0.5
        } else {
            pointingDown = false
            arrow.zRotation = .pi * 1.5
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.canShoot = true
            self.success = false
            self.dead = false
            self.hasShot = false
            self.transitioning = false
            self.arrow.isHidden = false
        }
    }
    
    func continueGame(){
        barrel.position = getPositionForBarrel()
                
        arrow.isHidden = true
        arrow.position = barrel.position

        
        player.position = barrel.position
                        
        nextBarrel.fillColor = getRandomColor()
        nextBarrel.position = getPositionForNextBarrel()
        
        
        gameOverMenu.isHidden = true
        continueMenu.isHidden = true
        shareMenu.isHidden = true
        shouldShowAd = false
        shouldShowRewardAd = false
        scoreLabel.isHidden = false
        
        if barrel.position.y > nextBarrel.position.y {
            pointingDown = true
            arrow.zRotation = .pi * 0.5
        } else {
            pointingDown = false
            arrow.zRotation = .pi * 1.5
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.canShoot = true
            self.success = false
            self.dead = false
            self.hasShot = false
            self.transitioning = false
            self.arrow.isHidden = false
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.size = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        view.backgroundColor = .black
        view.tintColor = .black
        overlayView = view.snapshotView(afterScreenUpdates: true)!
        setupGame()
    }
    
    func getSpecialScreenshot() -> UIImage {
        overlayView = view!.snapshotView(afterScreenUpdates: true)!
               // add it over your view
        view!.addSubview(overlayView)
        shareMenu.isHidden = true
        scoreLabel.isHidden = true
   //     titleLabel.isHidden = false
        linkLabel.isHidden = false
        UIGraphicsBeginImageContextWithOptions((view?.frame.size)!, true, 1)
        view!.layer.render(in: UIGraphicsGetCurrentContext()!)
        view!.drawHierarchy(in: (view?.bounds)!, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { print("ERROR"); return UIImage()}
        UIGraphicsEndImageContext()
        overlayView.removeFromSuperview()
        shareMenu.isHidden = false
     //   titleLabel.isHidden = true
        linkLabel.isHidden = true
        return image
    }
    
    func getScreenshot() -> UIImage {

        shareMenu.isHidden = true
        gameOverLabel.isHidden = true
        ttpLabel.isHidden = true
        scoreLabel.isHidden = true
     //   titleLabel.isHidden = false
        linkLabel.isHidden = false
        UIGraphicsBeginImageContextWithOptions((view?.frame.size)!, true, 1)
        print("BEgAIN j;klasd l")
        view!.layer.render(in: UIGraphicsGetCurrentContext()!)
        print("render noin")
        view!.drawHierarchy(in: (view?.bounds)!, afterScreenUpdates: true)
        print("draw uhiin")
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { print("ERROR"); return UIImage()}
        print("imaged madedfvbjlk")
        UIGraphicsEndImageContext()
        print("ExITED POSDFPOIN")
        gameOverMenu.isHidden = false
        shareMenu.isHidden = false
        gameOverLabel.isHidden = false
        ttpLabel.isHidden = false
    //    titleLabel.isHidden = true
        linkLabel.isHidden = true
        return image
    }
    
    public func getReward(){
        print("rewardeddddddddd")
        hasShownRewardThisGame = true
        hasScreenshot = false
        continueGame()
    }
    
    func tappedShare(){
        shareButton.isHidden = true
        shareMenu.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if dead{
                
                let positionInScene = touch.location(in: self)
                let touchedNode = self.atPoint(positionInScene)

                if let name = touchedNode.name
                {
                    if name == "help"
                    {
//                        print("Touched Help")
//                        resetGameWithHelp()
//                        canCloseHelp = false
//                        helpView.isHidden = false
                    }
                    
                    if name == "share"
                    {
                        print("Touched Share")
                        tappedShare()
                       // controller.share(image: getScreenshot())
                    }
                    
                    if !continueMenu.isHidden {
                        if name == "yes" {
                            shouldShowRewardAd = true
                        }
                        
                        if name == "no" {
                            continueMenu.isHidden = true
                            shareMenu.isHidden = false
                            gameOverSprite.isHidden = false
                                //   setShareImage()
                        }
                    }
                    
                    if !shareMenu.isHidden {
                        if name == "message" {
                            controller.shareText(image: getSpecialScreenshot())
                            shareMenu.isHidden = false
                        }
                        if name == "fb" {
                            controller.shareTextOnFaceBook(image: getSpecialScreenshot())
                        }
                        if name == "ig" {
                            controller.shareToInstagramStories(image: getSpecialScreenshot())
                        }
                        if name == "sc" {
                            controller.shareOnSnapchat(image: getSpecialScreenshot())
                        }
                        if name == "twitter" {
                            controller.shareOnTwitter(image: getSpecialScreenshot())
                        }
                        if name == "more" {
                            controller.share(image: getSpecialScreenshot())
                        }
                        
                    }
                    
                } else {
                    if continueMenu.isHidden{
                        resetGame()
                    } else {
                        
                    }

                    
                }
                
            }
            
            if hasShot{
                
            } else if canShoot{
                hasShot = true
                canShoot = false
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
            
            
        }
    }
    
    func newHighScore(){
        UserDefaults.standard.set(score, forKey:"HighScore")
        UserDefaults.standard.synchronize()
        
        highScoreLabel.attributedText = NSMutableAttributedString(string: "High Score: \(score)", attributes: outlineAttrib )

        highScoreLabel.fontColor = .yellow
    }
    
    func countdown(count: Int) {
        timer = count
        continueTimerNode.attributedText = NSAttributedString(string: "\(timer)", attributes: [
       // NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
      // NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)] as [NSAttributedString.Key : Any])

        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countdownAction)])

        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: 10),
                                 SKAction.run(endCountdown)]))

    }

    func countdownAction() {
        timer -= 1
        continueTimerNode.attributedText = NSAttributedString(string: "\(timer)", attributes: [
    //    NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
    //    NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)] as [NSAttributedString.Key : Any])
    }

    func endCountdown() {
        
    }
    
    func setShareImage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            self.shareImage = self.getSpecialScreenshot()
        }
    }
    
    func die(){
        gameOverScore.attributedText = NSMutableAttributedString(string: "Score: \(score)", attributes: outlineAttrib )
        let highscore: Int = UserDefaults.standard.object(forKey: "HighScore") as! Int
        if score > highscore {
            newHighScore()
        } else {
            highScoreLabel.attributedText = NSMutableAttributedString(string: "High Score: \(highscore)", attributes: outlineAttrib)
        }
        
        if hasScreenshot {
            
        } else {
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            if self.score >= 5 {
                if self.timesPlayed % 2 == 0 && !self.hasShownRewardThisGame{
                    self.continueMenu.isHidden = false
                    shareMenu.isHidden = true
                    gameOverSprite.isHidden = true
                    self.countdown(count: 10)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.continueMenu.isHidden = true
                        self.shareMenu.isHidden = false
                        self.gameOverSprite.isHidden = false
                            //   self.setShareImage()

                    }
                } else {
                    self.shouldShowAd = true
                }
            }
        
        scoreLabel.isHidden = true
        gameOverImage = getScreenshot()
        hasScreenshot = true
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         
            gameOverMenu.isHidden = false

               //     self.gameOverImage = UIImage(named: "screenshot")!
                    gameOverTexture = SKTexture(image: self.gameOverImage)
                    
                    
                    
                    self.gameOverSprite.texture = self.gameOverTexture
                   // self.gameOverSprite.scale(to:  CGSize(width: 180, height: 320))
                    
            //
                   self.dead = true
            
                    //    setShareImage()
            
                    
            }
        
//        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if continueMenu.isHidden {
            
        } else {
            shareMenu.isHidden = true
            gameOverSprite.isHidden = true
        }
        
        if shouldShowAd {
            controller.showAd()
            shouldShowAd = false
        }
        
        if shouldShowRewardAd {
            controller.showRewardAd()
            shouldShowRewardAd = false
            continueMenu.isHidden = true
        }
        
        if hasShot {
            
            if dead {
                
                
                
            } else {
                
                if success {
                    if transitioning {
                        
                    } else {
                        transitioning = true
                        player.run(SKAction.move(to: nextBarrel.position, duration: 0.5))
                        score += 1
                        scoreLabel.attributedText = NSMutableAttributedString(string: "\(score)", attributes: outlineAttrib )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.run(self.sound)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.startNext()
                        }
                    }
                    
                    
                    
                } else {
                    if player.position.x < nextBarrel.position.x + 85 && player.position.x > nextBarrel.position.x - 85 && player.position.y < nextBarrel.position.y + 85 && player.position.y > nextBarrel.position.y - 85 {
                           print("HOSDHIFOHSDF")
                           
                          success = true
                       }
                       
                       player.position = CGPoint(x:player.position.x - cos(arrow.zRotation) * 10,y:player.position.y - sin(arrow.zRotation) * 10)
                }
                
               

            }
            
            if player.position.x > view!.frame.width / 2 + 50 || player.position.x < -view!.frame.width / 2 - 50 || player.position.y > view!.frame.height / 2 + 50 || player.position.y < -view!.frame.height / 2 - 50 {
                
                if !dead {
                    die()
                
                }
            }
            
        } else {
            
            if clockwise {
                arrow.zRotation += spinSpeed

            } else {
                arrow.zRotation -= spinSpeed
            }
            
            if pointingDown{
                if arrow.zRotation >= .pi {
                    clockwise = false
                }
                if arrow.zRotation <= 0 {
                    clockwise = true
                }
            } else {
                if arrow.zRotation <= .pi {
                    clockwise = true
                }
                if arrow.zRotation >= 2 * .pi {
                    clockwise = false
                }
            }
        }
        
        
        
        
        
        
        
    }
}
