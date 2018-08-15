//
//  BS_Master.swift
//  HealthMate
//
//  Created by Mac on 15/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm

class BS_Master:Object{
	
	dynamic var MSR_id:Int = 0
	dynamic var profile_ID:Int = 0
	dynamic var MSR_date:String = ""
	dynamic var PM4_value:String = "0"
	dynamic var PM4_time:String = ""
	dynamic var PM4_remarks:String = ""
	dynamic var PM5_value:String = "0"
	dynamic var PM5_time:String = ""
	dynamic var PM5_remarks:String = ""
	
	override static func primaryKey() -> String? {
		return "MSR_id"
	}
	
	
	func IncrementID() -> Int{
		
		let realm =  try! Realm()
		
		let retNext = realm.objects( BS_Master.self).sorted(byKeyPath: "MSR_id", ascending: false).first?.MSR_id
		
		
		if retNext == nil{
			return 1
		}else{
			return retNext! + 1
		}
	}
	
	func insertintoBS_Master(MSR_id:Int,profile_id:Int,PM4_value:String,PM4_time:String,PM4_remarks:String,PM5_value:String, PM5_time:String, PM5_remarks:String,MSR_date: String){
		
		self.MSR_id = MSR_id
		self.profile_ID = profile_id
		self.PM4_value = PM4_value
		self.PM4_time = PM4_time
		self.PM4_remarks = PM4_remarks
		self.PM5_value = PM5_value
		self.PM5_time = PM5_time
		self.PM5_remarks = PM5_remarks
		self.MSR_date = MSR_date
	}

 
}
