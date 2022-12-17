//
//  HomeVC.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SDWebImage
import Charts


class HomeVC: UIViewController,CLLocationManagerDelegate,ChartViewDelegate  {
    
    var arrDetail = [Temprature]()
    
    @IBOutlet weak var imageCloud: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDayTime: UILabel!
    @IBOutlet weak var lblNightTime: UILabel!
    @IBOutlet weak var viewForecast: UIView!
    @IBOutlet weak var btnViewDay: UIButton!
    @IBOutlet weak var viewLineChart: LineChartView!
    
    var location = CLLocationManager() // 21.22505 , 72.901168
    var cLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for Creat LineChart
        viewLineChart.delegate = self
        viewLineChart.chartDescription.enabled = false
        viewLineChart.dragEnabled = true
        viewLineChart.setScaleEnabled(true)
        viewLineChart.doubleTapToZoomEnabled = true
        viewLineChart.pinchZoomEnabled = true
        viewLineChart.xAxis.enabled = true
        viewLineChart.xAxis.drawGridLinesEnabled = false
        viewLineChart.xAxis.drawLabelsEnabled = true
        viewLineChart.xAxis.labelPosition = .bottom
        viewLineChart.xAxis.valueFormatter = DateValueFormatter()
        viewLineChart.rightAxis.enabled = false
        viewLineChart.leftAxis.enabled = true
        viewLineChart.leftAxis.drawGridLinesEnabled = false
        viewLineChart.legend.form = .none
        
        [viewForecast,btnViewDay].forEach({$0?.cornerRadius = 15})
        [viewForecast,btnViewDay].forEach({$0?.setShadoView()})
        
        location.requestWhenInUseAuthorization()
        location.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        location.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        cLocation = locations.last ?? location.location!
        location.stopUpdatingLocation()
        datagetfromSwiftyJson()
        
    }
    // for Creat LineChart
    func customizeChart(values: [Temprature]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for obj in values {
            
            let dataEntry = ChartDataEntry(x:Double(obj.time) , y: obj.temp)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        setup(lineChartDataSet)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        lineChartData.setValueFormatter(formatter)//C4E2FF
        
        let gradientColors = [ChartColorTemplates.colorFromString("#FFFFFF").cgColor, //#00ff0000
                              ChartColorTemplates.colorFromString("#C4E2FF").cgColor] //#ffff0000
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        lineChartDataSet.drawFilledEnabled = true
        
        viewLineChart.data = lineChartData
    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        
        dataSet.setColors(.clear, .clear, .clear)
        dataSet.setCircleColor(.darkGray)
        dataSet.gradientPositions = [0, 40, 100]
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 9)
        
    }
 
    // get data through API call
    func datagetfromSwiftyJson(){
        
        print("location.location!.coordinate:",cLocation)
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(cLocation.coordinate.latitude)&lon=\(cLocation.coordinate.longitude)&appid=cc899157f374994317d6f1068339c300&units=metric"
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                DispatchQueue.main.async {
                    self.lblTemperature.text = "\(jSon["main"]["temp"].doubleValue)°"
                    self.lblDayTime.text = "Day  \(jSon["main"]["temp_max"].doubleValue)°"
                    self.lblNightTime.text = "Night \(jSon["main"]["temp_min"].doubleValue)°"
                }
                
            case .failure(_):
                break
            }
            self.datagetfromSwiftyJson1()
            
        })
        
    }
    
    func datagetfromSwiftyJson1(){
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(cLocation.coordinate.latitude)&lon=\(cLocation.coordinate.longitude)&exclude=minutely&appid=cc899157f374994317d6f1068339c300&units=metric", method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { [self] response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                arrDetail.removeAll()
                
                var d1 = Temprature()
                
                for (i,obj) in jSon["hourly"].arrayValue.enumerated(){
                    
                    if i == 12 {
                        
                        self.customizeChart(values: arrDetail)
                        break
                    }
                    else
                    {
                        d1.temp = obj["temp"].doubleValue
                        d1.time = obj["dt"].intValue
                        self.arrDetail.append(d1)
                    }
                }
                              
            case .failure(_):
                break
            }
            
        })
        
    }
    
    @IBAction func clickOnViewDailySummaryBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC")as! DetailVC
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

// for CustomValueFormatter for X-Axis
public class DateValueFormatter: NSObject, AxisValueFormatter {
    
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "hh a"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
