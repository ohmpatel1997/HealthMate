//
//  ViewController.swift
//  HealthMate
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	var cell:mycell?
	var newregistration:Bool = false
	var dataobj:[[String:String]] = []
	var realm:Realm!
	var tempimage:UIImage!
	var profileimagepath:String!
	var data:([String:String],String) = ([:],"")
	
	@IBOutlet weak var Logo: UIImageView!
	@IBOutlet weak var collectionview: UICollectionView!
	@IBOutlet weak var LeftUpperFlipView: UIView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
			self.navigationController?.setNavigationBarHidden(true, animated: false)	
			
		
			self.realm = try! Realm()
			
			//fetching data from realm
			LoadDataToArray()	

			collectionview.delegate = self
			collectionview.dataSource = self
		
		let tapgesture = UITapGestureRecognizer(target: self, action: #selector(Logotapped))
		self.Logo.addGestureRecognizer(tapgesture)
		
		
		
	}
		
	func Logotapped(){
			performSegue(withIdentifier: "toabout", sender: self)
	}
	
	@IBAction func LeftUpperFlipViewTapped(_ sender: Any) {
		UIView.transition(with: LeftUpperFlipView, duration: 1, options:UIViewAnimationOptions.transitionFlipFromTop, animations: nil, completion:{ _ in 
							self.LeftUpperFlipView.isHidden = true
		})		
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("number of items")
		
		
			return dataobj.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("no of sections")
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
	 if dataobj.count > 0{ 
		print("ENTERED")
		cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? mycell
		cell?.profileimage.layer.cornerRadius = (cell?.profileimage.frame.width)! / 2
		cell?.profileimage.layer.masksToBounds = true
		cell?.profileimage.contentMode = .scaleAspectFill
	
		cell?.profilename.text = dataobj[indexPath.row]["first_name"]
		profileimagepath = dataobj[indexPath.row]["profile_image_path"]!
		cell?.profileimage.image = fetchData(nameImage:profileimagepath)
		
		 
	}
		
		if indexPath.row % 2 == 0{
	
			//Add bottom and right borders to cells 
			
			//bottom border
			let topBorder = CALayer()
			topBorder.frame = CGRect(x: 00.0, y: (cell?.frame.height)! - 1, width: (cell?.frame.width)!, height: 4.0)
			topBorder.backgroundColor = UIColor(colorLiteralRed: 0, green: 1, blue: 0, alpha: 0.5).cgColor
			
			//Right border
			
			let rightBorder = CALayer()
			rightBorder.frame = CGRect(x:(cell?.frame.size.width)! - 1,y: 0.0,width: 4.0,height: (cell?.frame.size.height)!);
			rightBorder.backgroundColor = UIColor(colorLiteralRed: 0, green: 1, blue: 0, alpha: 0.5).cgColor
			
			cell?.layer.addSublayer(topBorder)
			cell?.layer.addSublayer(rightBorder)
		
		}else{
			
			print("odd")
			//Add bottom border to cells
			let bottomborder = CALayer()
			bottomborder.frame = CGRect(x: 0, y: (cell?.frame.height)! - 1, width: (cell?.frame.width)!, height: 4.0)
			bottomborder.backgroundColor = UIColor(colorLiteralRed: 0, green: 1, blue: 0, alpha: 0.5).cgColor
			cell?.layer.addSublayer(bottomborder)
		}
		
		return cell!
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		
		print("spacing")
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let temp1 = self.dataobj[indexPath.row]
		let temp2 = self.dataobj[indexPath.row]["profile_id"]
		self.data = (temp1,temp2) as! ([String : String], String)
		performSegue(withIdentifier: "toprofile", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "toprofile"{
		
			let VC = segue.destination as! ProfileViewController
				
				VC.dataobj = data.0
				VC.profileid = data.1
				
			
		}
	}
	
	
	
	func LoadDataToArray(){
		
		dataobj.removeAll()
		let objarray = self.realm.objects(Profile_Master.self)
		
		if objarray.count>0{	
			
			for i in objarray{
				
				var temp : [String:String] = [:]
				
				temp = [
					
					"profile_id" : "\(i.profile_id)",
					"first_name" : i.first_name,
					"middle_name" : i.middlename,
					"last_name" : i.lastname,
					"blood_group": i.bloodgroup,
					"relation" : i.relation,
					"mobile_no" : i.mobile_no,
					"city" : i.city,
					"email": i.email_id,
					"pin_code":i.pincode,
					"DOB":"\(i.DOB)",
					"profile_image_path": "\(i.profileimage)",
					"Country": i.country,
					"gender":i.gender
					]
				
				dataobj.append(temp)
				
			}
			print(dataobj)	
		}else{
			print("no data")
		}
		

	}
	
	@IBAction func createprofile(_ sender: Any) {
			
		let SB = UIStoryboard(name: "Main", bundle: nil)
		let RegistrationVC = SB.instantiateViewController(withIdentifier: "registration") as! RegistrationViewController
		self.navigationController?.pushViewController(RegistrationVC, animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		print("STACK view", self.navigationController?.viewControllers)
		LoadDataToArray()
		print("View will appear")
		self.collectionview.reloadData()		
	}
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
	
	

}

