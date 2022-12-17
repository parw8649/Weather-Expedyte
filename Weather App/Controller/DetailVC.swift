//
//  DetailVC.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class DetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var arrDetail = [Information]()
    
    @IBOutlet weak var lblUVIndex: UILabel!
    @IBOutlet weak var coll_WindSpeed: UICollectionView!
    @IBOutlet weak var viewWindSpeed: UIView!
    @IBOutlet weak var viewUVIndex: UIView!
    @IBOutlet weak var viewCycle: UIView!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var imageWind: UIImageView!
    
    var location = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        [viewWindSpeed,viewUVIndex,viewCycle].forEach({$0?.cornerRadius = 15})
        imageWind.cornerRadius = 10
        [viewWindSpeed,viewUVIndex,viewCycle].forEach({$0?.setShadoView()})
        
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        
        datagetfromSwiftyJson()
    }
    
    // get data through API call
    func datagetfromSwiftyJson(){
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(location.location!.coordinate.latitude)&lon=\(location.location!.coordinate.longitude)&exclude=minutely&appid=cc899157f374994317d6f1068339c300&units=metric", method: .get, encoding: JSONEncoding.default).validate().responseData( completionHandler: { response in
            
            switch response.result{
            case .success(let value) :
                let jSon = JSON(value)
                
                var d1 = Information()
                
                for obj in jSon["hourly"].arrayValue{
                    d1.windSpeed = obj["wind_speed"].doubleValue
                    d1.time = obj["dt"].intValue
                    self.arrDetail.append(d1)
                }
                
                DispatchQueue.main.async { [self] in
                    
                    coll_WindSpeed.reloadData()
                    self.lblSunrise.text = createDateTime(timestamp: "\(jSon["current"]["sunrise"].intValue)", dateFormat: "hh:mm a")
                    lblSunset.text = createDateTime(timestamp: "\(jSon["current"]["sunset"].intValue)", dateFormat: "hh:mm a")
                    
                    if jSon["current"]["uvi"].doubleValue > 5 {
                        self.lblUVIndex.text = "\( jSon["current"]["uvi"].doubleValue)"
                        self.lblHigh.text = "High"
                    }
                    else {
                        self.lblUVIndex.text = "\( jSon["current"]["uvi"].doubleValue)"
                        self.lblHigh.text = "Low"
                    }
                }
                
            case .failure(_):
                break
            }
            
        })
        
    }
    
    @IBAction func clickOnBackBtn(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: UIcollectionView delegate method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrDetail.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = coll_WindSpeed.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CollectionViewCell
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
