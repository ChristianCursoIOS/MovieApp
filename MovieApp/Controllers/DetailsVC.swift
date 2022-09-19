//
//  DetailsVC.swift
//  MovieApp
//
//  Created by christian on 12/09/22.
//

import UIKit

class DetailsVC: UIViewController{
    
    @IBOutlet weak var imgDescripcion: UIImageView!
    @IBOutlet weak var textViewDescripcion: UITextView!
    @IBOutlet weak var namePeliculaDescripcion: UILabel!
    
    var generalMovie: Movies?
    var imgMovie: String?
    var nombre: String?
    var delegateP: NotificationAlert!
    
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewDescripcion.text = generalMovie?.overview
        namePeliculaDescripcion.text = generalMovie?.original_title
        
        if let name = generalMovie?.poster_path {
            let imgName = "https://image.tmdb.org/t/p/original" + name
            let cacheString = NSString(string: imgName)
            
            if let cacheImage = self.cache.object(forKey: cacheString) {
                imgDescripcion.image = cacheImage
            } else {
                self.loadImage(from: URL(string: imgName)) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    self.imgDescripcion.image = image
                    
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
            
        }
        
    }
    
//MARK: boton de compra
    
    @IBAction func getTicketsButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(notificationBuy), object: nil, userInfo: ["User" : User(id:1,name : "Christian")])
        delegateP?.didSelect((nombre ?? generalMovie?.original_title) ?? "")
       
        
       
    }
        
    
// MARK: Descarga de imagen
    
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    
    
}

struct User {
    let id: Int
    let name: String
}


