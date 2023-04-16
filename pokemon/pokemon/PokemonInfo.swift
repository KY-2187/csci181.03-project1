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
    let pokemonAPI = PokemonAPI()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let typeStackView: UIStackView = {
        let typeStack = UIStackView()
        typeStack.translatesAutoresizingMaskIntoConstraints = false
        typeStack.axis = .horizontal
        typeStack.spacing = 10
        return typeStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedPokemon?.name
        let name = selectedPokemon?.name.lowercased() ?? ""
        
        pokemonAPI.pokemonService.fetchPokemon(name) { result in
            switch result {
            case .success(let pokemon):
                guard let spriteURLString = pokemon.sprites?.frontDefault, let url = URL(string: spriteURLString) else {
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        setupUI()
    }
    
    func setupUI() {
        nameLabel.text = selectedPokemon?.name
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(typeStackView)
        
        if let types = selectedPokemon?.type {
            for type in types {
                let typeLabel = UILabel()
                typeLabel.text = type
                typeLabel.font = UIFont.systemFont(ofSize: 20)
                typeStackView.addArrangedSubview(typeLabel)
            }
        }
        
        let guide = view.safeAreaLayoutGuide
        let constraints = [
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
