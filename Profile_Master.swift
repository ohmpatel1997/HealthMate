//
//  Profile_Master.swift
//  HealthMate
//
//  Created by Mac on 14/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import Foundation
import  UIKit
import RealmSwift
import Realm

class Profile_Master:Object{
	
	dynamic	var profile_id: Int = 0
	dynamic var first_name:String = ""
	dynamic var middlename:String = ""
	dynamic var lastname:String = ""
	dynamic var DOB:Date = Date.init()
	dynamic var gender:String = ""
	dynamic var relation:String = ""
	dynamic var bloodgroup:String = ""
	dynamic var height:String = ""
	dynamic var mobile_no:String = ""
	dynamic var email_id:String = ""
	dynamic var city:String = ""
	dynamic var country:String = ""
	dynamic var pincode:String = ""
	dynamic var status:String = ""
	
	dynamic var profileimage:String = ""
	
	override static func primaryKey() -> String? {
		return "profile_id"
	}
	
	func IncrementID() -> Int{
		
			let realm =  try! Realm()
		
			let retNext = realm.objects( Profile_Master.self).sorted(byKeyPath: "profile_id", ascending: false).first?.profile_id
			 
		
		if retNext == nil{
			return 1
		}else{
			return retNext! + 1
		}
		
	}
	
	
	
	
		 func insertintoProfile_master(profile_id:Int,first_name:String,middlename:String,lastname:String,DOB:Date,gender:String,relation:String,bloodgroup:String,mobile_no:String,email_id:String,city:String,country:String,pincode:String,status:String,profile_image_path:String){
			
					self.profile_id = profile_id
					self.first_name = first_name
					self.middlename = middlename
					self.lastname = lastname
					self.bloodgroup = bloodgroup
					self.city = city
					self.country = country
					self.mobile_no = mobile_no
					self.relation = relation
					self.pincode = pincode
					self.status = status
					self.email_id = email_id
					self.gender = gender
					self.DOB = DOB
					self.profileimage = profile_image_path
			
	
		
	}
	
	

}


