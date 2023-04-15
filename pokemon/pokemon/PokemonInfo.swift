//
//  PokemonInfo.swift
//  pokemon
//
//  Created by Kyra Hung on 4/15/23.
//

import UIKit
import PokemonAPI

class PokemonInfo: UIViewController {
    var selectedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedPokemon?.name
    }
}
