//
//  PreviewViewController.swift
//  HealthMate
//
//  Created by Mac on 28/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
	
	public var profiledataobj:[String:String] = [:]
	public var dataobj:[[String:String]] = []
	var initialdate:String = ""
	var finaldate:String = ""
	
	var invoicecomposer:InvoiceComposer! = InvoiceComposer()		
	var htmlcontent:String = ""

	@IBOutlet weak var webPreview: UIWebView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sharepressed(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = hexStringToUIColor(hex: "00CC00")
        
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "00CC00")
		
		
        // Do any additional setup after loading the view.
    }
	func sharepressed(sender:Any){
		
		
		
		
		
			let path = self.invoicecomposer.pdfFilename
			let data = NSData(contentsOfFile: path)
			let objectsToShare = [data]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			
			//New Excluded Activities Code
			activityVC.excludedActivityTypes = []
			//
			
			
			
			self.present(activityVC, animated: true, completion: nil)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func createInvoiceAsHTML() {
		
		if let invoiceHTML = self.invoicecomposer.renderInvoice(dataobj: self.dataobj, profiledataobj: self.profiledataobj,initialdate:initialdate,finaldate:finaldate){
			
			//self.webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoicecomposer.pathtoinvoice!)! as URL)
			htmlcontent = invoiceHTML
			 
			invoicecomposer.exportHTMLContentToPDF(HTMLContent: htmlcontent,filename:profiledataobj["first_name"]!)
			let request = URLRequest(url: URL(string: self.invoicecomposer.pdfFilename)! as URL)
			self.webPreview.loadRequest(request as URLRequest)
		}
		

		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		createInvoiceAsHTML()
		
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
