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
                        typeLabel.backgroundColor = UIColor(hex: "#A8B820")
                    case "\(NSLocalizedString("dark-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#705848")
                    case "\(NSLocalizedString("dragon-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#7038F8")
                    case "\(NSLocalizedString("electric-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#F8D030")
                    case "\(NSLocalizedString("fairy-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#EE99AC")
                    case "\(NSLocalizedString("fighting-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "C03028")
                    case "\(NSLocalizedString("fire-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#F08030")
                    case "\(NSLocalizedString("flying-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#A890F0")
                    case "\(NSLocalizedString("ghost-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#705898")
                    case "\(NSLocalizedString("grass-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#78C850")
                    case "\(NSLocalizedString("ground-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#E0C068")
                    case "\(NSLocalizedString("ice-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#98D8D8")
                    case "\(NSLocalizedString("normal-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#A8A878")
                    case "\(NSLocalizedString("poison-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#A040A0")
                    case "\(NSLocalizedString("psychic-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#F85888")
                    case "\(NSLocalizedString("rock-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#B8A038")
                    case "\(NSLocalizedString("steel-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#B8B8D0")
                    case "\(NSLocalizedString("water-display-text", comment: ""))":
                        typeLabel.backgroundColor = UIColor(hex: "#6890F0")
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }

        guard hexString.count == 6 || hexString.count == 8,
              let hexValue = UInt64(hexString, radix: 16) else {
            return nil
        }

        if hexString.count == 8 {
            r = CGFloat((hexValue & 0xff000000) >> 24) / 255
            g = CGFloat((hexValue & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexValue & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexValue & 0x000000ff) / 255
        } else {
            r = CGFloat((hexValue & 0xff0000) >> 16) / 255
            g = CGFloat((hexValue & 0x00ff00) >> 8) / 255
            b = CGFloat(hexValue & 0x0000ff) / 255
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, alpha: a)
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
