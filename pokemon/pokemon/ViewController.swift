import UIKit
import PokemonAPI

class ViewController: UITableViewController {
    
    var pokemonNames: [String] = []
    let pokemonAPI = PokemonAPI()
    private static let reuseIdentifier = "identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Pokemon (en)"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)
        
        for i in 1...151 {
            pokemonAPI.pokemonService.fetchPokemon("\(i)") { result in
                switch result {
                case .success(let pokemon):
                    self.pokemonNames.append(pokemon.name!.capitalized)
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
        return pokemonNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.textLabel?.text = pokemonNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
