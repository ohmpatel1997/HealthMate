//
//  InvoiceComposer.swift
//  HealthMate
//
//  Created by Mac on 28/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {
	
	let pathtoinvoice = Bundle.main.path(forResource: "invoice", ofType: "html")
	let pathToSingleItemHTML = Bundle.main.path(forResource: "singleitem", ofType: "html")
	let pathtoinvoicePP = Bundle.main.path(forResource: "invoicePP", ofType: "html")
	let pathToSingleItemHTMLPP = Bundle.main.path(forResource: "singleitemPP", ofType: "html")
	static var sender:String = ""
	
	var pdfFilename:String = ""
	var dateformatter:DateFormatter!
	
	override init() {
		super.init()
		self.dateformatter = DateFormatter()
		self.dateformatter.dateFormat = "dd/MM/yyyy"
				
	}
	
	func renderInvoice(dataobj: [[String: String]],profiledataobj:[String:String],initialdate:String,finaldate:String) -> String! {
		
	
			let startdate = self.dateformatter.date(from: initialdate)
			let enddate = self.dateformatter.date(from: finaldate)
		
		do {
			
			if InvoiceComposer.sender == "bloodpressure"{
			// Load the invoice HTML template code into a String variable.
			var HTMLContent = try String(contentsOfFile: pathtoinvoice!)
			
			// Replace all the placeholders with real values except for the items.
			
			// Invoice number.
			HTMLContent = HTMLContent.replacingOccurrences(of:"#name#", with:profiledataobj["first_name"]! + profiledataobj["last_name"]!)
			
			// Report date.
			
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.dateFormat = "dd-MM-yyyy"
			let date = formatter.string(from: Date())
			HTMLContent = HTMLContent.replacingOccurrences(of:"#reportdate#", with:date)
			
			
			
			// Gender.
			HTMLContent = HTMLContent.replacingOccurrences(of:"#gender#", with:profiledataobj["gender"]!)
			
			// Report Time.
			
			let date1 = Date()
			let calendar = Calendar.current
			let hour = calendar.component(.hour, from: date1)
			let minutes = calendar.component(.minute, from: date1)
			HTMLContent = HTMLContent.replacingOccurrences(of: "#reporttime#", with: "\(hour):\(minutes)")
				
			//period
				HTMLContent = HTMLContent.replacingOccurrences(of: "#period#", with: initialdate + "-" + finaldate)
			
			var allitems = ""
			
			for i in 0..<dataobj.count{
				
				var itemHTMLContent: String!
				itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTML!)
				let tempdate = self.dateformatter.date(from: dataobj[i]["MSR_TS"]!)
				
				if (tempdate?.isbetween(date:startdate! ,anddate:enddate!))!{ 
					
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#date#", with: dataobj[i]["MSR_TS"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#time#", with: dataobj[i]["MSR_TSTime"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#diastolic#", with: dataobj[i]["PM2_value"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#systolic#", with: dataobj[i]["PM1_value"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#pulse#", with: dataobj[i]["PM3_value"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#position#", with: dataobj[i]["MSR_position"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#location#", with: dataobj[i]["MSR_location"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#remark#", with: dataobj[i]["MSR_remarks"]!)
			
					allitems += itemHTMLContent
				}	
				
			}
			HTMLContent = HTMLContent.replacingOccurrences(of: "#items#", with: allitems)
			return HTMLContent
	
		}else{
			
				// Load the invoice HTML template code into a String variable.
				var HTMLContent = try String(contentsOfFile: self.pathtoinvoicePP!)
				
				// Replace all the placeholders with real values except for the items.
				// Invoice number.
				HTMLContent = HTMLContent.replacingOccurrences(of:"#name#", with:profiledataobj["first_name"]! + profiledataobj["last_name"]!)
				
				// Report date.
				let formatter = DateFormatter()
				formatter.dateStyle = .medium
				formatter.dateFormat = "dd-MM-yyyy"
				let date = formatter.string(from: Date())
				HTMLContent = HTMLContent.replacingOccurrences(of:"#reportdate#", with:date)
				// Gender.
				HTMLContent = HTMLContent.replacingOccurrences(of:"#gender#", with:profiledataobj["gender"]!)
				
				// Report Time.
				
				let date1 = Date()
				let calendar = Calendar.current
				let hour = calendar.component(.hour, from: date1)
				let minutes = calendar.component(.minute, from: date1)
				HTMLContent = HTMLContent.replacingOccurrences(of: "#reporttime#", with: "\(hour):\(minutes)")
				
				//period
				HTMLContent = HTMLContent.replacingOccurrences(of: "#period#", with: initialdate + "-" + finaldate)
				
				var allitems = ""
				for i in 0..<dataobj.count{
					
					var itemHTMLContent: String!
					itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLPP!)
					
					let tempdate = self.dateformatter.date(from: dataobj[i]["MSR_date"]!)
					if (tempdate?.isbetween(date:startdate!, anddate: enddate!))!{
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#date#", with: dataobj[i]["MSR_date"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#fastingtime#", with: dataobj[i]["PM4_time"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#fasting#", with: dataobj[i]["PM4_value"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#fastingremark#", with: dataobj[i]["PM4_remarks"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#pptime#", with: dataobj[i]["PM5_time"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#pp#", with: dataobj[i]["PM5_value"]!)
					itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ppremark#", with: dataobj[i]["PM5_remarks"]!)
					
					
					allitems += itemHTMLContent
					}
				}
				HTMLContent = HTMLContent.replacingOccurrences(of: "#items#", with: allitems)
				return HTMLContent
			}
		}catch {
				print("Unable to open and use HTML template files.")
			}
		return nil
	}
	func exportHTMLContentToPDF(HTMLContent: String,filename:String) {
		let printPageRenderer = CustomPrintPageRenderer()
		
		let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)    
		printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
		
		let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
		
		self.pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Report-\(filename).pdf"
		
		pdfData?.write(toFile: pdfFilename, atomically: true)
		
		print(pdfFilename)
	}	
	func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
		let data = NSMutableData()
		
		UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
		
		UIGraphicsBeginPDFPage()
		
		printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
		
		UIGraphicsEndPDFContext()
		
		return data
	}
}
extension Date{
	func isbetween(date date1:Date , anddate date2: Date) -> Bool{
		return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
	}
}
