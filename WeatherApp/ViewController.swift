//
//  ViewController.swift
//  WeatherApp
//
//  Created by Diego  Collao on 27-07-16.
//  Copyright © 2016 Undisclosure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBAction func searchButtonAction(sender: AnyObject) {
        var url = NSURL(string: "http://es.weather-forecast.com/locations/"+cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")+"/forecasts/latest")
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                //Create a flag.
                var flagError = false
                var weather = ""
                
                
                if error == nil {
                    
                    //If the error is nil, I got something on NSURL
                    var urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    //But if what I obtain doesn't exist I'll check that with this if..
                    
                    if urlContentArray.count > 0 {
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        weather = weatherArray[0] as String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg", withString: "º")
                    } else {
                        flagError = true
                    }
                } else {
                    flagError = true
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    if flagError == true {
                        self.showError()
                    } else {
                        self.timeLabel.text = weather
                    }
                }
            })
            task.resume()
            
        } else {
            showError()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func showError(){
        timeLabel.text = "Error"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

