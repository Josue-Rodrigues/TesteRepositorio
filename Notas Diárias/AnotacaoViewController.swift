//
//  AnotacaoViewController.swift
//  Notas Diárias
//
//  Created by Josue Herrera Rodrigues on 12/09/21.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    
    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Dizendo que este campo de texto sera o primeiro a usar o teclado
        self.texto.becomeFirstResponder()
        
        if anotacao != nil { /* atualizada */
            if let textoRecuperado = anotacao.value(forKey: "texto") {
                self.texto.text = String(describing: textoRecuperado)
            }
            
        } else {
            self.texto.text = ""
        }
        
        //      Acessando a class AppDelegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //      Acessando o viewContext = Objeto responsavel para manipulacao e gerenciamento dos dados
                context = appDelegate.persistentContainer.viewContext
    }
    
    func AlertaSalvar (){
        
        let alerta = UIAlertController(title: "CONGRATULATION", message: "Sucesso ao salvar anotacao!!", preferredStyle: .alert)
        
        let continuar = UIAlertAction(title: "Continuar", style: .destructive, handler: {(action) in self.navigationController?.popToRootViewController(animated: true)})
        
        alerta.addAction(continuar)
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    func AlertaAtualizar (){
        
        let alerta = UIAlertController(title: "CONGRATULATION", message: "Sucesso ao atualizar anotacao!!", preferredStyle: .alert)
        
        let continuar = UIAlertAction(title: "Continuar", style: .destructive, handler: {(action) in self.navigationController?.popToRootViewController(animated: true)})
        
        alerta.addAction(continuar)
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    @IBAction func salva(_ sender: Any) {
 
        if anotacao != nil {/* atualizar */
            self.atualizarAnotacoes()
            
        }else{
//          Chamando a funcao SalvarAnotacao
            self.salvarAnotacoes()
        }
        
//          Retornar para tela principal apos a acao de salvar
            self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func atualizarAnotacoes(){
        
//      Configurando anotacao - Recebendo o valor e salvando dentro da chave (ForKey)
        anotacao.setValue ( self.texto.text, forKey: "texto" )
        anotacao.setValue ( Date(), forKey: "data" )
                
            do {
                try context.save()
//              Chamando a funcao ALERTA
                AlertaAtualizar()
                print("Sucesso ao atualizar o item!!")
                    
            } catch let erro {
                print("Erro ao atualizar anotacao!!" + erro.localizedDescription)
            }
    }
    
    func salvarAnotacoes(){
//      Criando objeto para anotacao
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
        
//      Configurando anotacao - Recebendo o valor e salvando dentro da chave (ForKey)
        novaAnotacao.setValue ( self.texto.text, forKey: "texto" )
        novaAnotacao.setValue ( Date(), forKey: "data" )
        
        do {
            try context.save()
//          Chamando a funcao ALERTA
            AlertaSalvar()
            print("Congratulation!!")
            
        } catch let erro {
            print("Erro ao salvar anotacao!!" + erro.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
