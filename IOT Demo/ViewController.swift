//
//  ViewController.swift
//  IOT Demo
//
//  Created by 賴冠宇 on 2017/7/23.
//  Copyright © 2017年 LaiTest. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var ref: DatabaseReference!
    var ledGreen , ledYellow , ledRed : Bool?
    var color_green_light = UIColor.init(red: 153/255, green: 204/255, blue: 0/255, alpha: 1)
    var color_green_dark = UIColor.init(red: 102/255, green: 153/255, blue: 0/255, alpha: 1)
    var color_yellow_light = UIColor.init(red: 255/255, green: 187/255, blue: 51/255, alpha: 1)
    var color_yellow_dark = UIColor.init(red: 255/255, green: 136/255, blue: 0/255, alpha: 1)
    var color_red_light = UIColor.init(red: 255/255, green: 68/255, blue: 68/255, alpha: 1)
    var color_red_dark = UIColor.init(red: 204/255, green: 0/255, blue: 0/255, alpha: 1)
    
    
    
    @IBOutlet weak var lcdTxt: UITextField!
    @IBAction func lcdSend(_ sender: Any) {
        var lcdInput = lcdTxt.text
        ref.child("lcd").child("data").setValue("LCD\(lcdInput!)")
        ref.child("lcd").child("change").setValue(true)
        lcdTxt.text = ""
    }
    
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBAction func greenClick(_ sender: Any) {
        if(ledGreen)!{//亮變暗
            greenBtn.backgroundColor = color_green_dark
        }else{
            greenBtn.backgroundColor = color_green_light
        }
        ledGreen = !ledGreen!;
        ref.child("green").child("switch").setValue(ledGreen)
        ref.child("green").child("change").setValue(true)
    }
    @IBAction func yellowClick(_ sender: Any) {
        if(ledYellow)!{//亮變暗
            yellowBtn.backgroundColor = color_yellow_dark
        }else{
            yellowBtn.backgroundColor = color_yellow_light
        }
        ledYellow = !ledYellow!;
        ref.child("yellow").child("switch").setValue(ledYellow)
        ref.child("yellow").child("change").setValue(true)    }
    @IBAction func redClick(_ sender: Any) {
        if(ledRed)!{//亮變暗
            redBtn.backgroundColor = color_red_dark
        }else{
            redBtn.backgroundColor = color_red_light
        }
        ledRed = !ledRed!;
        
        ref.child("red").child("switch").setValue(ledRed)
        ref.child("red").child("change").setValue(true)
    }
    
    @IBOutlet weak var switchImg: UIImageView!
    @IBOutlet weak var temperatureShow: UILabel!
    @IBOutlet weak var rfidShow: UILabel!
    
    @IBOutlet var background: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        ledSetup()
        mySwitch()
        myRfid()
        myTemperature()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ledSetup(){
        ref.child("green").child("switch").observe(.value, with: {
            (snapshot) in
            self.ledGreen = snapshot.value as? Bool
            if(self.ledGreen)!{
                self.greenBtn.backgroundColor = self.color_green_light
            }else{
                self.greenBtn.backgroundColor = self.color_green_dark
            }
        })
        ref.child("yellow").child("switch").observe(.value, with: {
            (snapshot) in
            self.ledYellow = snapshot.value as? Bool
            if(self.ledYellow)!{
                self.yellowBtn.backgroundColor = self.color_yellow_light
            }else{
                self.yellowBtn.backgroundColor = self.color_yellow_dark
            }
        })
        ref.child("red").child("switch").observe(.value, with: {
            (snapshot) in
            self.ledRed = snapshot.value as? Bool
            if(self.ledRed)!{
                self.redBtn.backgroundColor = self.color_red_light
            }else{
                self.redBtn.backgroundColor = self.color_red_dark
            }
        })
    }
    func mySwitch(){
        ref.child("switch").observe(.value, with: { (snapshot) in
            var sw = snapshot.value as? Bool
            if sw! {
                self.switchImg.image = #imageLiteral(resourceName: "open")
            }else{
                self.switchImg.image = #imageLiteral(resourceName: "close")
            }
        })
    }
    func myTemperature(){
        ref.child("temperature").observe(.value, with: { (snapshot) in
            var temp = snapshot.value as? String
            self.temperatureShow.text = "\(temp!)°C"
        })
    }
    func myRfid(){
        ref.child("rfid").child("change").observe(.value, with: { (snapshot) in
            var change = snapshot.value as? Bool
            if change! {
                self.ref.child("rfid").child("data").observeSingleEvent(of: .value, with: { (snapshot) in
                    var data = snapshot.value as? String
                    if data == "illegitimate" {
                        self.rfidShow.text = "illegitimate user"
                        //self.myAlert()
                    }else{
                        self.rfidShow.text = data
                    }
                })
                self.ref.child("rfid").child("change").setValue(false)
            }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //按到旁邊 空白處 View Controller
        lcdTxt.resignFirstResponder() //離開主要元件 游標離開元件 游標離開btn鍵盤就會消失
    }
    func myAlert(){
        let queue = DispatchQueue(label: "com.appcoda.myqueue")
        
            queue.async {
        
                    self.background.backgroundColor = UIColor.white
                    
                    sleep(10)
                    
                    self.background.backgroundColor = UIColor.red
                    
                    sleep(3)
                    print("for")
            }
    }

}

