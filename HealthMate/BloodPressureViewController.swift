//
//  BloodPressureViewController.swift
//  HealthMate
//
//  Created by Mac on 16/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class BloodPressureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{

    
	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var EditingBackgroundView: UIView!
	
	@IBOutlet weak var Time: UITextField!
	@IBOutlet weak var systolic: UITextField!
	@IBOutlet weak var dialostic: UITextField!
	@IBOutlet weak var pulse: UITextField!
	@IBOutlet weak var date: UITextField!
	@IBOutlet weak var location: UITextField!
	@IBOutlet weak var positon: UITextField!
	@IBOutlet weak var note: UITextField!
	@IBOutlet weak var addreading: UIButton!
	
	@IBOutlet weak var lowerview: UIView!
	
	var realm:Realm!
	var cell:bpcell!
	var dataobj:[[String:String]] = []
	var profiledataobj:[String:String] = [:]
	var BP_Master_obj:BP_Master!
	var profileobj:ProfileViewController!
	var picker:UIPickerView! 
	var toolbar:UIToolbar!
	var datepicker:UIDatePicker!
	var timepicker:UIDatePicker!
	let positionarray:[String] = ["Standing","Sleeping","Seated","Reclined"]
	let locationarray:[String] = ["Right Wrist","Left Wrist","Right Arm","Left Arm","Right Leg","Left Leg"]
	var profileid:String = ""
	var msrid:Int = 0
	var alert:UIAlertController!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.systolic.text = "0"
		self.dialostic.text = "0"
		self.pulse.text = "0"
		
        //tap on view
        
        
		
		
        print("profile in bloodpressure", profileid)
        self.realm = try! Realm()
		fetchdatatoarray()
		
		picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:self.view.frame.size.width, height: 220))
		
		datepicker = UIDatePicker()
		datepicker.datePickerMode = .date
		datepicker.addTarget(self, action: #selector(datepickervaluechanged), for: .valueChanged)
		
		timepicker = UIDatePicker()
		timepicker.datePickerMode = .time
		timepicker.addTarget(self, action: #selector(timepickervaluechanged), for: .valueChanged)
		
		//Initialising Toolbar
		toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:  self.view.frame.size.width, height: 40.0))
		toolbar?.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
		toolbar?.barStyle = UIBarStyle.default		
		toolbar?.tintColor = UIColor.black		
		toolbar?.backgroundColor = UIColor.gray		
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donebarbuttonclicked))
		toolbar?.setItems([doneButton], animated: true)
				
		
			tableview.delegate = self
			tableview.dataSource = self
			self.EditingBackgroundView.isHidden = true
			self.tableview.isHidden = false
			self.EditingBackgroundView.isHidden = true
			self.picker.delegate = self
			self.picker.dataSource = self
				
			lowerborderimplementation(text: self.date)
			lowerborderimplementation(text: self.Time)
			lowerborderimplementation(text: self.location)
			lowerborderimplementation(text: self.positon)
			lowerborderimplementation(text: self.note)
			lowerborderimplementation(text: self.systolic)
			lowerborderimplementation(text: self.dialostic)
			lowerborderimplementation(text: self.pulse)
		
		// initialize the alert controller for export pdf
		
		alert = UIAlertController(title: "Please enter the duration", message: "", preferredStyle: UIAlertControllerStyle.alert)
		
		alert.addTextField(configurationHandler: { 
			(initialdate) in initialdate.placeholder = "Enter the initial date"
			initialdate.inputView = self.datepicker
			initialdate.inputAccessoryView = self.toolbar
		})
        
		alert.addTextField(configurationHandler: { 
			(finaldate) in finaldate.placeholder = "Enter the final date"
			finaldate.inputAccessoryView = self.toolbar
			finaldate.inputView = self.datepicker
		})
		
		let action1 = UIAlertAction(title: "Export", style: .default, handler: generatepressed)
		let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: { 
			_ in self.alert.dismiss(animated: true, completion: nil)
		})
		alert.addAction(action1)
		alert.addAction(action2)
		
		//remove table view cell separator 
		
		self.tableview.separatorStyle = .none
	
	}
    
    
	func donebarbuttonclicked(){
		
		self.date.resignFirstResponder()
		self.positon.resignFirstResponder()
		self.location.resignFirstResponder()
		self.alert.textFields?[0].resignFirstResponder()
		self.alert.textFields?[1].resignFirstResponder()
		self.view.endEditing(true)
	}
	
	func datepickervaluechanged(){
		
		let formater = DateFormatter()
		formater.dateFormat  = "dd MMM, yyyy"	
		//formater.timeStyle = .none
		formater.locale = Locale(identifier: "en_US_POSIX")
		formater.timeZone = TimeZone(secondsFromGMT: 0)
		if self.date.isFirstResponder{
			self.date.text = formater.string(from: datepicker.date)
			return
		}
		if (self.alert.textFields?[0].isFirstResponder)!{
			self.alert.textFields?[0].text = formater.string(from: datepicker.date)
			return
		}
		if (self.alert.textFields?[1].isFirstResponder)!{
			self.alert.textFields?[1].text = formater.string(from: datepicker.date)
			return
		}
	
	}
	func timepickervaluechanged(){
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		self.Time.text = formatter.string(from: timepicker.date)
	}
	
	@IBAction func dateselected(_ sender: Any) {
		self.date.inputView = self.datepicker
		self.date.inputAccessoryView = self.toolbar
	
	}
	@IBAction func timeselected(_ sender: Any) {
		self.Time.inputView = self.timepicker
		self.Time.inputAccessoryView = self.toolbar
	}
	@IBAction func position(_ sender: Any) {
		self.positon.inputView = self.picker
		self.positon.inputAccessoryView = self.toolbar
		
	}
	@IBAction func location(_ sender: Any) {
		self.location.inputView = self.picker
		self.location.inputAccessoryView = self.toolbar
		
	}
	
	
	func fetchdatatoarray(){
		
		dataobj.removeAll()
		let objs = realm.objects(BP_Master.self).filter("profile_ID = \(Int(self.profileid)!)")
		
		var temp:[String:String] = [:]
		
		if objs.count > 0{
			
			for i in objs{
			
				temp = [
						"MSR_id": "\(i.MSR_id)",
						"PM1_value":i.PM1_value,
						"PM2_value":i.PM2_value,
						"PM3_value":i.PM3_value,
						"MSR_TS":  i.MSR_TS,
						"MSR_TSTime": i.MSR_TSTime,
						"MSR_location":i.MSR_location,
						"MSR_position":i.MSR_position,
						"MSR_remarks":i.MSR_remarks]
					
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
		
		
		self.BP_Master_obj = BP_Master()
		self.BP_Master_obj.insertintoBP_Master(
			
					MSR_id: msrid, 
					profile_id: Int(self.profileid)!, 
					PM1_value:self.systolic.text! ,
					PM2_value: self.dialostic.text!,
					PM3_value: self.pulse.text!,
					MSR_TS: self.date.text!,
					MSR_location: self.location.text!,
					MSR_position: self.positon.text!, 
					MSR_remarks: self.note.text!,
					MSR_TSTime: self.Time.text!)
		
		try! realm.write {
			realm.add(  BP_Master_obj, update: true)
			print("successfully written")
		}

		UIView.transition(with: EditingBackgroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
					self.EditingBackgroundView.isHidden = true
					self.tableview.isHidden = false
			}, completion: { _ in 
				self.fetchdatatoarray()
				self.tableview.reloadData()
				self.date.text = ""
				self.systolic.text = ""
				self.dialostic.text = ""
				self.pulse.text = ""
				self.note.text = ""
				self.Time.text = ""
				self.positon.text = ""
				self.location.text = ""
				self.lowerview.isHidden = false
                self.view.endEditing(true)
			})
		
	}
	
	func validatefields() -> Bool{
		
		if (self.date.text?.isEmpty)!{
			return false
		}else if (self.Time.text?.isEmpty)!{
			return false
		}else if (self.systolic.text?.isEmpty)! && (self.dialostic.text?.isEmpty)! && (self.pulse.text?.isEmpty)!{
			return false
		}else{
			return true
		}
		
	}
	@IBAction func cancelpressed(_ sender: Any) {
		
		UIView.transition(with: EditingBackgroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			
			self.EditingBackgroundView.isHidden = true
			self.tableview.isHidden = false
			self.lowerview.isHidden = false
            self.date.text = ""
            self.systolic.text = ""
            self.dialostic.text = ""
            self.pulse.text = ""
            self.note.text = ""
            self.Time.text = ""
            self.positon.text = ""
            self.location.text = ""
            self.view.endEditing(true)
		})				

	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataobj.count	
		 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		
		cell =  tableview.dequeueReusableCell(withIdentifier: "bpcell", for: indexPath) as! bpcell
        cell.selectionStyle = .none
		if dataobj.count > 0{	
		
			cell?.date.text = dataobj[indexPath.item]["MSR_TS"]
			cell?.dialostic.text = dataobj[indexPath.item]["PM2_value"]
			cell?.systolic.text = dataobj[indexPath.item]["PM1_value"]
			cell?.pulse.text = dataobj[indexPath.item]["PM3_value"]
			cell?.time.text = dataobj[indexPath.item]["MSR_TSTime"]
		}
		return cell
	} 
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == UITableViewCellEditingStyle.delete{
			
			if dataobj.count > 0{
				
				let msrid = Int(dataobj[(indexPath.row)]["MSR_id"]!)
				try! realm.write {
					realm.delete(realm.object(ofType: BP_Master.self, forPrimaryKey: msrid)!)
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
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
        
		self.msrid = Int(dataobj[indexPath.row]["MSR_id"]!)!
		//tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.1)
        
		EditingBackgroundView.isHidden = false
		UIView.transition(with: EditingBackgroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
	
			self.EditingBackgroundView.isHidden = false 
			self.tableview.isHidden = true
			self.date.text = self.dataobj[indexPath.row]["MSR_TS"]
			self.Time.text = self.dataobj[indexPath.row]["MSR_TSTime"]
			self.location.text = self.dataobj[indexPath.row]["MSR_location"]
			self.positon.text = self.dataobj[indexPath.row]["MSR_position"]
			self.note.text = self.dataobj[indexPath.row]["MSR_remarks"]
			self.pulse.text = self.dataobj[indexPath.row]["PM3_value"]
			self.systolic.text = self.dataobj[indexPath.row]["PM1_value"]
			self.dialostic.text = self.dataobj[indexPath.row]["PM2_value"]
			self.lowerview.isHidden = true
			})
		}
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
        
    
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if self.positon.isFirstResponder{
			return positionarray.count
		}else if self.location.isFirstResponder{
			return locationarray.count
		}else{
			
			print("No picker view rows")
			return 1
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if self.positon.isFirstResponder{
			return positionarray[row]
		}else if self.location.isFirstResponder{
			return locationarray[row]
		}
		return "No values Found"
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if self.positon.isFirstResponder{
			self.positon.text = positionarray[row]
		}else if self.location.isFirstResponder{
			self.location.text = locationarray[row]
		}
	}
	
	
	@IBAction func AddReading(_ sender: Any) {
		
		self.BP_Master_obj = BP_Master()
		self.msrid = BP_Master_obj.IncrementID()
		EditingBackgroundView.isHidden = false
		UIView.transition(with: EditingBackgroundView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { _ in 
			self.EditingBackgroundView.isHidden = false 
			self.tableview.isHidden = true
			self.lowerview.isHidden = true
		})

	
	}
	
	func lowerborderimplementation(text:UITextField){
		text.borderStyle = .none
		text.layer.backgroundColor = hexStringToUIColor(hex: "00cc00").cgColor
		text.layer.masksToBounds = false
		text.layer.shadowColor = UIColor.white.cgColor
		text.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		text.layer.shadowOpacity = 1.0
		text.layer.shadowRadius = 0.0
		
	}
	
	@IBAction func viewgraphtapped(_ sender: Any) {
		performSegue(withIdentifier: "toBPgraph", sender: self)
		
	}
	@IBAction func exporttapped(_ sender: Any) {
		
		
		self.present(alert, animated: true, completion: nil)
	}
	func generatepressed(action:UIAlertAction ){
		
		performSegue(withIdentifier: "toBPpdf", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "toBPgraph"{
				print("<<<<<<<-----BPGRAPH------>>>>>>")
				let VC = segue.destination as! GraphViewController
				VC.dataobj = self.dataobj
				VC.GraphTitle = "Blood Pressure Management"
				VC.temp1 = "Systolic"
				VC.temp2 = "Dialostic"
				VC.temp3 = "Pulse"
				VC.ishidden = false
			return
		}
		if segue.identifier == "toBPpdf"{
			print("<<<<<<<<--------toBPpdf---------->>>>>")
			let VC = segue.destination as! PreviewViewController
			VC.profiledataobj = self.profiledataobj
			VC.dataobj = self.dataobj
			InvoiceComposer.sender = "bloodpressure"
			VC.initialdate = (self.alert.textFields?[0].text)!
			VC.finaldate = (self.alert.textFields?[1].text)!
			return
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		
	}
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
		
		
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
