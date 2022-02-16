//
//  ViewController.swift
//  Notas Diárias
//
//  Created by Josue Herrera Rodrigues on 12/09/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //      Acessando a class AppDelegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //      Acessando o viewContext = Objeto responsavel para manipulacao e gerenciamento dos dados
                context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacoes()
        
    }
    
    func recuperarAnotacoes(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
//      Organizando para sempre que um novo item for criado ou atualizado, ficar em primeiro na lista
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let erro {
            print("Erro ao salvar anotacao" + erro.localizedDescription)
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let anotacao = self.anotacoes[indexPath.row]
        
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao" {
            
            let viewDestino = segue.destination as! AnotacaoViewController
            
            viewDestino.anotacao = sender as? NSManagedObject
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let celulaReuso = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        let anotacao = self.anotacoes[indexPath.row]
        
//      Recuperando a anotacao salva em TEXTO e da DATA atual e armazenando dentro das CONSTANTES
        let textoRecuperado = anotacao.value(forKey: "texto")
        let dataRecuperada = anotacao.value(forKey: "data")
        
//      Formatando o lay-out da DATA
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " dd/MM/yyyy hh:mm "
//      Convertendo o dateFormatter em um STRING
        let novaData = dateFormatter.string(from: dataRecuperada as! Date)

//      Apresentando TEXTO e DATA na tela do usuario
        celulaReuso.textLabel?.text = (textoRecuperado as! String)
        celulaReuso.detailTextLabel?.text = novaData
        
        return celulaReuso
}
//  Funcao para deletar itens da tabela
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let anotacao = self.anotacoes[indexPath.row]
//          Removendo do banco de dados (Core Data)
            self.context.delete(anotacao)
//          Removendo do array
            self.anotacoes.remove(at: indexPath.row)
//          Removendo o item especifico da tabela
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try self.context.save()
                print("Sucesso ao deletar o item da tabela!!")
            } catch let erro {
                print("Erro ao remover o item!!" + erro.localizedDescription)
            }
        }
    }
}

