//
//  ViewController.swift
//  Preço do Bitcoin
//
//  Created by LEANDRO RAINHA on 27/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var precoBit: UILabel!
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizarPreco(_ sender: UIButton) {
        self.recuperarPrecoBit()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recuperarPrecoBit()
    }
    
    func formatarPreco(preco: NSNumber) -> String{
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        return "0,00"
    }
    
    func recuperarPrecoBit(){
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/ticker"){
          
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil {

                    if let dadosRetorno = dados {
                       
                        
                        do{
                            
                           if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: [])
                                as? [String: Any ]{
                               
                               if let brl = objetoJson["BRL"] as? [String: Any ] {
                                   if let preco = brl["buy"] as? Double{
                                       let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                       
                                       DispatchQueue.main.async(execute: {
                                           self.precoBit.text = "R$ " + precoFormatado
                                           self.botaoAtualizar.setTitle("Atualizar", for: .normal)


                                       })
                                   }
                               }

                           }
                            
                        }catch{
                           print("Erro ao formatar o retorno")
                        }
                    }


                }else{
                    print("Erro ao fazer a consulta de preço.")
                }
        }
            tarefa.resume()
            
        }//ifm IF
    }


}

