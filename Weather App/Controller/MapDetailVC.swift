//
//  MapDetailVC.swift
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

class MapDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChartViewDelegate {
    
    var arrDetail = [Info]()
    
    @IBOutlet weak var viewForecast: UIView!
    @IBOutlet weak var viewWind: UIView!
    @IBOutlet weak var viewUVIndex: UIView!
    @IBOutlet weak var viewDayCycle: UIView!
    @IBOutlet weak var lblUvIndex: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblSunRise: UILabel!
    @IBOutlet weak var lblSunSet: UILabel!
    @IBOutlet weak var ImageWeather: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblNight: UILabel!
    @IBOutlet weak var collWind: UICollectionView!
    @IBOutlet weak var imageWind: UIImageView!
    @IBOutlet weak var viewLineChart: LineChartView!
    
    var loc = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for creat LineChart
        
        viewLineChart.delegate = self
        viewLineChart.chartDescription.enabled = false
        viewLineChart.dragEnabled = true
        viewLineChart.setScaleEnabled(true)
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
        
        [viewForecast,viewWind,viewUVIndex,viewDayCycle].forEach({$0?.cornerRadius = 15})
        [viewForecast,viewWind,viewUVIndex,viewDayCycle].forEach({$0?.setShadoView()})
        imageWind.cornerRadius = 10
        

        datagetfromApi()
        
    }
    
    // for creat LineChart
    
    func customizeChart( values: [Info]) {
        
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
        lineChartData.setValueFormatter(formatter)
        
        let gradientColors = [ChartColorTemplates.colorFromString("#FFFFFF").cgColor,
                              ChartColorTemplates.colorFromString("#C4E2FF").cgColor]
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
    func datagetfromApi(){
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=cc899157f374994317d6f1068339c300&units=metric", method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                DispatchQueue.main.async {
                    self.lblTemp.text = "\(jSon["main"]["temp"].doubleValue)°"
                    self.lblDay.text = "Day  \(jSon["main"]["temp_max"].doubleValue)°"
                    self.lblNight.text = "Night \(jSon["main"]["temp_min"].doubleValue)°"
                }
                
            case .failure(_):
                break
            }
            self.datagetfromSwiftyJson()
            
        })
        
    }
    
    func datagetfromSwiftyJson(){
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(loc.latitude)&lon=\(loc.longitude)&exclude=minutely&appid=cc899157f374994317d6f1068339c300&units=metric", method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { [self] response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                var d1 = Info()
                
                for (i,obj) in jSon["hourly"].arrayValue.enumerated(){
                    d1.windSpeed = obj["wind_speed"].doubleValue
                    d1.time = obj["dt"].intValue
                    d1.temp = obj["temp"].doubleValue
                    
                    self.arrDetail.append(d1)
                    if i == 11 {
                        self.customizeChart(values: self.arrDetail)
                        break
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    
                    collWind.reloadData()
                    self.lblSunRise.text = createDateTime(timestamp: "\(jSon["current"]["sunrise"].intValue)", dateFormat: "hh:mm a")
                    lblSunSet.text = createDateTime(timestamp: "\(jSon["current"]["sunset"].intValue)", dateFormat: "hh:mm a")
                    
                    if jSon["current"]["uvi"].doubleValue > 5 {
                        self.lblUvIndex.text = "\( jSon["current"]["uvi"].doubleValue)"
                        self.lblHigh.text = "High"
                    }
                    else {
                        self.lblUvIndex.text = "\( jSon["current"]["uvi"].doubleValue)"
                        self.lblHigh.text = "Low"
                    }
                }
                
            case .failure(_):
                break
            }
            
        })
    }
    
    // MARK: UIcollectionView delegate method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrDetail.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collWind.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CollectionViewCell
        cell.viewBackCell.cornerRadius = 15
        cell.viewBackCell.setShadoView()
        cell.lblWindSpeed.text = "\(arrDetail[indexPath.row].windSpeed)"
        cell.lblTime.text = createDateTime(timestamp: "\(arrDetail[indexPath.row].time)", dateFormat: "hh a")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120 , height: 120)
        
    }
    
}
