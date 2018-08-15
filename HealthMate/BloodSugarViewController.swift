 //
//  BloodSugarViewController.swift
//  HealthMate
//
//  Created by Mac on 18/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class BloodSugarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var EditingBackGroundView: UIView!
	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var date: UITextField!
	@IBOutlet weak var fastingtime: UITextField!
	@IBOutlet weak var fasting: UITextField!
	@IBOutlet weak var pptime: UITextField!
	@IBOutlet weak var notepp: UITextField!
	@IBOutlet weak var notefasting: UITextField!
	@IBOutlet weak var pp: UITextField!
    
    @IBOutlet weak var lowerview: UIView!
    var cell:bscell!
	var datepicker:UIDatePicker!
	var fastingtimepicker:UIDatePicker!
	var PPtimepicker:UIDatePicker!
	var toolbar: UIToolbar!
	var BS_Master_obj:BS_Master!
	var realm:Realm!
	var dataobj:[[String:String]] = []
	var profiledataobj:[String:String] = [:]
	var profileid:String = ""
	var MSR_id:Int = 0
	var alert:UIAlertController!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.fasting.text = "0"
		self.pp.text = "0"
        
		print("profile in bloodsugar", profileid)
		
		tableview.delegate = self
		tableview.dataSource = self
		
		self.EditingBackGroundView.isHidden = true
		
		self.realm = try! Realm()
		self.fetchdatatoarray()
		datepicker = UIDatePicker()
		datepicker.datePickerMode = .date
		datepicker.addTarget(self, action: #selector(datepickervaluechanged), for: .valueChanged)
		
		fastingtimepicker = UIDatePicker()
		fastingtimepicker.datePickerMode = .time
		fastingtimepicker.addTarget(self, action: #selector(fastingtimepickervaluechanged), for: .valueChanged)
		
		PPtimepicker = UIDatePicker()
		PPtimepicker.datePickerMode = .time
		PPtimepicker.addTarget(self, action: #selector(PPtimepickervaluechanged), for: .valueChanged)
		
		//Initialising Toolbar
		toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:  self.view.frame.size.width, height: 40.0))
		toolbar?.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
		toolbar?.barStyle = UIBarStyle.default		
		toolbar?.tintColor = UIColor.black		
		toolbar?.backgroundColor = UIColor.gray		
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donebarbuttonclicked))
		toolbar?.setItems([doneButton], animated: true)

		
		lowerborderimplementation(text: date)
        lowerborderimplementation(text: fastingtime)
		lowerborderimplementation(text: fasting)
		lowerborderimplementation(text: pptime)
		lowerborderimplementation(text: notepp)
		lowerborderimplementation(text: notefasting)
		lowerborderimplementation(text: pp)
		
		// alert controller for export pdf
		
		self.alert = UIAlertController(title: "Please enter the duration ", message: "", preferredStyle: UIAlertControllerStyle.alert)
		alert.addTextField(configurationHandler: {
			
			(initialdate) in initialdate.placeholder = "start date"
			initialdate.inputView = self.datepicker
			initialdate.inputAccessoryView = self.toolbar
		})
		alert.addTextField(configurationHandler: { 
			(textfield) in textfield.placeholder = "End date"
			textfield.inputAccessoryView = self.toolbar
			textfield.inputView = self.datepicker
		})
		
		alert.addAction(UIAlertAction(title: "Generate", style: .default, handler: generatepressed))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
			_ in self.alert.dismiss(animated: true, completion: nil)
		}))

		//remove separator lines
		self.tableview.separatorStyle = .none
    }
   
	
	func donebarbuttonclicked(){
		self.date.resignFirstResponder()
		self.fastingtime.resignFirstResponder()
		self.pptime.resignFirstResponder()
		self.alert.textFields?[0].resignFirstResponder()
		self.alert.textFields?[1].resignFirstResponder()
		self.view.endEditing(true)
	}
	func datepickervaluechanged(){
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM, yyyy"
		if self.date.isFirstResponder {
			self.date.text = formatter.string(from: datepicker.date)
		}
		if (self.alert.textFields?[0].isFirstResponder)!{
			self.alert.textFields?[0].text = formatter.string(from: datepicker.date)
		}
		if (self.alert.textFields?[1].isFirstResponder)!{
			self.alert.textFields?[1].text = formatter.string(from: datepicker.date)
		}

	}
	func fastingtimepickervaluechanged(){
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		self.fastingtime.text = formatter.string(from: fastingtimepicker.date)
	}
	func PPtimepickervaluechanged(){
		
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		self.pptime.text = formatter.string(from: PPtimepicker.date)
		
	}

	@IBAction func date(_ sender: Any) {
		self.date.inputView = self.datepicker
		self.date.inputAccessoryView = self.toolbar
	}
	
	@IBAction func fastingtime(_ sender: Any) {
		self.fastingtime.inputView = self.fastingtimepicker
		self.fastingtime.inputAccessoryView = self.toolbar
	}
	@IBAction func PPtime(_ sender: Any) {
		self.pptime.inputView = self.PPtimepicker
		self.pptime.inputAccessoryView = self.toolbar
	}
	
	func fetchdatatoarray(){
		dataobj.removeAll()
		let objs = realm.objects(BS_Master.self).filter("profile_ID = \(Int(self.profileid)!)")
		var temp:[String:String] = [:]
		
		if objs.count > 0{
			
			for i in objs{
				
				temp = [
					"MSR_id": "\(i.MSR_id)",
					"PM4_value":i.PM4_value ,
					"PM4_time":i.PM4_time,
					"PM4_remarks":i.PM4_remarks,
					"PM5_value": i.PM5_value,
					"PM5_time": i.PM5_time,
					"PM5_remarks":i.PM5_remarks,
					"MSR_date":	String(describing: i.MSR_date)]		
				
				dataobj.append(temp)
			}
		}else{
			dataobj.removeAll()
		}
		print(dataobj)
	}
	@IBAction func SavePressed(_ sender: Any) {
		
		guard validatefields() == true else{
			
			let alert = UIAlertController(title: "", message: "Please Enter Atleast one Reading", preferredStyle: UIAlertControllerStyle.actionSheet)
			self.present(alert, animated: true, completion: nil)
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
				self.dismiss(animated: true, completion: nil)
			}
			return
		}
		BS_Master_obj = BS_Master()
		BS_Master_obj.insertintoBS_Master(
				
					MSR_id:MSR_id, 
					profile_id: Int(self.profileid)!,
					PM4_value: fasting.text!, 
					PM4_time: fastingtime.text!,
					PM4_remarks: notefasting.text!,
					PM5_value: pp.text!,
					PM5_time: pptime.text!,
					PM5_remarks: notepp.text!,
					MSR_date:self.date.text!)
		
		try! self.realm.write {
			realm.add(BS_Master_obj, update: true)
		}
		
		
		UIView.transition(with: EditingBackGroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			
			self.EditingBackGroundView.isHidden = true
			self.tableview.isHidden = false
			self.fetchdatatoarray()
			self.tableview.reloadData()
			self.MSR_id = 0
            self.lowerview.isHidden = false
            self.date.text = ""
            self.pptime.text = ""
            self.pp.text = ""
            self.fasting.text = ""
            self.fastingtime.text = ""
            self.notefasting.text = ""
            self.notepp.text = ""
            self.view.endEditing(true)
		})

	}
	
	@IBAction func cancelpressed(_ sender: Any) {
		UIView.transition(with: EditingBackGroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			
			self.EditingBackGroundView.isHidden = true
			self.tableview.isHidden = false
            self.lowerview.isHidden = false
            self.view.endEditing(true)
            self.date.text = ""
            self.pptime.text = ""
            self.pp.text = ""
            self.fasting.text = ""
            self.fastingtime.text = ""
            self.notefasting.text = ""
            self.notepp.text = ""
            
		})

		
	}

	func validatefields() -> Bool{
		if (self.date.text?.isEmpty)!{
			return false
		}else if (self.fasting.text?.isEmpty)! && (self.pp.text?.isEmpty)!{
			return false
		}else{
			return true
		}

	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataobj.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		cell = tableview.dequeueReusableCell(withIdentifier: "bscell", for: indexPath) as! bscell
		cell.date.text = dataobj[indexPath.row]["MSR_date"]
		cell.fasting.text = dataobj[indexPath.row]["PM4_value"]
		cell.timefasting.text = dataobj[indexPath.row]["PM4_time"]
		cell.pp.text = dataobj[indexPath.row]["PM5_value"]
		cell.timepp.text = dataobj[indexPath.row]["PM5_time"]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		self.BS_Master_obj = BS_Master()
		self.MSR_id = Int(dataobj[indexPath.row]["MSR_id"]!)!
		print("msrid = ",self.MSR_id)
		EditingBackGroundView.isHidden = false
		UIView.transition(with: EditingBackGroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			self.EditingBackGroundView.isHidden = false
			self.date.text = self.dataobj[indexPath.row]["MSR_date"]
            self.fastingtime.text = self.dataobj[indexPath.row]["PM4_time"]
            self.fasting.text = self.dataobj[indexPath.row]["PM4_value"]
            self.pp.text = self.dataobj[indexPath.row]["PM5_value"]
            self.pptime.text = self.dataobj[indexPath.row]["PM5_time"]
            self.notepp.text = self.dataobj[indexPath.row]["PM5_remarks"]
            self.notefasting.text = self.dataobj[indexPath.row]["PM4_remarks"]
            self.tableview.isHidden = true
            self.lowerview.isHidden = true
		})
		

	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete{
			if dataobj.count > 0{
				
				let msrid = Int(dataobj[(indexPath.row)]["MSR_id"]!)
				try! realm.write {
					realm.delete(realm.object(ofType: BS_Master.self, forPrimaryKey: msrid)!)
					print("deleted")
				}
			}

		}
		fetchdatatoarray()
		self.tableview.beginUpdates()
		print("count",	dataobj.count)
		tableview.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
		self.tableview.endUpdates()
		
	}
	
	@IBAction func addreading(_ sender: Any) {
		
		self.BS_Master_obj = BS_Master()
		self.MSR_id = BS_Master_obj.IncrementID()
		print(self.MSR_id)
		EditingBackGroundView.isHidden = false
		UIView.transition(with: EditingBackGroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			self.EditingBackGroundView.isHidden = false 
			self.tableview.isHidden = true
            self.lowerview.isHidden = true
		})

	}
	
	func lowerborderimplementation(text:UITextField){
		
		text.borderStyle = .none
		text.layer.backgroundColor = hexStringToUIColor(hex: "00cc00") .cgColor
		text.layer.masksToBounds = false
		text.layer.shadowColor = UIColor.white.cgColor
		text.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		text.layer.shadowOpacity = 1.0
		text.layer.shadowRadius = 0.0
		
	}
	@IBAction func viewgraphtapped(_ sender: Any) {
		performSegue(withIdentifier: "toBSgraph", sender: self)
	}
	
	@IBAction func exportreading(_ sender: Any) {
				
		self.present(alert, animated: true, completion: nil)
	}
	func generatepressed(action:UIAlertAction){
		
		performSegue(withIdentifier: "toBSpdf", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "toBSgraph"{
			
			let VC = segue.destination as! GraphViewController
			VC.dataobj = self.dataobj
			VC.GraphTitle = "Blood Sugar Management"
			VC.temp1 = "Fasting"
			VC.temp3 = "PP"
			VC.ishidden = true
			return
		}
		if segue.identifier == "toBSpdf"{
			print("<<<<<<<<--------toBSpdf---------->>>>>")
			let VC = segue.destination as! PreviewViewController
			VC.profiledataobj = self.profiledataobj
			VC.dataobj = self.dataobj
			InvoiceComposer.sender = "bloodsugar"
			VC.initialdate = (self.alert.textFields?[0].text!)!
			VC.finaldate = (self.alert.textFields?[1].text!)!
			return
		}
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	
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
    

}
