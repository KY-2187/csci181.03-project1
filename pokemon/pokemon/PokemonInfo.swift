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
        self.navigationItem.title = selectedPokemon?.localizedName
        let name = selectedPokemon?.name.lowercased() ?? ""
        
        pokemonAPI.pokemonService.fetchPokemon(name) { result in
            switch result {
            case .success(let pokemon):
                guard let imageURLString = pokemon.sprites?.frontDefault, let url = URL(string: imageURLString)
                else { return }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
                
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let alert = UIAlertController(
                        title: "An error occurred",
                        message: "Failed to load Pokemon. Please check your internet connection and try again.",
                        preferredStyle: .alert
                    )
                    let okayAction = UIAlertAction(title: "Okay", style: .cancel) { _ in
                        print("Okay")
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        setupUI()
    }
    
    func setupUI() {
        nameLabel.text = selectedPokemon?.localizedName
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(typeStackView)
        
        if let types = selectedPokemon?.type {
            for type in types {
                let typeLabel = UILabelPadded()
                typeLabel.text = type
                typeLabel.layer.cornerRadius = 8
                typeLabel.clipsToBounds = true
                switch type {
                    case "\(NSLocalizedString("bug-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Bug")
                    case "\(NSLocalizedString("dark-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Dark")
                    case "\(NSLocalizedString("dragon-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Dragon")
                    case "\(NSLocalizedString("electric-display-text", comment: ""))":
                    typeLabel.backgroundColor = UIColor(named: "Electric")
                    case "\(NSLocalizedString("fairy-display-text", comment: ""))":
                    typeLabel.backgroundColor = UIColor(named: "Fairy")
                    case "\(NSLocalizedString("fighting-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Fighting")
                    case "\(NSLocalizedString("fire-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Fire")
                    case "\(NSLocalizedString("flying-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Flying")
                    case "\(NSLocalizedString("ghost-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Ghost")
                    case "\(NSLocalizedString("grass-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Grass")
                    case "\(NSLocalizedString("ground-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Ground")
                    case "\(NSLocalizedString("ice-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Ice")
                    case "\(NSLocalizedString("normal-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Normal")
                    case "\(NSLocalizedString("poison-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Poison")
                    case "\(NSLocalizedString("psychic-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Psychic")
                    case "\(NSLocalizedString("rock-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Rock")
                    case "\(NSLocalizedString("steel-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Steel")
                    case "\(NSLocalizedString("water-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(named: "Water")
                    default:
                        typeLabel.backgroundColor = UIColor.white
                }
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

class UILabelPadded: UILabel {
    let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
