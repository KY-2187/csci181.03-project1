import UIKit
import PokemonAPI

struct Pokemon {
    let name: String
    let localizedName: String
    let type: [String]
}

class ViewController: UITableViewController {
    
    let pokemonAPI = PokemonAPI()
    var pokemons: [Pokemon] = []
    
    private static let reuseIdentifier = "identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("page-title", comment: "")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)
        
        for i in 1...151 {
            pokemonAPI.pokemonService.fetchPokemon("\(i)") { result in
                switch result {
                case .success(let pokemon):
                    let types = pokemon.types?.compactMap({ type in
                                        NSLocalizedString("\(type.type?.name?.lowercased() ?? "")-display-text", comment: "")
                                    }) ?? []
                    let poke = Pokemon(name: pokemon.name!.capitalized, localizedName: NSLocalizedString("pokemon-name-\(i)", comment: ""), type: types)
                    self.pokemons.append(poke)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.textLabel?.text = pokemons[indexPath.row].localizedName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPokemon = pokemons[indexPath.row]
        
        let storyboard = UIStoryboard(name: "PokemonInfo", bundle: nil)
        guard let pokemonInfo = storyboard.instantiateViewController(withIdentifier: "info") as? PokemonInfo else {return}
        pokemonInfo.selectedPokemon = selectedPokemon
        self.navigationController?.pushViewController(pokemonInfo, animated: true)
    }
}
