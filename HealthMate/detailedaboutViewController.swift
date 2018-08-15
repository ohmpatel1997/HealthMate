//
//  detailedaboutViewController.swift
//  HealthMate
//
//  Created by Mac on 27/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit

class detailedaboutViewController: UIViewController {

	
	@IBOutlet weak var webview: UIWebView!
	
	var formatedHtml:String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		self.webview.allowsLinkPreview = true
	
        // Do any additional setup after loading the view.
		
		let aux = "<span style=\"font-family: Dosis-Medium; font-size: 15.0;  \">\(formatedHtml)</span>"
		self.webview?.loadHTMLString(aux, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
