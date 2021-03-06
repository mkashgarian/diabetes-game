/*
 ///////////////////////////////////////////////////////////////
 //  Level1.swift
 //  SpriteKitGame
 //
 //  Created by Marina Kashgarian on 4/5/17.
 //  Copyright © 2017 Marina Kashgarian. All rights reserved.
 //
 
 import Foundation
 import SpriteKit
 
 enum object2:UInt32{
 case food = 1
 case player = 2
 }
 
 class Level2: SKScene, SKPhysicsContactDelegate{
 var gameOver = false
 
 //collection of food sprites
 var collection = [Foods]()
 
 // # of carbs collected
 var count = 0
 
 let background = SKSpriteNode(imageNamed: "background_breakfast.png")
 let backgrounds = SKSpriteNode(imageNamed: "background_noon.png")
 var round1 = true
 var round2 = false
 var round3 = false
 var done = false
 var goal1 = 100
 var goal2 = 100
 var goal3 = 100
 
 //initialize player avatar
 let player = SKSpriteNode(imageNamed: "ram")
 var playerTouched:Bool = false
 var playerLocation = CGPoint(x: 0, y: 0)
 
 let successScreen = SKSpriteNode(imageNamed: "success-icon")
 let levelOneScreen = SKSpriteNode(imageNamed: "level2icon")
 
 //pause when touch contact ends
 let pauseScreen = SKLabelNode(fontNamed: "Chalkduster")
 
 // static var backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
 
 
 // make sound effects here, then call playSound(sound: soundname) to play them
 var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
 var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
 var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
 var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
 
 //streak setting for Level 1
 //round 1 streak of 10
 //round 2 streak of 15
 //round 3 streak of 20
 //round 4 streak of 20 + speed up food icons
 //round 5 streak of 20 + speed up food icons and decrease ratio of non-carb to carb items
 var streak = 0
 
 //meter to keep track of streak
 var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
 
 
 
 override func didMove(to view: SKView) {
 
 //set background color
 // backgroundColor = SKColor.cyan
 
 //   let background = SKSpriteNode(imageNamed: "background_breakfast.png")
 background.size = self.frame.size
 background.position = CGPoint(x: size.width/2, y: size.height * 0.55)
 // background.setScale(1.22)
 background.zPosition = -1
 addChild(background)
 
 
 //add background music
 let backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
 self.addChild(backgroundMusic)
 
 
 //add physics to allow for contact between food and player
 physicsWorld.contactDelegate = self
 player.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
 player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
 player.physicsBody?.affectedByGravity = false
 player.physicsBody?.categoryBitMask = object.player.rawValue
 player.physicsBody?.collisionBitMask = 0
 player.physicsBody?.contactTestBitMask = object.food.rawValue
 player.name = "player"
 addChild(player)
 
 
 //create all foods and put them in an array
 NewFood()
 
 
 run(SKAction.repeatForever(
 SKAction.sequence([
 SKAction.run(addFood),
 SKAction.wait(forDuration: 1.0)
 ])
 ))
 
 //clear out section at bottom of screen for meter
 let meterFrame = SKSpriteNode(color: SKColor .white, size: CGSize(width: size.width * 2, height: 100))
 meterFrame.position = CGPoint(x: size.width, y: 50)
 addChild(meterFrame)
 
 //add meter
 foodMeter.name = "meter"
 meterFrame.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:0, y:100), to: CGPoint(x:
 size.width, y: 100))
 foodMeter.position = CGPoint(x: 0 , y: 50)
 foodMeter.anchorPoint = CGPoint(x: 0.0, y: 0.5)
 addChild(foodMeter)
 
 //create pause screen attributes - add pause screen when touch contact ends
 pauseScreen.text = "PAUSED"
 pauseScreen.fontSize = 150
 pauseScreen.fontColor = SKColor.black
 pauseScreen.position = CGPoint(x: frame.midX, y: frame.midY)
 pauseScreen.zPosition = 1.0
 
 //position success screen to center
 successScreen.position = CGPoint(x: frame.midX, y: frame.midY)
 successScreen.zPosition = 1.0
 
 
 levelOneScreen.position = CGPoint(x: frame.midX, y: frame.midY)
 levelOneScreen.zPosition = 1.0
 addChild(levelOneScreen)
 levelOneScreen.run(
 SKAction.fadeOut(withDuration: 0.5)
 )
 
 }
 
 // RECOGNIZING TOUCH GESTURES
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
 if (!gameOver){
 playerTouched = true
 //play game when player puts down finger
 view?.scene?.isPaused = false
 pauseScreen.removeFromParent()
 
 for touch in touches {
 playerLocation = touch.location(in: self)
 }
 
 }else{
 let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
 
 let scene = MenuScene(size: self.size)
 self.view?.presentScene(scene, transition: reveal)
 }
 
 
 }
 
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
 for touch in touches {
 playerLocation = touch.location(in: self)
 }
 }
 
 override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
 if (!gameOver){
 playerTouched = false
 //pause game when player lifts finger
 view?.scene?.isPaused = true
 addChild(pauseScreen)
 }
 }
 
 
 override func update(_ currentTime: CFTimeInterval) {
 if(playerTouched) {
 moveNodeToLocation()
 }
 }
 
 func moveNodeToLocation() {
 let speed: CGFloat = 0.25
 
 var dx = playerLocation.x - player.position.x
 var dy = playerLocation.y - player.position.y
 
 dx = dx * speed
 dy = dy * speed
 player.position = CGPoint(x: player.position.x+dx, y: player.position.y + dy)
 
 }
 
 
 
 func random() -> CGFloat {
 return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
 }
 
 func random(min: CGFloat, max: CGFloat) -> CGFloat {
 return random() * (max - min) + min
 }
 
 func addFood() {
 var food = collection[0].node.copy() as! SKSpriteNode
 done = false
 while(!done) {
 let randd = Int(arc4random_uniform(22))
 // random number casted as int to pick food to show
 if((round1 && collection[randd].b) || (round2 && collection[randd].l) || (round3 && collection[randd].d)) {
 food = collection[randd].node.copy() as! SKSpriteNode
 done = true
 }
 }
 
 // Determine where to spawn the food along the Y axis
 let actualY = random(min: food.size.height/2 + 100, max: size.height - food.size.height/2)
 
 food.position = CGPoint(x: size.width + food.size.width/2, y: actualY)
 food.physicsBody = SKPhysicsBody(circleOfRadius: food.size.width/2)
 food.physicsBody?.affectedByGravity = false
 food.physicsBody?.collisionBitMask = 0
 food.physicsBody?.categoryBitMask = object.food.rawValue
 food.name = "food"
 
 
 // Add the food to the game
 addChild(food)
 
 // Calculate the speed of the food
 let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
 
 let actionMove = SKAction.move(to: CGPoint(x: -food.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
 let actionMoveDone = SKAction.removeFromParent()
 food.run(SKAction.sequence([actionMove, actionMoveDone]))
 
 }
 
 //
 //    struct Sound {
 //        static var isVolumeOn = true
 //
 //        static func playSound() {
 //            backgroundMusic.run(SKAction.play())
 //        }
 //        static func stopSound() {
 //            backgroundMusic.run(SKAction.stop())
 //        }
 //    }
 
 //CREATE NEW FOODS FOR GAME
 
 func NewFood() {
 
 
 let pizzaNode = SKSpriteNode(imageNamed: "Foods.sprite/pizza.png")
 let f1 = Foods(node: pizzaNode, carb_count: 30, carb: true, b: false, l:true, d:true)
 collection.append(f1)
 
 let appleNode = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
 let f2 = Foods(node: appleNode, carb_count: 15, carb: true, b: true, l:true, d:false)
 collection.append(f2)
 
 let burgerNode = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
 let f3 = Foods(node: burgerNode, carb_count: 30, carb: true, b: false, l:true, d:true)
 collection.append(f3)
 
 let broccoliNode = SKSpriteNode(imageNamed: "Foods.sprite/broccoli.png")
 let f4 = Foods(node: broccoliNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f4)
 
 let bananaNode = SKSpriteNode(imageNamed: "Foods.sprite/banana.png")
 let f5 = Foods(node: bananaNode, carb_count: 15, carb: true, b: true, l:true, d:false)
 collection.append(f5)
 
 let cookieNode = SKSpriteNode(imageNamed: "Foods.sprite/cookie.png")
 let f6 = Foods(node: cookieNode, carb_count: 9, carb: true, b: true, l:true, d:true)
 collection.append(f6)
 
 let donutNode = SKSpriteNode(imageNamed: "Foods.sprite/donut.png")
 let f7 = Foods(node: donutNode, carb_count: 22, carb: true, b: true, l:true, d:true)
 collection.append(f7)
 
 let friesNode = SKSpriteNode(imageNamed: "Foods.sprite/fries.png")
 let f8 = Foods(node: friesNode, carb_count: 45, carb: true, b: false, l:true, d:true)
 collection.append(f8)
 
 let grapesNode = SKSpriteNode(imageNamed: "Foods.sprite/grapes.png")
 let f9 = Foods(node: grapesNode, carb_count: 15, carb: true, b: true, l:true, d:false)
 collection.append(f9)
 
 let hotdogNode = SKSpriteNode(imageNamed: "Foods.sprite/hotdog.png")
 let f10 = Foods(node: hotdogNode, carb_count: 21, carb: true, b: false, l:true, d:true)
 collection.append(f10)
 
 let ice_creamNode = SKSpriteNode(imageNamed: "Foods.sprite/ice_cream.png")
 let f11 = Foods(node: ice_creamNode, carb_count: 23, carb: true, b: false, l:true, d:true)
 collection.append(f11)
 
 let mangoNode = SKSpriteNode(imageNamed: "Foods.sprite/mango.png")
 let f12 = Foods(node: mangoNode, carb_count: 50, carb: true, b: true, l:true, d:false)
 collection.append(f12)
 
 let peachNode = SKSpriteNode(imageNamed: "Foods.sprite/peach.png")
 let f13 = Foods(node: peachNode, carb_count: 14, carb: true, b: true, l:true, d:false)
 collection.append(f13)
 
 let baconNode = SKSpriteNode(imageNamed: "Foods.sprite/bacon.png")
 let f14 = Foods(node: baconNode, carb_count: 0, carb: false, b: true, l:true, d:false)
 collection.append(f14)
 
 let carrotNode = SKSpriteNode(imageNamed: "Foods.sprite/carrot.png")
 let f15 = Foods(node: carrotNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f15)
 
 let celeryNode = SKSpriteNode(imageNamed: "Foods.sprite/celery.png")
 let f16 = Foods(node: celeryNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f16)
 
 let chickenNode = SKSpriteNode(imageNamed: "Foods.sprite/chicken.png")
 let f17 = Foods(node: chickenNode, carb_count: 0, carb: false, b: true, l:true, d:true)
 collection.append(f17)
 
 let fishNode = SKSpriteNode(imageNamed: "Foods.sprite/fish.png")
 let f18 = Foods(node: fishNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f18)
 
 let mushroomNode = SKSpriteNode(imageNamed: "Foods.sprite/mushroom.png")
 let f19 = Foods(node: mushroomNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f19)
 
 let porkNode = SKSpriteNode(imageNamed: "Foods.sprite/pork.png")
 let f20 = Foods(node: porkNode, carb_count: 0, carb: false, b: true, l:true, d:true)
 collection.append(f20)
 
 let spinachNode = SKSpriteNode(imageNamed: "Foods.sprite/spinach.png")
 let f21 = Foods(node: spinachNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f21)
 
 let steakNode = SKSpriteNode(imageNamed: "Foods.sprite/steak.png")
 let f22 = Foods(node: steakNode, carb_count: 0, carb: false, b: false, l:true, d:true)
 collection.append(f22)
 
 
 
 }
 
 //COLLISION DETECTION
 
 func didBegin(_ contact: SKPhysicsContact) {
 
 
 if (contact.bodyA.node?.name == "food") {
 if let node = contact.bodyA.node as? SKSpriteNode {
 contact.bodyA.node?.removeFromParent()
 testFoodNode(node: node)
 }
 
 }else if(contact.bodyB.node?.name == "food"){
 if let node = contact.bodyB.node as? SKSpriteNode {
 contact.bodyB.node?.removeFromParent()
 testFoodNode(node: node)
 }
 }
 
 
 }
 
 func testFoodNode(node: SKSpriteNode){
 for food in collection {
 if food.node.texture == node.texture {
 if(!food.carb){
 playSound(sound: good_carb)
 streak += 1
 
 }else{
 incrementMeter(carb_count: food.carb_count)
 playSound(sound: bad_carb)
 count += food.carb_count
 if(count>100 && count<=200 && !round2) {
 // start round 2
 round1 = false
 round2 = true
 print("Count: \(count)")
 backgrounds.removeFromParent()
 let background = SKSpriteNode(imageNamed: "background_noon.png")
 background.size = self.frame.size
 background.position = CGPoint(x: size.width/2, y: size.height * 0.55)
 // background.setScale(1.22)
 background.zPosition = -1
 addChild(background)
 
 }
 if(count>200 && !round3) {
 print("Count: \(count)")
 
 // start round 3
 round2 = false
 round3 = true
 background.removeFromParent()
 let backgrounds = SKSpriteNode(imageNamed: "background_night.png")
 backgrounds.size = self.frame.size
 
 backgrounds.position = CGPoint(x: size.width/2, y: size.height * 0.55)
 // backgrounds.setScale(1.22)
 backgrounds.zPosition = -1
 addChild(backgrounds)
 }
 //                    let retryScreen = SKSpriteNode(imageNamed: "retry-icon")
 //                    retryScreen.position = CGPoint(x: frame.midX, y: frame.midY)
 //                    retryScreen.zPosition = 1.0
 //                    addChild(retryScreen)
 //                    retryScreen.run(
 //                        SKAction.fadeOut(withDuration: 0.5)
 //                    )
 streak = 0
 resetMeter()
 if(count>300){
 endRound()
 }
 }
 }
 }
 
 
 
 }
 
 func playSound(sound : SKAction) {
 run(sound)
 }
 
 
 //increment meter by number of carbs
 func incrementMeter(carb_count: Int){
 
 //        foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width / 5), height: foodMeter.size.height)
 //        if (round1) {
 //            foodMeter.size = CGSize(width: foodMeter.size.width + (carb_count / goal1), height: foodMeter.size.height)
 //        } else if (round2) {
 //            foodMeter.size = CGSize(width: foodMeter.size.width as Any + (carb_count / goal2), height: foodMeter.size.height)
 //
 //        } else if (round3) {
 //            foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width / goal3), height: foodMeter.size.height)
 //        }
 //        // take how big it was before and add one fifth
 }
 
 func resetMeter(){
 foodMeter.size = CGSize(width: 0, height: foodMeter.size.height)
 }
 
 func endRound(){
 gameOver = true
 view?.scene?.isPaused = true
 player.removeFromParent()
 addChild(successScreen)
 playSound(sound: level_complete)
 }
 
 
 }
 */
