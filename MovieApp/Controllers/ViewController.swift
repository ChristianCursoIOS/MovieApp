//
//  ViewController.swift
//  MovieApp
//
//  Created by christian on 09/09/22.
//

import UIKit

let notificationBuy = "com.christian.LocalNotification"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NotificationAlert {
    
    @IBOutlet weak var CollectionV: UICollectionView!
    @IBOutlet weak var imgComing: UIImageView!
    @IBOutlet weak var CollectionView2: UICollectionView!
    
    var genre: Generos?
    var pelicula: resultados?
    var generos: Int = 18
    var enviarMovies: Movies?
    var movieResult: Result?
    var cellScale : CGFloat = 0.6
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        
        //Celda perzonalizada
        self.CollectionV.register(UINib(nibName: "GeneroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell1")
        self.CollectionV.delegate = self
        self.CollectionV.dataSource = self
        
        
        self.CollectionView2.register(UINib(nibName: "NowShowingiCViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell2")
        self.CollectionView2.delegate = self
        self.CollectionView2.dataSource = self
        
        //MARK: Notification------------------------------------------------------------------
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if granted {
                
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "Header de la notificacion"
                notificationContent.body = "Este es el cuerpo de la notificacion"
                
                let date = Date().addingTimeInterval(1)
                let dataInFuture = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                let  trigger = UNCalendarNotificationTrigger(dateMatching: dataInFuture, repeats: false)
                let request = UNNotificationRequest(identifier: notificationBuy, content: notificationContent, trigger: trigger)
                
                center.add(request){ (errorDos) in
                    
                }
            }else {
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiEvent), name: NSNotification.Name(notificationBuy), object: nil)
        
        Peliculas(genero: "28") { respuesta in
            self.pelicula = respuesta
            
            print(respuesta.results.count)
            DispatchQueue.main.async { () -> Void in
                self.CollectionView2.reloadData()
            }
        }
        
        GenerosPelicula(completion:{ resultado in
            self.genre = resultado
            print(resultado.genres.count)
            DispatchQueue.main.async { () -> Void in
                self.CollectionV.reloadData()
            }
        })
        
        
    }
    @objc
    func notiEvent(_ notification: Notification){
        print("Evento", notification)
        let valorDeLaNotificacion = notification.userInfo
        let user = valorDeLaNotificacion!["User"] as! User
        print("Se ejecuto el evento: " + user.name)
    }
    
    
    
    //MARK: Llamar info a celda personalizada
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == CollectionView2 {
            if let retorno = pelicula?.results.count {
                return retorno
            }
        }
        
        if let retorno = genre?.genres.count {
            return retorno
            
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellMovie = self.CollectionView2.dequeueReusableCell(withReuseIdentifier: "customCell2", for: indexPath) as? NowShowingiCViewCell
        
        let peliculaRes = pelicula?.results[indexPath.row]
        
        if let name = peliculaRes?.poster_path {
            let imageName = "https://image.tmdb.org/t/p/original" + name
            let cacheString = NSString(string: imageName)
            
            if let cacheImage = self.cache.object(forKey: cacheString) {
                cellMovie?.imgCellMovie.image = cacheImage
            } else {
                self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    cellMovie?.imgCellMovie.image = image
                    
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
            
        }
        
        cellMovie?.nameMovieLbl.text = peliculaRes?.original_title
        
        
        if collectionView == CollectionV{
            let celdaGenre = self.CollectionV.dequeueReusableCell(withReuseIdentifier: "customCell1", for: indexPath) as? GeneroCollectionViewCell
            let muestraGenres = genre?.genres[indexPath.row]
            
            celdaGenre?.generoTitleLbl.text = muestraGenres?.name
            
            
            
            return celdaGenre!
        }
        
        return cellMovie!
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == CollectionV{
            let generosM = genre!.genres[indexPath.row]
            print(generosM)
            generos = generosM.id
            let buscaGenero = BuscaGenero(x: generos)
            Peliculas(genero: buscaGenero) { respuesta in
                self.pelicula = respuesta
                DispatchQueue.main.async { () -> Void in
                    self.CollectionView2.reloadData()
                }
            }
        }
        
        if collectionView == CollectionView2{
            enviarMovies = pelicula!.results[indexPath.row]
            
            performSegue(withIdentifier: "EnlaceDetailsVC", sender: self)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailController = segue.destination as? DetailsVC {
            DetailController.generalMovie = enviarMovies
            DetailController.delegateP = self
            
            
        }
    }
    
    
    // MARK: - Carga de imagen
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    
    //MARK: protocolo notificacion
    func didSelect(_ string: String) {
        print("ViController didselected: ", string)
        
        // create the alert
        let alert = UIAlertController(title: "Compra Exitosa!", message: "La compra de tus boletos para la pelicula " + string + " ha sido exitosa.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}




