//
//  Pokemon.swift
//  Pokedex
//
//  Created by Isaac Prunty on 2/10/17.
//  Copyright © 2017 Isaac Prunty. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLevel: String {
    
        if _nextEvolutionLevel == nil {
        
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionID: String {
        
        if _nextEvolutionID == nil {
            
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
    
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String {
    
        if _description == nil {
        
            _description = ""
        }
        return _description
    }
    
    var type: String {
    
        if _type == nil {
        
            _type = ""
        }
        return _type
    }
    
    var defense: String {
    
        if _defense == nil {
        
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        
        if _height == nil {
        
            _height = ""
        }
        return _height
    }
    
    var weight: String {

        if _weight == nil {
        
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
    
        if _attack == nil {
        
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
    
        if _nextEvolutionTxt == nil {
            
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var name: String {
        
        return _name
    }
    
    var pokedexID: Int {
    
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
    
    
        self._name = name
        self._pokedexID = pokedexID
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
        
    }
    
    func dowloadPokemonDetails(completed: @escaping DownloadComplete) {
    
        Alamofire.request(_pokemonURL).responseJSON { (response) in
        
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
            
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                
                
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                
                    if let name = types[0]["name"] {
                    
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                    
                        for x in 1..<types.count {
                        
                            if let name = types[x]["name"] {
                            
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    print(self._type)
                
                } else {
                
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                
                    if let url = descArr[0]["resource_uri"] {
                    
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                            
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                
                    if let nextEvo = evolutions[0]["to"] as? String {
                    
                        if nextEvo.range(of: "mega") == nil {
                        
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                            
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                
                                    if let lvl = lvlExist as? Int {
                                    
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                    
                                } else {
                                
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        
                        }
                        
                    }
                    
                    print(self.nextEvolutionID)
                    print(self.nextEvolutionName)
                    print(self.nextEvolutionLevel)
                
                }
                
                
            }
            completed()
        }
    }
    
}































