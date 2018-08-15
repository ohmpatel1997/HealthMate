//
//  GraphViewController.swift
//  HealthMate
//
//  Created by Mac on 26/06/18.
//  Copyright © 2018 Cresco Mobility Solutions. All rights reserved.
//

import UIKit
import CorePlot
import Realm
import RealmSwift


class GraphViewController: UIViewController, CPTBarPlotDataSource, CPTBarPlotDelegate {

	@IBOutlet weak var hostview: CPTGraphHostingView!
	@IBOutlet weak var label3: UILabel!
	@IBOutlet weak var label2: UILabel!
	@IBOutlet weak var label1: UILabel!
	@IBOutlet weak var switch2: UISwitch!
	
	@IBOutlet weak var switch3: UISwitch!
	@IBOutlet weak var switch1: UISwitch!
	var plot1:CPTBarPlot!
	var plot2:CPTBarPlot!
	var plot3:CPTBarPlot!
	
	let barwidth = 0.25
	let barinitialx = 0.25
		
	var realm:Realm!
	var dataobj:[[String:String]]!   //initialize it during prepare for seague
	var GraphTitle:String!				//initialize it during prepare for seague
	var priceAnnotation: CPTPlotSpaceAnnotation?
	var temp1:String!
	var temp2:String!
	var temp3:String!
	var ishidden:Bool!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "00CC00")
        
		
        self.label1.text = temp1
		self.label2.text = temp2
		self.label3.text = temp3
		self.label2.isHidden = ishidden
		self.switch2.isHidden = ishidden
		
		 self.switch1.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
		self.switch2.transform = CGAffineTransform(scaleX: 0.55,y: 0.55)
		self.switch3.transform = CGAffineTransform(scaleX: 0.55,y: 0.55)
		self.switch1.onTintColor = hexStringToUIColor(hex: "40bf00")
		if GraphTitle == "Blood Pressure Management"{
			
			self.switch2.onTintColor = hexStringToUIColor(hex: "3399ff")
			self.switch3.onTintColor = hexStringToUIColor(hex: "ea8d0f")
		}else{
			
			self.switch3.onTintColor = hexStringToUIColor(hex: "3399ff")
		}
	
	}
	func backbuttonpressed(){
		self.navigationController?.popViewController(animated: true)
	}
	
	override func viewDidLayoutSubviews() {
		initplot()
	}
	
	func initplot(){
		
		configureHostView()
		configureGraph()
		configureChart()
		configureAxes()
	}
	
	func configureHostView(){
		self.hostview.allowPinchScaling = true
		hostview.isUserInteractionEnabled = true
	}
	
	func highestRateValue() ->Double{		// fetch the highest value to be displayed from dataobj
	
		var data:[Double] = []
		
		if GraphTitle == "Blood Pressure Management"{
			for i in 0...self.dataobj.count - 1{
			
				let temp:[Double] = [
									Double(dataobj[i]["PM1_value"]!)!,
									Double(dataobj[i]["PM2_value"]!)!,
									Double(dataobj[i]["PM3_value"]!)!
									]
				let tempmax = temp.max()
				data.append(tempmax!)
			}
		}else{
			for i in 0...self.dataobj.count - 1{
				
				let temp:[Double] = [
									Double(dataobj[i]["PM4_value"]!)!,
									Double(dataobj[i]["PM5_value"]!)!,
									]
				let tempmax = temp.max()
				data.append(tempmax!)
			}
		}
		return data.max()!
	}
	
	func configureGraph(){
		
		
		let graph = CPTXYGraph(frame: hostview.bounds)
		graph.plotAreaFrame?.masksToBorder = false
		
		
		
		
		//graph.apply(CPTTheme(named: CPTThemeName.plainWhiteTheme))
		graph.fill = CPTFill(color: CPTColor.clear())
		graph.paddingBottom = 30.0
		graph.paddingLeft = 25.0
		graph.paddingRight = 10.0
		graph.paddingTop = 0.0
		hostview.hostedGraph = graph
		
		let titlestyle = CPTMutableTextStyle()
		titlestyle.color = CPTColor.black()
		titlestyle.fontName = "HelveticaNeue-Bold"
		titlestyle.fontSize = 16.0
		titlestyle.textAlignment = .left
		graph.titleTextStyle = titlestyle
		
		graph.title = self.GraphTitle
		graph.titlePlotAreaFrameAnchor = .top
		graph.titleDisplacement = CGPoint(x: 0.0, y: 0.0)

		let xMin = 0.0
		let xMax = 3.0
		let yMin = 0.0
		let yMax = 1.4 * highestRateValue()
		guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
		plotSpace.allowsUserInteraction = true
		plotSpace.allowsMomentumX = true
		plotSpace.allowsMomentumY = false
		
	
		plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal:CPTDecimalFromDouble(xMax - xMin))
		plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))

	}
	
	func configureChart(){
		
		plot1 = CPTBarPlot()
		plot1.fill = CPTFill(color: hextoCPTcolor(hex: "40bf00"))
		plot2 = CPTBarPlot()
		plot2.fill = CPTFill(color: hextoCPTcolor(hex: "3399ff"))
		plot3 = CPTBarPlot()
		plot3.fill = CPTFill(color: hextoCPTcolor(hex: "ea8d0f"))
		
		let barLineStyle = CPTMutableLineStyle()
		barLineStyle.lineColor = CPTColor.lightGray()
		barLineStyle.lineWidth = 0.5
		
		guard let graph = self.hostview.hostedGraph else { return }
		var barX = barinitialx
		var plots:[CPTBarPlot]!
		
		if GraphTitle == "Blood Pressure Management"{
			plots = [plot1!, plot2!, plot3!]
		}else{
			plots = [plot1!,plot2!]
		}
		
		for plot: CPTBarPlot in plots {
			
			plot.dataSource = self
			plot.delegate = self
			plot.barWidth = NSNumber(value: barwidth)
			plot.barOffset = NSNumber(value: barX)
			plot.lineStyle = barLineStyle
			graph.add(plot, to: graph.defaultPlotSpace)
			barX += barwidth
			
		}
	}
	
	func configureAxes(){
		
		// 1 - Configure styles
		let axisLineStyle = CPTMutableLineStyle()
		axisLineStyle.lineWidth = 1.0
		axisLineStyle.lineColor = CPTColor.black()
		// 2 - Get the graph's axis set
		guard let axisSet = hostview.hostedGraph?.axisSet as? CPTXYAxisSet else { return }
		// 3 - Configure the x-axis
		
		if let xAxis = axisSet.xAxis {
		
			xAxis.labelingPolicy = .none
			xAxis.majorIntervalLength = 20
			xAxis.axisLineStyle = axisLineStyle
			var majorTickLocations = Set<NSNumber>()
			var axisLabels = Set<CPTAxisLabel>()
			
			var hoffset = 0
			for (idx, rate) in dataobj.enumerated() {
					
					
					majorTickLocations.insert(NSNumber(value: idx + hoffset))
					var label:CPTAxisLabel!
				
				if GraphTitle == "Blood Pressure Management"{
					label = CPTAxisLabel(text:  rate["MSR_TS"], textStyle: CPTTextStyle())
				}else{
					label = CPTAxisLabel(text:  rate["MSR_date"], textStyle: CPTTextStyle())
				}
					label.tickLocation = NSNumber(value: idx)
					label.offset = 5.0
					label.alignment = .left
					axisLabels.insert(label)
					hoffset += 1
				
			}
			xAxis.majorTickLocations = majorTickLocations
			xAxis.axisLabels = axisLabels
		}
		
		// 4 - Configure the y-axis
		if let yAxis = axisSet.yAxis {
			yAxis.labelingPolicy = .automatic
			let style = CPTMutableTextStyle()
			style.fontSize = 10
			yAxis.labelTextStyle = style
			yAxis.labelOffset = -20.0
			yAxis.minorTicksPerInterval = 2
			yAxis.majorTickLength = 20
			let majorTickLineStyle = CPTMutableLineStyle()
			majorTickLineStyle.lineColor = CPTColor.black().withAlphaComponent(0.5)
			yAxis.majorTickLineStyle = majorTickLineStyle
			
			let minorTickLineStyle = CPTMutableLineStyle()
			minorTickLineStyle.lineColor = CPTColor.black().withAlphaComponent(0.05)
			yAxis.minorTickLineStyle = minorTickLineStyle
			yAxis.axisLineStyle = axisLineStyle
		}
	}

	
	
	func numberOfRecords(for plot: CPTPlot) -> UInt {
		return	UInt(dataobj.count)
	}
	
	@IBAction func switch1(_ sender: Any) {
	
		let on = (sender as AnyObject).isOn
		if !on! {
			hideAnnotation(graph: plot1.graph!)
			}
			plot1.isHidden = !on!
	}
	@IBAction func switch2(_ sender: Any) {
		
		let on = (sender as AnyObject).isOn
		if !on! {
			hideAnnotation(graph: plot2.graph!)
		}
			plot2.isHidden = !on!
	}
	@IBAction func switch3(_ sender: Any) {
		
		if GraphTitle == "Blood Pressure Management"{
			
			let on = (sender as AnyObject).isOn
			if !on! {
				hideAnnotation(graph: plot3.graph!)
			}
			plot3.isHidden = !on!
		
		}else{
			
			let on = (sender as AnyObject).isOn
			if !on! {
				hideAnnotation(graph: plot2.graph!)
			}
			plot2.isHidden = !on!

		}
	}
	
	func hideAnnotation(graph: CPTGraph) {
		guard let plotArea = graph.plotAreaFrame?.plotArea,
		let priceAnnotation = priceAnnotation else {
		return
		}
		plotArea.removeAnnotation(priceAnnotation)
		self.priceAnnotation = nil
	}
	
	func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
		
		if fieldEnum == UInt(CPTBarPlotField.barTip.rawValue) {
		
			if GraphTitle == "Blood Pressure Management"{
			
				if plot == plot1 {
					return dataobj[Int(idx)]["PM1_value"]!
				}
				if plot == plot2 {
					return dataobj[Int(idx)]["PM2_value"]!
				}
				if plot == plot3 {
					return dataobj[Int(idx)]["PM3_value"]!
				}
			
			}else{
				
				if plot == plot1 {
				
					return dataobj[Int(idx)]["PM4_value"]!
				}
				if plot == plot2 {
					return dataobj[Int(idx)]["PM5_value"]!
				}
			}
		}
		return idx
	}
		
	func barPlot(_ plot: CPTBarPlot, barWasSelectedAtRecord idx: UInt) {
		
		
	}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func hextoCPTcolor(hex:String) -> CPTColor{
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return CPTColor.gray()
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return CPTColor(
            componentRed: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
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

