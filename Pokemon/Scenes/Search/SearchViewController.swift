//
//  ViewController.swift
//  pokemonMVC-C
//
//  Created by Gabriel M on 3/30/18.
//  Copyright © 2018 Gabriel M. All rights reserved.
//

import UIKit

protocol PokemonSearchCoordinatorDelegate {
    func toPokemonDetailed(searchDTO: SearchDTO)
}

struct SearchDTO {
    let pokemon: Pokemon
}

class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pikachuStackView: UIStackView!
    
    var coordinatorDelegate: PokemonSearchCoordinatorDelegate?
    private var pokemon: Pokemon? = nil
    
    private let pokemonServices = PokemonServices()
    private lazy var errorAlert: UIAlertController = {
        let a = UIAlertController(title: "Oops", message: "Pokemon not found!", preferredStyle: UIAlertController.Style.alert)
        
        a.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupComponents() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "PokemonTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PokemonTableViewCell.identifier)
    }

    private func searchPokemon() {
        
        guard let searchText = searchBar.text?.lowercased() else {
            return
        }
        
        pokemonServices.getPokemon(identifier: searchText, onSuccess: { (response, pokemon) in
            
            self.pokemon = pokemon
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
    
        }, onFailure: { (response) in
           
            DispatchQueue.main.async {
                self.tableView.isHidden = true
                self.present(self.errorAlert, animated: true, completion: nil)
            }
        })
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier) as! PokemonTableViewCell
        
        if let pokemon = pokemon {
            cell.setup(pokemon: pokemon)
            
            cell.pokemonImageView.kf.setImage(with: pokemon.sprites?.front_default) { (result) in
                switch result {
                    
                case .success(let content):
                    self.pokemon?.pngImage = content.image.pngData()
                case .failure(_):
                    break
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokemon = pokemon else { return }
        let dto = SearchDTO(pokemon: pokemon)
        coordinatorDelegate?.toPokemonDetailed(searchDTO: dto)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchPokemon()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
}
