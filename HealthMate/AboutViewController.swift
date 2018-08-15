//
//  AboutViewController.swift
//  HealthMate
//
//  Created by Mac on 27/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	let about_text1  = "<p style=\"line-height:150%;\">HealthMate is a work of <a href=\"http://www.crescomtech.com\">Cresco Mobility Solutions.</a> Cresco is a Mumbai, India based start-up providing off-the-shelf as well as customized mobility solutions to simplify things for individuals, enterprises & communities. Some of our other works include:" +
	"<br/><br/>• <a href=\"https://play.google.com/store/apps/details?id=com.cresco.notifiCAtion\">notifiCAtion</a>  - a dedicated messaging & reminder app exclusively for Accountants" +
	"<br/><br/>• <a href=\"https://play.google.com/store/apps/details?id=com.cresco.adnoteOTA\">Ignite Messenger</a> - messenger app (based on our adnote platform) for Sharekhan's Ignite Program" +
	
	"<br/><br/>• <b>SalesTroop</b> - a field sales force automation platform for distributors & field sales professionals" +
	"<br/><br/>• <a href=\"https://play.google.com/store/apps/details?id=com.cresco.Navrang2014\">Navrang 2014</a> - official app of Navrang 2014, TMM's annual sports & cultural event " +
	//"<br/><br/>• <a href=\"https://play.google.com/store/apps/details?id=com.cresco.mAccountsFT\">mAccounts Mobile Accounting</a> - a complete, stand-alone, offline, Tally-compatible mobile accounting app" +
	"<br/><br/>Contact: 501, Meet Galaxy, Trimurti Lane, Behind Tip Top Plaza,Teen Hath Naka, Thane (W) – 400 604  |  +91 22 2539 1231  | contact@cresco.in  |   <a href=\"http://www.cresco.in\">www.cresco.in</a></p>";
	
	let licence = "<p style = \"border-style: solid; background-color: white; border-width: 1px\"><a href=\"https://www.apache.org/licenses/LICENSE-2.0\", style = \"color:green\" >Apache License, Version 2.0</a></p>";	
	@IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.tableview.delegate = self
		self.tableview.dataSource = self
        self.tableview.separatorStyle = .none
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "00CC00")
        
        // Do any additional setup after loading the view.
    }

	let data = ["About","Share","Rate","Licenses"]
	let imagedata = ["about","share","rate","licences"]
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableview.dequeueReusableCell(withIdentifier: "aboutcell") as! aboutcell
		
		cell.aboutimage.image = UIImage(named: imagedata[indexPath.row])
		cell.aboutlabel.text = data[indexPath.row]
		cell.selectionStyle = .none
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			let data = self.about_text1
			performSegue(withIdentifier: "detailedabout", sender: data)
		case 1:
			performShare()
		case 2:
			performRate()
		case 3:
			let data = self.licence
			performSegue(withIdentifier: "detailedabout", sender: data)
		default:
			print("Wrong option selected")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailedabout"{
			let VC = segue.destination as! detailedaboutViewController
				VC.formatedHtml = sender as! String
		}
	}
	
	func performShare(){
		let textToShare = "Download the Navratri iOS App"
		
		if let myWebsite = URL(string: "http://www.cresco.in/") {
			let objectsToShare = [textToShare, myWebsite] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			
			
			
			activityVC.popoverPresentationController?.sourceView = AnyObject.self as? UIView
			self.present(activityVC, animated: true, completion: nil)
		}
	}
	
	func performRate(){
		let appID = "1217878378"
		let alert = UIAlertController(title: "Rate", message: "Do you want to rate this app", preferredStyle: UIAlertControllerStyle.actionSheet)
		
		alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {UIAlertAction in
			
			if let checkURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
				
				self.open(url: checkURL)
			} else {
				print("invalid url")
			}
			alert.dismiss(animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.default, handler: { UIAlertAction in 
			alert.dismiss(animated: true, completion: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func open(url: URL) {
		
		if #available(iOS 10, *)
		{
			UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
				print("Open \(url): \(success)")
			})
		}
		else
		{
			if UIApplication.shared.openURL(url){
				print("Open \(url):")
			}
		}
	}
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Function to convert the color
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
