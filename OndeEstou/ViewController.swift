//
//  ViewController.swift
//  OndeEstou
//
//  Created by Macbook on 02/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacaoUsuario = locations.last
        let longitude = localizacaoUsuario?.coordinate.longitude
        let latitude = localizacaoUsuario?.coordinate.latitude
        longitudeLabel.text = String(longitude!)
        latitudeLabel.text = String(latitude!)
        let speed = localizacaoUsuario?.speed
        
        if Int(speed!) > 0 {
        velocidadeLabel.text = String(speed!)
        }
        
        
        let deltaLatidude:CLLocationDegrees = 0.01
        let deltaLongitude:CLLocationDegrees = 0.01
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let areaVisualizacao:MKCoordinateSpan = MKCoordinateSpanMake(deltaLatidude, deltaLongitude)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaVisualizacao)
        
        mapa.setRegion(regiao, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario!) { (detalhesLocal, erro) in
            if erro == nil{
                if let dadosLocal = detalhesLocal?.first{
                    
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil
                    {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil
                    {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil
                    {
                        locality = dadosLocal.locality!
                    }
                    
                    var subLocality = ""
                    if dadosLocal.subLocality != nil
                    {
                        subLocality = dadosLocal.subLocality!
                    }
                    
                    var postalCode = ""
                    if dadosLocal.postalCode != nil
                    {
                        postalCode = dadosLocal.postalCode!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil
                    {
                        country = dadosLocal.country!
                    }
                    
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil
                    {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil
                    {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + " - "
                        + subThoroughfare + " / "
                        + locality + " / "
                        + country
                    
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse
        {
            var alert = UIAlertController(title: "Permissão de Localização", message: "Necsessario permissão de acesso a sua localizacao! por favor habilite!", preferredStyle: .alert)
            
            var acaoConfiguracao = UIAlertAction(title: "Abrir configuração", style: .default, handler: { (alertConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            var acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alert.addAction(acaoConfiguracao)
            alert.addAction(acaoCancelar)
            
            present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

