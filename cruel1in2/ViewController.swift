//
//  ViewController.swift
//  cruel1in2
//
//  Created by Jerry Huang on 2014/8/7.
//  Copyright (c) 2014年 Jerry Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Init varibales
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    let QUESTION_NUMBER: Int = 0
    
    struct LABEL_TYPE {
        let QUESTION = "QUESTION"
        let ANSWER = "ANSWER"
    }
    
    let labelType = LABEL_TYPE()
    
    // Choosed data
    var choosedData = Dictionary<String, Int>()
    
    var leftLabel = UILabel()
    var rightLabel = UILabel()
    let questionLabel = UILabel()
    let leftView = UIView()
    let rightView = UIView()
    let containerView = UIView()
    let questionView = UIView()
    let getAnswerBtn = UIButton()
    
    // Set struct of current tap point
    struct currentPoint {
        var x: CGFloat
        var y: CGFloat
        var initialized: Bool
    }
    
    var point = currentPoint(x: 0.0, y: 0.0, initialized: true)
    
    // Utility object
    let utility = Utility()
    
    // json data
    var jsonData: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
        
        var isConnected = utility.checkNetworkConnection()
        var url: String = utility.readConfig()
        
        if (isConnected) {
            
            println("get json data")
            
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            hud.mode = MBProgressHUDModeIndeterminate
            hud.labelText = "Loading data"
            
            hud.showAnimated(false, {
                dispatch_after(1, dispatch_get_main_queue(), {
                    
                    // Get Json
                    self.jsonData = self.utility.getJsonData(url)
                    println(self.jsonData)
                    hud.hide(true)
                    
                    self.setAnwser(self.labelType.ANSWER, data: self.jsonData)
                    self.setAnwser(self.labelType.QUESTION, data: self.jsonData)
                })
            })
        }
        else {
            let alert = UIAlertView()
            alert.title = "Yoooooooooooooooo"
            alert.message = "Please check you network connection."
            alert.addButtonWithTitle("ok")
            alert.delegate = self
            alert.show()
            
//            Load local data
//            let path = NSBundle.mainBundle().pathForResource("question", ofType: "json")
//            let jsonData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
//            var error: NSError?
//            let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
//            self.jsonData = jsonDict

//            ios 8 alert
//            var alert = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        println(self.jsonData)
    }
    
    // when alert button pressed, it will go to this function because "alert.delegate = self"
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            exit(0)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let touch : UITouch = touches.anyObject() as UITouch
        let cgpoint: CGPoint = touch.locationInView(self.view)
        
        point.x = cgpoint.x
        point.y = cgpoint.y
    }
    
    func getTap(recognizer: UITapGestureRecognizer) {
        var message: String = "( \(point.x) , \(point.y) )"
        var tapped_side = ""
        var choosedText = ""
        
        // Left or Right
        if (point.x < width/2) {
            tapped_side = "left"
            choosedData = addChoosedElement(leftLabel.text, input: choosedData)
            choosedText = leftLabel.text
        }
        else if (point.x > width/2) {
            tapped_side = "right"
            choosedData = addChoosedElement(rightLabel.text, input: choosedData)
            choosedText = rightLabel.text
        }
        else {
            tapped_side = "middle!!!!"
        }
        
        println("tapped: \(message), it's \(tapped_side) \n You choosed: \(choosedText)")
        
        message += "\n You choosed: \(choosedText)"
        
        setAnwser(labelType.ANSWER, data: jsonData)
//        let alert = UIAlertView()
//        alert.title = "Hey: \(tapped_side)"
//        alert.message = message
//        alert.addButtonWithTitle("ok")
//        alert.show()
    }
    
    // Set anwer to label
    func setAnwser(type: String, data: NSDictionary) {
        let data = JSONValue(data)
        
        switch(type) {
        case labelType.ANSWER:
            var maxNum: Int = (data["questions"][QUESTION_NUMBER]["answers"].array)!.count
            let ans = data["questions"][QUESTION_NUMBER]["answers"]
            
            var randomNum1 = Int(Int(rand()) % maxNum)
            var randomNum2 = Int(Int(rand()) % maxNum)
            
            if (ans[randomNum1].string == ans[randomNum2].string) {
                randomNum2 = Int(Int(rand()) % maxNum)
            }
            
            println(maxNum)
            println(randomNum1)
            println(randomNum2)
            
            println(ans[randomNum1].string)
            println(ans[randomNum2].string)
            
            leftLabel.text = ans[randomNum1].string
            rightLabel.text = ans[randomNum2].string
        case labelType.QUESTION:
            questionLabel.text = data["questions"][QUESTION_NUMBER]["question"].string
        default:
            break
        }
    }
    
    // Init UI
    func initUI() {
        // Init label
        leftLabel.text = ""
        rightLabel.text = ""
        
        // Get Screen resolution
        var bounds: CGRect = UIScreen.mainScreen().bounds
        width = bounds.size.width
        height = bounds.size.height
        
        // Set View position
        containerView.frame = CGRectMake(0, height*0.2+20, width, height*0.6)
        
        leftView.frame = CGRectMake(0, 0, containerView.frame.size.width/2, containerView.frame.size.height)
        leftView.backgroundColor = UIColor.greenColor()
        
        rightView.frame = CGRectMake(width/2, 0, containerView.frame.size.width/2, containerView.frame.size.height)
        rightView.backgroundColor = UIColor.yellowColor()
        
        questionView.frame = CGRectMake(0, 20, width, height*0.2)
        questionView.backgroundColor = UIColor.blackColor()
        
        // Set Labels position
        questionLabel.frame = CGRectMake(width/2 - width/3, 20, width*2/3, height*0.1)
        leftLabel.frame = CGRectMake(leftView.frame.size.width/2-50, leftView.frame.size.height/3, 100, 30)
        rightLabel.frame = CGRectMake(rightView.frame.size.width/2-50, rightView.frame.size.height/3, 100, 30)
        
        // Left Label
        leftLabel = setLabelAttr(leftLabel)
        
        // Reset label position if sizeToFit make it smaller
        if (leftLabel.frame.size.width < 100) {
            leftLabel.frame = CGRectMake(leftView.frame.size.width/2-50, leftView.frame.size.height/3, 100, 30)
        }
        
        // Right Label
        rightLabel = setLabelAttr(rightLabel)
        
        // Reset label position if sizeToFit make it smaller
        if (rightLabel.frame.size.width < 100) {
            rightLabel.frame = CGRectMake(rightView.frame.size.width/2-50, rightView.frame.size.height/3, 100, 30)
        }
        
        // Question Label
        questionLabel.backgroundColor = UIColor.whiteColor()
        questionLabel.textColor = UIColor.blackColor()
        questionLabel.layer.masksToBounds = true;
        questionLabel.layer.cornerRadius = 10;
        questionLabel.textAlignment = NSTextAlignment.Center;
        questionLabel.text = "??"
        
        // Button
        getAnswerBtn.frame = CGRectMake(0, height*0.835, width, height*0.16)
        getAnswerBtn.setTitle("得分最高的是....?", forState: UIControlState.Normal)
        getAnswerBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        getAnswerBtn.titleLabel.shadowColor = UIColor.whiteColor()
        getAnswerBtn.layer.borderWidth = 3
        getAnswerBtn.layer.borderColor = UIColor.blackColor().CGColor
        getAnswerBtn.layer.cornerRadius = 7
        getAnswerBtn.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)

        // Add each view
        self.view.addSubview(containerView)
        self.view.addSubview(questionView)
        questionView.addSubview(questionLabel)
        
        // Add UITapGestureRecognizer
        var getTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("getTap:"))
        containerView.addGestureRecognizer(getTapRecognizer)
        
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        self.view.addSubview(getAnswerBtn)
        
        leftView.addSubview(leftLabel)
        rightView.addSubview(rightLabel)
        
        var screen_resolution = "{ \(width), \(height)}"
        
        println("screen_resolution = \(screen_resolution)")
    }
    
    func buttonTapped(sender: UIButton) {
        var mostChoosedItem = getMostChoosedElement(choosedData)
        println("Button tapped: \(mostChoosedItem)")
        
        let alert = UIAlertView()
        alert.title = "得分最高的是!!!!!"
        alert.message = mostChoosedItem
        alert.addButtonWithTitle("ok")
        alert.show()
    }
    
    // Count the most chooesd element in array (TODO: Need to be refacted)
    func getMostChoosedElement(data: Dictionary<String, Int>) -> String {
        var mostChoosedItem = ""
        var mostChoosedValue = 0
        
        for index in data.keys {
            if (data[index] > mostChoosedValue) {
                mostChoosedItem = index
                mostChoosedValue = data[index]!
            }
        }
    
        return mostChoosedItem
    }
    
    func addChoosedElement(choosed: String, input: Dictionary<String, Int>) -> Dictionary<String, Int> {
        var data = input
        var added = false
        
        for index in data.keys {
            if (choosed == index) {
                data[choosed] = data[choosed]! + 1
                added = true
                break
            }
        }
        
        if (!added) {
            data[choosed] = 0
        }
        
        println("data choosed: \(choosed) : \(data[choosed])" )
        
        return data
    }
    
    // Common label configure
    func setLabelAttr(label: UILabel) -> UILabel {
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.whiteColor()
        label.layer.masksToBounds = true;
        label.layer.cornerRadius = 10;
        label.textAlignment = NSTextAlignment.Center;
        label.numberOfLines = 6
        label.sizeToFit()
        
        return label
    }
}



