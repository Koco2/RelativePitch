//
//  ViewController.swift
//  RelativePitch
//
//  Created by Chen Wang on 1/15/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit
import AppusCircleTimer



class ViewController: UIViewController{
    var keyLabel = [10000:"C",
                    10001:"D",
                    10002:"E",
                    10003:"F",
                    10004:"G",
                    10005:"A",
                    10006:"B",
                    10007:"Db",
                    10008:"Eb",
                    10009:"Gb",
                    10010:"Ab",
                    10011:"Bb"]
    
    let musicBox = MusicBox.shareInstance
    var timerView:TimerView!
    
    var chanceLabel:CommonLabel!
    var resultLabel:CommonLabel!
    
    //note keys
    var buttons = Array<KeyButtonView>()
    var smallButtons = Array<KeyButtonView>()
    var pauseButton: MenuButtonView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.5) {
            appearFromWhite(view: self)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = customRed
        
        //display 3/3 - 0/3
        addChanceLabel()
        
        //pasue button
        addPauseButton()
        
        //the clock
        addTimeVIew()
        
        //Wrong/Correct/Gameover
        addResultLabel()

        //create all the note keys
        createKey()
        
        //animation for showing note keys
        popKey()

    }
    
    
    // MARK: add Subviews
    private func addChanceLabel(){
        chanceLabel = CommonLabel(frame:CGRect(x:50,y:50,width:50,height:50))
        chanceLabel.textColor = UIColor.white
        chanceLabel.text = "\(chance)/5"
        self.view.addSubview(chanceLabel)
    }
    private func addPauseButton(){
        pauseButton = MenuButtonView(frame:CGRect(x:screenWidth-100,y:50,width:50,height:50))
        pauseButton.button.backgroundColor = UIColor.white
        pauseButton.button.addTarget(self, action: #selector(paused), for: .touchUpInside)
        pauseButton.label.text = "||"
        self.view.addSubview(pauseButton)
    }
    private func addTimeVIew(){
        timerView = TimerView(frame: CGRect(x: screenWidth/2-screenWidth/4, y: screenHeight/4, width: screenWidth/2, height: screenWidth/2))
        timerView.delegate = self
        self.view.addSubview(timerView)
    }
    private func addResultLabel(){
        resultLabel = CommonLabel(frame: CGRect(x: 0, y: screenHeight/2+screenWidth/8, width: screenWidth, height: 40))
        resultLabel.layer.opacity = 0
        resultLabel.text = "Wrong"
        resultLabel.textColor = UIColor.white
        self.view.addSubview(resultLabel)
    }
    
    // MARK: Key related functions
    private func popKey(){
        var i = 0
        while( i < buttons.count){
            UIView.animate(withDuration: 0.5+(0.2*Double(i))) {
                self.buttons[i].frame.origin.y = screenHeight-200
            }
            i+=1
            //111dsdfa
        }
        var j = 0
        while( j < smallButtons.count){
            UIView.animate(withDuration: 0.5+(0.2*Double(i+j))) {
                self.smallButtons[j].frame.origin.y = screenHeight-80
            }
            j+=1
        }
    }
    private func createKey(){
        //large key
        for i in 1...7{
            let keyView = KeyButtonView(frame: CGRect(x: Double(i-1)*Double(keyWidth), y: Double(UIScreen.main.bounds.height), width: Double(keyWidth), height: 230.0))
            keyView.createLargeKey()
            buttons.append(keyView)
            
            keyView.button.tag = i+10000-1
            keyView.tag = i+10000-1
            keyView.label.text = keyLabel[i+10000-1]
            
            
            if !enableKeys[keyView.button.tag]!{
                keyView.layer.opacity = opLevel
            }
            
            self.view.addSubview(keyView)
            
            keyView.button.addTarget(self, action: #selector(keyReleased(sender:)), for: .touchUpInside)
            keyView.button.addTarget(self, action: #selector(keyTapped(sender:)), for: .touchDown)
        }
        
        
        //small key
        let smallKeyDict = [8:2,9:3,10:5,11:6,12:7]
        for j in 8...12{
            let i = smallKeyDict[j]!
            let keyView = KeyButtonView(frame: CGRect(x: Double(i-1)*Double(keyWidth)-Double(keyWidth*0.3)-5, y: Double(UIScreen.main.bounds.height), width: Double(keyWidth*0.7), height: 230.0*0.5))
            keyView.createSmallKey()
            keyView.button.layer.cornerRadius = 18
            keyView.button.layer.borderWidth = 2
            keyView.button.layer.borderColor = customRed.cgColor
            keyView.button.tag = j+10000-1
            keyView.tag = j+10000-1
            keyView.label.text = keyLabel[j+10000-1]
            
            if !enableKeys[keyView.button.tag]!{
                keyView.layer.opacity = opLevel
            }
            
            smallButtons.append(keyView)
            self.view.addSubview(keyView)
            
            keyView.button.addTarget(self, action: #selector(keyReleased(sender:)), for: .touchUpInside)
            keyView.button.addTarget(self, action: #selector(keyTapped(sender:)), for: .touchDown)
        }
        
    }
    private func updateKey(){
        UIView.animate(withDuration: 1.5) {
            var i = 0
            while i < enableKeys.count{
                let KeyView = self.view.viewWithTag(10000+i)
                if enableKeys[10000+i]!{
                    KeyView?.layer.opacity = 1
                }else{
                    KeyView?.layer.opacity = opLevel
                }
                i+=1
            }
        }
        print("updated")
    }

    // MARK: Actions
    @objc private func keyTapped(sender:UIButton){
        //don't responds when the key is disabled
        if (!enableKeys[sender.tag]!){
            return
        }
        //stop the timer first
        self.timerView.timer.stop()
        //then play the music
        musicBox.playSound(index: sender.tag-10000)
        
        
        //check if answered
        if(!timerView.answered){
            timerView.answered = true
            
            //check the correctness
            if musicBox.lastNote == musicBox.noteList[sender.tag-10000]{
                ifCorrect()
            }else{
                ifWrong()
            }
            if(currentLevelScore == 0){
                levelUp()
            }
        }
    }
    @objc private func keyReleased(sender:UIButton){
        //print("lifted")
        enableKeys = levels[currentLevel]!
        //        if (!enableKeys[sender.tag]!){
        //            return
        //        }
        
        while(musicBox.audioPlayers[sender.tag-10000].volume>0){
            musicBox.audioPlayers[sender.tag-10000].volume = musicBox.audioPlayers[sender.tag-10000].volume - 0.05
            usleep(10000)
            //print(audioPlayers[sender.tag-10000].volume)
        }
        
        responds()
        print("released")
    }
    @objc private func paused(){
        stopped = true
        timerView.timer.stop()
        let vc = PauseViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK: game logic
    public func gameover(){
        print("gameover")
        if score > bestScore{
            bestScore = score
            defualts.set(bestScore, forKey: "best")
        }
        
        print(bestScore)
        
        //special transition
        let whiteScreen = UIView(frame: UIScreen.main.bounds)
        whiteScreen.backgroundColor = UIColor.white
        whiteScreen.layer.opacity = 0
        self.view.addSubview(whiteScreen)
        
        UIView.animate(withDuration: 0.5, animations: {
            whiteScreen.layer.opacity = 1
            
        }) { (bool) in
            self.navigationController?.pushViewController(GameOverViewController(), animated: false)
//            self.present(GameOverViewController(), animated: false) {
//                whiteTransitionPop(fromView: self)
//            }
            whiteScreen.removeFromSuperview()
        }
    }
    public func responds(){
        print("responds")
        //show Correct/Wrong/Miss Message
        UIView.animate(withDuration: 2, animations: {
            self.resultLabel.layer.opacity = 1
            self.resultLabel.layer.opacity = 0
        }) { (Bool) in
            //if pause before above animate finished
            if (!stopped) {
                self.timerView.replay(gg: gameOver)

            }

        }
        if(gameOver){
            gameover()
        }
        
        if(currentLevelScore == 0){
            currentLevelScore = scoreToNextLevel
            updateKey()
        }
    }
    private func ifCorrect(){
        score += 1
        currentLevelScore-=1
        timerView.scoreLabel.text = String(score)
        resultLabel.text = "Correct"
    }
    private func ifWrong(){
        resultLabel.text = "Wrong"
        chance -= 1
        chanceLabel.text = "\(chance)/5"
        if(chance == 0){
            resultLabel.text = "Game Over"
            gameOver = true
        }
    }
    private func levelUp(){
        if currentLevel != maxLevel{
            currentLevel+=1
            resultLabel.text = "Level \(currentLevel)"
        }
    }
    private func checkAnswer(){
    //func Timeup() is defined in extention below
    
    }
    public func prepareController(level:Int){
        currentLevel = level
        enableKeys = levels[currentLevel]!
    }
}

extension ViewController: TimerViewDelegate{
    func Timeup(){
        chance -= 1
        chanceLabel.text = "\(chance)/5"
        resultLabel.text = "Miss"
        if(chance == 0){
            resultLabel.text = "Game Over"
            gameOver = true
        }
        //add responds here because keyRelease won't trigger
        responds()
    }
}

extension ViewController:PauseViewDelegate{
    func passValue(gg:Bool) {
        //if quit
        print("passValue")
        if gg{
            gameOver = true
            responds()
            
        //if resume
        }else{
            timerView.replay(gg: false)
        }
        stopped = false
    }
}

