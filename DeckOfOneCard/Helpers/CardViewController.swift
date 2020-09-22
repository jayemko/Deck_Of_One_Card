//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by Jason Koceja on 9/22/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func fetchImageAndUpdateView(for card: Card) {
        CardController.fetchImage(for: card){ (result) in
            
            DispatchQueue.main.async {
                switch result {
                    case .success(let image):
                        self.cardLabel.text = "\(card.value) of \(card.suit)"
                        self.cardImageView.image = image
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    @IBAction func drawButtonTapped(_ sender: UIButton) {
        CardController.fetchCard { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let card):
                        self.fetchImageAndUpdateView(for: card)
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                }
            }
        }
        
    }
    
}
