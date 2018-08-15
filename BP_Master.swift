//
//  Parameter_Master.swift
//  HealthMate
//
//  Created by Mac on 14/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class BP_Master:Object{
	
	var id:Int = 0
	dynamic var MSR_id = 0
	dynamic var profile_ID:Int = 0
	dynamic var PM1_value:String = "0"
	dynamic var PM2_value:String = "0"
	dynamic var PM3_value:String = "0"
	dynamic var MSR_TS:String = "0"
	dynamic var MSR_TSTime:String = ""
	dynamic var MSR_location:String = ""
	dynamic var MSR_position:String = ""
	dynamic var MSR_remarks:String = ""
	
	
	override static func primaryKey() -> String? {
		return "MSR_id"
	}
	
	func IncrementID() -> Int{
		
		let realm =  try! Realm()
		
		let retNext = realm.objects( BP_Master.self).sorted(byKeyPath: "MSR_id", ascending: false).first?.MSR_id
		
		
		if retNext == nil{
			return 1
		}else{
			return retNext! + 1
		}
	}
	
	func insertintoBP_Master(MSR_id:Int,profile_id:Int,PM1_value:String,PM2_value:String,PM3_value:String,MSR_TS:String,MSR_location:String,MSR_position:String,MSR_remarks:String,MSR_TSTime:String){
		
		self.MSR_id = MSR_id
		self.profile_ID = profile_id
		self.PM1_value = PM1_value
		self.PM2_value = PM2_value
		self.PM3_value = PM3_value
		self.PM3_value = PM3_value
		self.MSR_TS = MSR_TS
		self.MSR_TSTime = MSR_TSTime
		self.MSR_location = MSR_location
		self.MSR_position = MSR_position
		self.MSR_remarks = MSR_remarks
	}
	

}
