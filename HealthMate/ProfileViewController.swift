//
//  BloodPressureViewController.swift
//  HealthMate
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ProfileViewController: UIViewController{
	


	@IBOutlet weak var segmentedcontrol: UISegmentedControl!
	
	@IBOutlet weak var containerview: UIView!
	
	@IBOutlet weak var containerview2: UIView!

	var profileid:String = ""
	var dataobj:[String:String] = [:]
	
	var realm:Realm!
	
    
	override func viewDidLoad() {
        super.viewDidLoad()
		
		realm = try! Realm()
		print("profile id in profile",self.profileid)
	
		//Manupulating Navigation Bar
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backpressed))
		self.navigationItem.leftBarButtonItem?.tintColor = hexStringToUIColor(hex: "00CC00")
		let Edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(Editpressed))	
		navigationItem.rightBarButtonItem = Edit
		navigationItem.rightBarButtonItem?.tintColor = hexStringToUIColor(hex: "00CC00")
		
		
		
				
		let containView = UIView(frame: CGRect(x: 0, y: 0, width:	40, height: 40))
		let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		imageview.image =  fetchData(nameImage: self.dataobj["profile_image_path"]!)
		imageview.contentMode = UIViewContentMode.scaleAspectFill
		imageview.layer.cornerRadius = 20
		imageview.layer.masksToBounds = true
		containView.addSubview(imageview)
		navigationItem.titleView = containView
		let tapgesture = UITapGestureRecognizer(target: self, action: #selector(Editpressed))
		navigationItem.titleView?.addGestureRecognizer(tapgesture)
		
	//Manupulating Segmented Control
		segmentedcontrol.layer.borderWidth = 0.0
		segmentedcontrol.layer.backgroundColor = hexStringToUIColor(hex: "00CC00").cgColor
		segmentedcontrol.tintColor = hexStringToUIColor(hex: "00CC00")
		segmentedcontrol.setTitleTextAttributes([NSFontAttributeName :  UIFont.systemFont(ofSize: 16),
		NSForegroundColorAttributeName : UIColor.lightText], for: .normal)
		segmentedcontrol.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 16),
		NSForegroundColorAttributeName : UIColor.white], for: .selected)
		segmentedcontrol.addTarget(self, action: #selector(segmentedcontrolvaluechanged), for: UIControlEvents.valueChanged)
	
	// Container view state on load	
		self.containerview.isHidden = false
		self.containerview2.isHidden = true

					
				
	}
	func backpressed(){
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	func Editpressed(){
		
		let SB = UIStoryboard(name: "Main", bundle: nil)
		let VC = SB.instantiateViewController(withIdentifier: "registration") as! RegistrationViewController
		VC.profileid = self.profileid
		VC.dataobj = self.dataobj
		self.navigationController?.pushViewController(VC, animated: true)
		
		/*VC.firstname.text = self.dataobj["first_name"]
		VC.Middlename.placeholder = self.dataobj["middle_name"]
		VC.Lastname.placeholder = self.dataobj["last_name"]
		VC.bloodgroup.placeholder = self.dataobj["blood_group"]
		VC.city.placeholder = self.dataobj["city"]
		VC.country.placeholder = self.dataobj["Country"]
		VC.dateofbirth.placeholder = self.dataobj["DOB"]
		VC.emailid.placeholder = self.dataobj["email"]
		VC.gender.placeholder = self.dataobj["gender"]
		VC.mobile.placeholder = self.dataobj["mobile_no"]
		VC.pincode.placeholder = self.dataobj["pin_code"]
		VC.Relaton.placeholder = self.dataobj["gender"]
		VC.profileimage.image = fetchData(nameImage: self.dataobj["profile_image_path"]!)*/
		
		
	}
	
	func segmentedcontrolvaluechanged(){

		if segmentedcontrol.selectedSegmentIndex == 0{
			
			PerformBloodPressureViewController()
		}else{
			PerformBloodSugarViewController()
		}
		
	}
	
	func PerformBloodPressureViewController(){
		
		self.containerview.isHidden = false
		self.containerview2.isHidden = true
		
		
	}
	func PerformBloodSugarViewController(){
		self.containerview2.isHidden = false
		self.containerview.isHidden = true
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "tobloodpressure"{
			let VC = segue.destination as! BloodPressureViewController
			VC.profileid = self.profileid
			VC.profiledataobj = self.dataobj
		}
		if segue.identifier == "tobloodsugar"{
			let VC = segue.destination as! BloodSugarViewController
			VC.profileid = self.profileid
			VC.profiledataobj = self.dataobj
		}
	}

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

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewWillDisappear(_ animated: Bool) {
		super .viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	override func viewWillAppear(_ animated: Bool) {
		print("STACK profile", self.navigationController?.viewControllers)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
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
