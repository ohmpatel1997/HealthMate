//
//  RegistrationViewController.swift
//  HealthMate
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class RegistrationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource	,UITextFieldDelegate{
	
	
	
	//IBOutlets
	@IBOutlet weak var dateofbirth: UITextField!
	@IBOutlet weak var Relaton: UITextField!
	@IBOutlet weak var city: UITextField!
	@IBOutlet weak var mobile: UITextField!
	@IBOutlet weak var country: UITextField!
	@IBOutlet weak var emailid: UITextField!
	@IBOutlet weak var firstname: UITextField!
	@IBOutlet weak var Middlename: UITextField!
	@IBOutlet weak var Lastname: UITextField!
	@IBOutlet weak var bloodgroup: UITextField!
	@IBOutlet weak var gender: UITextField!
	@IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var pincode: UITextField!
	
	var picker = UIPickerView()
	var datepicker = UIDatePicker()
	var toolBar:UIToolbar?
	var currenttextfield:UITextField?
	var paths:NSString!
	var fileManager:FileManager!
	var id:Int = 0
	var profileid:String = ""
	var realm:Realm!
	var templabel:UILabel!
	var dataobj:[String:String] = [:]
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		self.fileManager = FileManager.default
		paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) as NSString
		
		
		do{
			
			self.realm = try Realm()
			
		}catch{
			print("Sorry...Cannot connect to the database")
			
			let alert = UIAlertController(title: nil, message: "Cannot connect to the database", preferredStyle: UIAlertControllerStyle.alert)
			self.present(alert, animated: true, completion: nil)
			
			// duration in seconds
			let duration: Double = 1				
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
			}	
			
			return 
		}
		
		//manipulating profileimage
		self.profileimage.layer.cornerRadius = self.profileimage.frame.width / 2
		self.profileimage.layer.borderColor = hexStringToUIColor(hex: "00CC00").cgColor
		self.profileimage.layer.borderWidth = 1
		self.profileimage.backgroundColor = UIColor.clear
		templabel = UILabel(frame: profileimage.bounds)
		templabel.text = "Photo"
		templabel.textAlignment = .center
		templabel.alpha = 0.2	
		profileimage.addSubview(templabel)
		
		//Fetching the details if prfofile editing is goin	g
		
		if !self.dataobj.isEmpty{
			self.firstname.text = self.dataobj["first_name"]
			self.Middlename.text = self.dataobj["middle_name"]
			self.Lastname.text = self.dataobj["last_name"]
			self.bloodgroup.text = self.dataobj["blood_group"]
			self.city.text = self.dataobj["city"]
			self.country.text = self.dataobj["Country"]
			self.dateofbirth.text = self.dataobj["DOB"]
			self.emailid.text = self.dataobj["email"]
			self.gender.text = self.dataobj["gender"]
			self.mobile.text = self.dataobj["mobile_no"]
			self.pincode.text = self.dataobj["pin_code"]
			self.Relaton.text = self.dataobj["gender"]
			self.profileimage.contentMode = .scaleToFill
			self.profileimage.image = fetchData(nameImage: self.dataobj["profile_image_path"]!)
			self.profileimage.clipsToBounds = true
			
			self.dataobj = [:]
		}
		
		
		
		
		//tap gesture on View
		let tapgestureonview = UITapGestureRecognizer(target: self, action: #selector(donebarbuttonclicked))
		self.view.addGestureRecognizer(tapgestureonview)
		
		picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:self.view.frame.size.width, height: 220))
		
		
		
		//Setting Delegates
		
		picker.delegate = self
		picker.dataSource = self
		firstname.delegate = self
		Middlename.delegate = self
		Lastname.delegate = self
		mobile.delegate = self
		pincode.delegate = self  
		
		 
				
		//adding tapgesture to profile image
		let tapgesture = UITapGestureRecognizer(target: self, action: #selector(profileimagetouched))
		self.profileimage.addGestureRecognizer(tapgesture)
	
		
		//Initialising Toolbar
		toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width:  self.picker.frame.size.width, height: 40.0))
        toolBar?.sizeToFit()
		toolBar?.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height)
		toolBar?.barStyle = UIBarStyle.default		
		toolBar?.tintColor = UIColor.black		
		toolBar?.backgroundColor = UIColor.gray		
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donebarbuttonclicked))
		toolBar?.setItems([doneButton], animated: true)
		
		
		
		//Manupulating the navigation bar
		self.navigationController?.navigationBar.barStyle = .default
		self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "00CC00")
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelpressed))
		self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savepressed))
		self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal) 
	
		
		
		
		
		
		
		//Lower Borders on Textfields
		
		lowerborderimplementation(text: firstname)
		lowerborderimplementation(text: Middlename)
		lowerborderimplementation(text: Lastname)
		lowerborderimplementation(text: dateofbirth)
		lowerborderimplementation(text: city)
		lowerborderimplementation(text: pincode)
		lowerborderimplementation(text: bloodgroup)
		lowerborderimplementation(text: emailid)
		lowerborderimplementation(text: mobile)
		lowerborderimplementation(text: Relaton)
		lowerborderimplementation(text: gender)
		lowerborderimplementation(text: country)
		
	/*	//DropDown Image 
		
		ImplementTextFieldDropDownImage(text: gender)
		ImplementTextFieldDropDownImage(text: bloodgroup)
		ImplementTextFieldDropDownImage(text:Relaton)
		ImplementTextFieldDropDownImage(text: dateofbirth) */
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		print("STACK registration", self.navigationController?.viewControllers)
		
		//hiding the "photo" label when profile image is selected
		if self.profileimage.image == nil{
			self.templabel.isHidden = false
		}else{
			self.templabel.isHidden = true
		}
		
		//Changing the title for navigation bar
		if self.navigationController?.viewControllers.count == 2{
			self.title = "New Profile"
		}else{
			self.title = "Edit Profile"
		}
	}
	
	deinit{
		print("deinitialized it")
	}
	
	func donebarbuttonclicked(){
		
		gender.resignFirstResponder()
		bloodgroup.resignFirstResponder()
		gender.resignFirstResponder()
		self.view.endEditing(true)
		
	
	}
		
	func profileimagetouched(){
		
		let alert : UIAlertController = UIAlertController(title: "Select image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		
		alert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: {_ in self.opengallery()}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in NSLog("cancel pressed")}));
		alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
			self.opencamera()}))
		self.present(alert, animated: true, completion: nil)

	}
	
	func opencamera(){
			let imagepicker = UIImagePickerController()
			imagepicker.allowsEditing = false
			imagepicker.sourceType = .camera
			//imagepicker?.delegate = self
			imagepicker.delegate = self 
			imagepicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
			//imagepicker?.popoverPresentationController?.sourceView = self.view
			present(imagepicker, animated: true, completion: nil)
		}
	
	
	func opengallery()  {
		
		//imagepicker.delegate = self
		let imagepicker = UIImagePickerController()
		imagepicker.allowsEditing = true
		imagepicker.sourceType = .photoLibrary
		//imagepicker?.delegate = self
		imagepicker.delegate = self 
		imagepicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
		//imagepicker?.popoverPresentationController?.sourceView = self.view
		present(imagepicker, animated: true, completion: nil)
		
	}
	
	//ImagePicker Delegate methods
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		
		picker.dismiss(animated:true, completion: nil)
	}
	
	func imagePickerController(_ imagepicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		let selectedphoto = info[UIImagePickerControllerOriginalImage] as? UIImage 
		if((selectedphoto) != nil){	
			
				
			self.profileimage.contentMode = .scaleToFill
			self.profileimage.image = selectedphoto
			self.profileimage.clipsToBounds = true
			self.templabel.isHidden = true
			imagepicker.dismiss(animated: true, completion: nil)
			
		}
	}

	
	
	
	
	
	
	@IBAction func gendertextviewselected(_ sender: Any) {
		currenttextfield = sender as? UITextField
		self.gender.inputView = picker
        self.gender.inputAccessoryView = toolBar
	}
	
	@IBAction func bloodtextviewselected(_ sender: Any) {
		currenttextfield = sender as? UITextField
		self.bloodgroup.inputView = picker
        self.bloodgroup.inputAccessoryView = toolBar
	}
	@IBAction func relationtextviewselected(_ sender: Any) {
		currenttextfield = sender as? UITextField
		self.Relaton.inputView = picker
		self.Relaton.inputAccessoryView = toolBar
	}
	
	
	let genderarray = ["Gender","Male","Female"]
	let bloodgrouparray = ["Blood Group","A+","B+","AB+","O+","O-","A-","B-","AB-"]
	let relationarray = ["Relation","self","Husband","Wife","Father","Mother","Grandfather","Grandmother","Uncle","Aunt","Brother","Sister","Son","Daughter","Cousin","Nephew","Niece","Friend"]
	
	
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch currenttextfield{
		case gender as UITextField:
				return genderarray.count
		case bloodgroup as UITextField:
				return bloodgrouparray.count
		case Relaton as UITextField:
				return relationarray.count
		default:
			print("Invalid number of rows")
			return 0
		}
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	switch currenttextfield{
		case gender as UITextField:
			return genderarray[genderarray.index(0, offsetBy: row)]
		case bloodgroup as UITextField:
			return bloodgrouparray[genderarray.index(0, offsetBy: row)]
		case Relaton as UITextField:
			return relationarray[relationarray.index(0, offsetBy: row)]
		default:
			print("Invalid title")
			return "0"
		}
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch currenttextfield{
		case gender as UITextField:
			self.gender.text = genderarray[row]
		case bloodgroup as UITextField:
			self.bloodgroup.text = bloodgrouparray[row]
		case Relaton as UITextField:
			self.Relaton.text = relationarray[row]
		default:
			print("Invalid selection")
			
		}
	}
	
	//Text Fields Lower border Implementation
	
	func lowerborderimplementation(text:UITextField){
		text.borderStyle = .none
		text.layer.backgroundColor = UIColor.white.cgColor
		
		text.layer.masksToBounds = false
		text.layer.shadowColor = UIColor.gray.cgColor
		text.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		text.layer.shadowOpacity = 1.0
		text.layer.shadowRadius = 0.0

	}
	/*func ImplementTextFieldDropDownImage(text:UITextField){
		
		let imgViewForDropDown = UIImageView()
		imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
		imgViewForDropDown.image = #imageLiteral(resourceName: "dropdown")
		text.rightView = imgViewForDropDown
		text.rightViewMode = .always
		text.rightView?.backgroundColor = UIColor.lightText	
		text.rightView?.layer.cornerRadius = 7
		text.rightView?.alpha = 0.3
	}*/
	@IBAction func dateofbirthselected(_ sender: UITextField) {
		let datepicker = UIDatePicker()
		datepicker.datePickerMode = .date
		datepicker.backgroundColor = UIColor.lightGray
		sender.inputView = datepicker
		sender.inputAccessoryView = self.toolBar
		datepicker.addTarget(self, action: #selector(datepickervaluechanged(sender:)), for: UIControlEvents.allEvents)
	}
	
	func datepickervaluechanged(sender: UIDatePicker){
		
		let formater = DateFormatter()
		formater.dateFormat = "dd/MM/yyyy"
		dateofbirth.text = formater.string(from: sender.date)	
	}
	
	

	func cancelpressed(){
		if presentingViewController == nil{
			self.navigationController?.popToRootViewController(animated: true)
		}else{
			self.dismiss(animated: true, completion: { _ in 
				self.navigationController?.popToRootViewController(animated: true)})
		}
	}
	
	
	
	func savepressed() {

		guard validatename(name: firstname.text!) && validatename(name: Middlename.text!) && validatename(name: Lastname.text!) && validatepin(pin: pincode.text!) && validatephone(phone: mobile.text!) && validateemail(email: emailid.text!) && validateothers() 
			
		else {
			
			let alert = UIAlertController(title: nil, message: "Pleasse Enter All the Valid Details", preferredStyle: UIAlertControllerStyle.actionSheet)
			self.present(alert, animated: true, completion: nil)
			// duration in seconds
			let duration: Double = 1				
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
			}	
			return 
		}

		let profile_master_obj = Profile_Master()
		
		if (self.navigationController?.viewControllers.count == 3){
			self.id = Int(self.profileid)!
		}else{
			self.id =   profile_master_obj.IncrementID() 
		}
		print("idddd = ", id)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
		let date = dateFormatter.date(from: dateofbirth.text!)
		
		let imagename = NSDate().description
		self.paths = self.paths.appendingPathComponent(imagename) as NSString
		
		print("image saved at path", paths)
		
		let imageData: Data!
		
		if let image = self.profileimage.image{
			imageData = UIImagePNGRepresentation(image)
		}else{
			imageData = UIImagePNGRepresentation(UIImage())
		}
		
		fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
		
		
		 profile_master_obj.insertintoProfile_master(
			
				profile_id:  id, first_name:  firstname.text!, middlename:  Middlename.text!, lastname:Lastname.text!, DOB:   date!, gender:  gender.text!, relation:  Relaton.text!, bloodgroup:  bloodgroup.text!,  mobile_no:  mobile.text!, email_id:  emailid.text!, city:  city.text!, country:  country.text!, pincode:  pincode.text!, status: "A",profile_image_path: imagename 
				)
		
			try! self.realm.write {
		
				self.realm.add(profile_master_obj, update: true)
				print("write successfully")
					
			}					
				
				
		 
			print("root view pooped")
			self.navigationController?.popToRootViewController(animated: true)

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.view.endEditing(true)
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
	
	
	
	//VALIDATIONS FOR TEXTFIELDS
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		guard ValidateAllFields(textField:textField) else{
			print("information enterd in text fields is invalid")
			return 
		}
	}
	
	func ValidateAllFields(textField:UITextField) -> Bool{
		
		if textField == firstname || textField == Middlename || textField == Lastname {
			
			if !(validatename(name: textField.text!)){
				let message = "Invalid Name."
				let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
				self.present(alert, animated: true)
	
				// duration in seconds
				let duration: Double = 1				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
				textField.text = ""
				}
			
			return false
			
			}else{
				return true
			}
		}
	
	
		if textField == emailid{
			
			if !(validateemail(email: textField.text!)){
				let message = "Invalid Email ID."
				let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
				self.present(alert, animated: true)
	
				// duration in seconds
				let duration: Double = 1				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
				}		
				textField.text=""
				return false
			}else{
				return true
			}
		}
		
	
		if textField == mobile{
			
			if !validatephone(phone: textField.text!){
				let message = "Invalid Phone Number."
				let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
				self.present(alert, animated: true)
	
				// duration in seconds
				let duration: Double = 1				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
				}				
			
				mobile.text=""
				return false
			}else{
				return true
			}
			
		}
		
		if textField == pincode{
	
			if !(validatepin(pin: textField.text!)){
			
				let message = "Invalid PIN Number."
				let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
				self.present(alert, animated: true)
	
				// duration in seconds
				let duration: Double = 1				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
				alert.dismiss(animated: true)
				}		
			textField.text=""
				return false
			}else{
				return true
			}
		}
	return true
		
	}
	func validateothers() -> Bool{
		if (!(dateofbirth.text?.isEmpty)! || !(gender.text?.isEmpty)! || !(Relaton.text?.isEmpty)! || !(bloodgroup.text?.isEmpty)! || !(city.text?.isEmpty)! || !(country.text?.isEmpty)!){
			
			return true		
		}else {
			return false
		}
	}
	func validatename(name:String) -> Bool {
		let format = "[a-zA-Z]{3,30}"
		let emailpredicate = NSPredicate(format: "SELF MATCHES[c] %@", format)
		return Bool(emailpredicate.evaluate(with: name))
	}
	func validateemail(email:String)->Bool{
		let format = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailpredicate = NSPredicate(format: "SELF MATCHES[c] %@", format)
		return Bool(emailpredicate.evaluate(with: email))
	}
	
	func validatephone(phone:String) -> Bool {
		let format = "[0-9]{10}"
		let phonepredicate = NSPredicate(format: "SELF MATCHES[c] %@", format)
		return Bool(phonepredicate.evaluate(with: phone))
	}
	func validatepin(pin:String) -> Bool{
		let format = "[0-9]{6}"
		let pinpredicate = NSPredicate(format: "SELF MATCHES[c] %@", format)
		return Bool(pinpredicate.evaluate(with: pin))
	}
	
	//Function to fetch the profile image 
	func fetchData(nameImage : String) -> UIImage{
		
		let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		print("docDir",docDir)
		
		let filePath = docDir.appendingPathComponent(nameImage);
		
		print("filepath", filePath)	
		
		if let containOfFilePath = UIImage(contentsOfFile : filePath.path){
			
			return containOfFilePath;
		}
		print("image does not exist")
		return UIImage();
	}




}
