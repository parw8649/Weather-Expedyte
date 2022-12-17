//
//  WeatherReportVC.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherReportVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var arrAirQlty = [InfoAirQlty]()
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collectionViewAIR: UICollectionView!
    
    var location = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionViewAIR.collectionViewLayout = layout
        
        viewBack.cornerRadius = 15
        viewBack.setShadoView()
        
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        
        dataGetthroughApi()
        
    }
    
    // get data through API call
    func dataGetthroughApi(){
        
        AF.request("http://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=\(location.location!.coordinate.latitude)&lon=\(location.location!.coordinate.longitude)&appid=cc899157f374994317d6f1068339c300", method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                var d1 = InfoAirQlty()
                
                for (i,obj) in jSon["list"].arrayValue.enumerated(){
                    
                    d1.time = obj["dt"].intValue
                    d1.aqi = obj["main"]["aqi"].intValue
                    d1.co = obj["components"]["co"].doubleValue
                    d1.no = obj["components"]["no"].doubleValue
                    d1.no2 = obj["components"]["no2"].doubleValue
                    d1.o3 = obj["components"]["o3"].doubleValue
                    d1.so2 = obj["components"]["so2"].doubleValue
                    d1.pm2_5 = obj["components"]["pm2_5"].doubleValue
                    d1.pm10 = obj["components"]["pm10"].doubleValue
                    d1.nh3 = obj["components"]["nh3"].doubleValue
                    if i >= 24 {
                        break
                    }
                    self.arrAirQlty.append(d1)
                }
                
                DispatchQueue.main.async { [self] in
                    
                    collectionViewAIR.reloadData()
                    
                }
                
            case .failure(_):
                break
            }
            
        })
        
    }
    
    
    // MARK: uicollectionView delegate and datasource method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrAirQlty.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewAIR.dequeueReusableCell(withReuseIdentifier: "AIRCollectionViewCell", for: indexPath)as! AIRCollectionViewCell
        
        cell.viewCell.cornerRadius = 15
        cell.viewCell.setShadoView()
        
        let data = arrAirQlty[indexPath.row]
        cell.lblDate.text = createDateTime(timestamp: "\(data.time)", dateFormat: "hh a")
        cell.lblAqi.text = "AQI : \(data.aqi)"
        cell.lblCo.attributedText = addBoldText(fullString: "CO2 : \(data.co)" as NSString, boldPartsOfString: ["CO2 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblNo.attributedText = addBoldText(fullString: "NO : \(data.no)" as NSString, boldPartsOfString: ["NO :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblNo2.attributedText = addBoldText(fullString: "NO2 : \(data.no2)" as NSString, boldPartsOfString: ["NO2 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblO3.attributedText = addBoldText(fullString: "O3 : \(data.o3)" as NSString, boldPartsOfString: ["O3 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblSo2.attributedText = addBoldText(fullString: "SO2 : \(data.so2)" as NSString, boldPartsOfString: ["SO2 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblPm2_5.attributedText = addBoldText(fullString: "Pm2_5 : \(data.pm2_5)" as NSString, boldPartsOfString: ["Pm2_5 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblPm10.attributedText = addBoldText(fullString: "Pm10 : \(data.pm10)" as NSString, boldPartsOfString: ["Pm10 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        cell.lblNh3.attributedText = addBoldText(fullString: "NH3 : \(data.nh3)" as NSString, boldPartsOfString: ["NH3 :"], font: .systemFont(ofSize: 17), boldFont: .boldSystemFont(ofSize: 17))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let xPadding = 10
        let spacing = 10
        let rightPadding = 10
        let width = (CGFloat(UIScreen.main.bounds.size.width) - CGFloat(xPadding + spacing + rightPadding))/2
        let height = CGFloat(330)
        
        return CGSize(width: width, height: height)
    }
    
    // for  bold some part of string from full string
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    
}
