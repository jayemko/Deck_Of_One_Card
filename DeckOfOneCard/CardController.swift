//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Jason Koceja on 9/22/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import Foundation
import UIKit.UIImage

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func fetchCard(completion: @escaping (Result<Card,CardError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let countItem = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [countItem]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: finalURL) { (data,_,error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let topLvlObj = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLvlObj.cards.first else {
                    return completion(.failure(.noData))
                }
                return completion(.success(card))
            } catch {
                return completion(.failure(.noData))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        let imageURL = card.image
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.unableToDecode))}
            guard let cardImage = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            return completion(.success(cardImage))
        }.resume()
    }
}
