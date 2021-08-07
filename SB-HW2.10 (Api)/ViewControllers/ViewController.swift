//
//  ViewController.swift
//  SB-HW2.10 (Api)
//
//  Created by Vladislav Kulak on 06.08.2021.
//

import UIKit
import CoreLocation
import WebKit

class ViewController: UIViewController {
    
    
    @IBOutlet var imageWebView: WKWebView!
    
    @IBOutlet weak var temlLabel: UILabel!
    @IBOutlet weak var feelLable: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    let group = DispatchGroup()
    
    private var cord = Coordinate.shared
    private let apiKey = "d60aa43f-8443-4e75-afa1-d4e07566b699"
    private var icon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageWebView.navigationDelegate = self
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        location()
        network()
        imageWebView.isHidden = true
    }
}

// MARK: - Get location  user
extension ViewController: CLLocationManagerDelegate {
    private func location(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        cord.latitude = locValue.latitude
        cord.longtitude = locValue.longitude
    }
    
}

// MARK: - API handler

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        imageWebView.isHidden = false
    }
    func network() {
        guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(cord.latitude)&lon=\(cord.longtitude)") else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error descriprion")
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                DispatchQueue.main.sync {
                    self.temlLabel.text = "\(weather.fact?.temp ?? 0)°"
                    self.feelLable.text = "Ощущается как \(weather.fact?.feels_like ?? 0)°"
                    self.speedWindLabel.text = "Скорость ветра \(weather.fact?.wind_speed ?? 0) м/с"
                    self.pressureLabel.text = "Давление: \(weather.fact?.pressure_mm ?? 0) мм.рт.ст"
                    self.icon = weather.fact?.icon ?? "ovc"
                }
                self.fetchImage()
  
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    private func fetchImage() {
        let iconUrl = "https://yastatic.net/weather/i/icons/funky/dark/ovc.svg"
        guard let imageUrl = URL(string: iconUrl ) else { return }
        guard let htmlString = try? String(contentsOf: imageUrl) else {return}
        
        DispatchQueue.main.async {
            self.imageWebView.loadHTMLString(htmlString, baseURL: imageUrl)
        }
    }
}

