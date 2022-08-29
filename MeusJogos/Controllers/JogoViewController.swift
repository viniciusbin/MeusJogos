//
//  JogoViewController.swift
//  MeusJogos
//
//  Created by Vinicius on 28/08/22.
//

import UIKit

class JogoViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelConsole: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

       
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelTitle.text = game.title
        labelConsole.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            labelDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
        if let image = game.cover as? UIImage {
            imageViewCover.image = image
        } else {
            imageViewCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditOrAddViewController
        vc.game = game
    }
    
    



}
