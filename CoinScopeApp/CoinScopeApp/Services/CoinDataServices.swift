//
//  CoinDataServices.swift
//  CoinScopeApp
//
//  Created by Berke Yılmaz on 21.02.2025.
//

import Foundation
import Combine

class CoinDataServices {
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    private var coinAPI = ""
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: coinAPI) else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                } receiveValue: { [weak self](returnedCoins) in
                    self?.allCoins = returnedCoins
                    self?.coinSubscription?.cancel()
            }
    }
}
