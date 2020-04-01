//
//  main.swift
//  DailyTasks
//
//  Created by Brena Amorim and Vitor Bryan on 10/03/20.
//  Copyright © 2020 Brena Amorim. All rights reserved.
//

import Foundation


public struct PersistenceManager {
   
   //Funcao que acessa o diretório Documents no Mac
   func getDocumentsDirectory() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
   }
   //Funcao que persiste dados em um arquivo
   func write(data: Data, toFile path: String) {
       let fm = FileManager.default
       let filePath = getDocumentsDirectory().appendingPathComponent(path)
       //cria o arquivo, ou caso exista ele sobrescreve o existente
       let _ = fm.createFile(atPath: filePath.relativePath, contents: data, attributes: nil)

    
    //essa função reconhece se o arquivo existe e escreve no final da linha do mesmo
        /*if fm.fileExists(atPath: filePath.path){
            if let fileHandle = try? FileHandle(forWritingTo: filePath){
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()

            }
        } else {
               //Cria um arquivo no diretório especificado, e tenta escrever o conteudo em formato Data nesse arquivo.
            let _ = fm.createFile(atPath: filePath.relativePath, contents: data, attributes: nil)
        }*/
    }
   //Funcao que ler dados de um arquivo
   func read(fromFile filename: String) -> Data? {
       let fm = FileManager.default
       let path = getDocumentsDirectory().appendingPathComponent(filename).relativePath
       
       //leitura do conteúdo de um diretório
       let data = fm.contents(atPath: path)
       return data //retorna o conteúdo lido
   }
   
}


struct Task: Codable{
    var descricao: String
    var tipo: String
    var hora: String
    var status: String
    
}

enum PersistenceError: Error {
   case deuRuimNaLeitura
   case deuRuimNaEscrita
}




public func menu (){
    var condition = true
    func repete (){
        var flag = true
        while flag {
            print("\nVocê quer continuar no programa? s/n")
            if let command2 = readLine(){
                switch command2{
                case "s","S":
                    condition = true
                    flag = false
                case "n","N":
                    condition = false
                    flag = false
                default:
                    print("Comando inválido")
                }
            }
        }
    }
    print("""

    Bem vindo ao DailyTask, onde você pode organizar suas atividades diárias!

    """)
    while condition{
        print("\nClique em alguma tecla para continuar.")
        if readLine() != nil  {
            print("""

                ==================== Menu =====================
                ||                                           ||
                ||                                           ||
                ||               1. Criar Task               ||
                ||               2. Editar Task              ||
                ||               3. Completar Task           ||
                ||               4. Listar Task              ||
                ||                                           ||
                ||               5. Sair                     ||
                ||                                           ||
                ===============================================

            """)
            if let command = readLine(){
                switch command{
                    case "1": try? criarTask()
                        repete()
                    case "2": editarTask()
                        repete()
                    case "4": let _ = listarTask()
                        repete()
                    case "3": completarTask()
                        repete()
                    case "5":
                    condition = false
                    break
                    default : print("N deu irmao, tente dnv. Pressione alguma tecla pra continuar")
                }
            }
        
        }
    }
}

public func criarTask () throws{
    
    let formater = DateFormatter()
    formater.dateFormat = "HH:mm"
       
    

    print("\nInforme a descrição da task.")
    if let descricaoInput = readLine(){
        
        print("\nInforme o tipo da task. Ex: Estudos, Exercícios, Lazer etc.")
        if let tipoInput = readLine(){
        
            //var dateAsString = "0:00"
            print("\nInforme a hora da task. Ex: 12:00")
            while let horaInput = readLine(){
                var number: [Character] = []
                //separando os caracteres da hora para fazer o tratamento
                for aux in horaInput {
                    number.append(aux)
                }
                let hour = String(number[0]) + String(number[1])
                let minute = String(number[3]) + String(number[4])
               //transformando os chars separados em int
                let hourInt = Int(hour)
                let minuteInt = Int(minute)
                
                //comparação de hora invalida
                if (hourInt! > 23) || ( minuteInt! > 59){
                    print("\nHorário inválido, tente novamente.")
                    //Pode ser mudado pra tratamento de errors
                    continue
                }else{
                    //Para guardar o valor
                    let manager = PersistenceManager()
                    let encoder = JSONEncoder()
                    
                    //a task mais recente
                    let task = Task(descricao:descricaoInput,tipo:tipoInput,hora:horaInput,status:"🟥")
                    
                    var arrayData : [Task] = []
                    //leitura dos dados pra caso exista um arquivo
                    let readData : Data? = manager.read(fromFile: "arquivo.json")
                    if (readData != nil) {
                        let decoder = JSONDecoder()
                        let taskReceived = try decoder.decode([Task].self,
                                                      from: readData!)
                        //após receber os arquivos, salva num array os dados existentes com o novo
                        arrayData.append(contentsOf: taskReceived)
                        arrayData.append(task)
                        
                        if let array = try? encoder.encode(arrayData){
                        
                            if let json = String(data: array, encoding: .utf8){
                                guard let data = json.data(using: .utf8) else{
                                    print("\nConverter content para Data retornou nulo!")
                                    throw PersistenceError.deuRuimNaLeitura
                                }
                                //"Update" com os dados atuais
                                let _ = manager.write(data: data, toFile: "arquivo.json")
                                print("\nOperação realizada com sucesso!")
                            }
                        }
                        
                    }else {
                        arrayData.append(task)
                        if let array = try? encoder.encode(arrayData){
                              //Aqui faz o encoding da Struct
                              if let json = String(data: array, encoding: .utf8) {
                                  guard let data = json.data(using: .utf8) else{
                                      print("\nConverter content para Data retornou nulo!")
                                      throw PersistenceError.deuRuimNaLeitura
                                  }
                                  
                                  let _ = manager.write(data: data, toFile: "arquivo.json")
                                  print("\nOperação realizada com sucesso!")
                              }
                      
                          }
                    }
                    
                    break
                }
            }
        }
    }
}

public func listarTask() -> Bool{
    
    let manager = PersistenceManager()
   
    
    
    let readData: Data? = manager.read(fromFile: "arquivo.json")
    if (readData != nil){
        do {
              let decoder = JSONDecoder()
              let task = try decoder.decode([Task].self,from: readData!) //entre [] pra representar o array de Tasks
            //let count = task.count
            print("""

                Tasks para hoje:
                
                """)
            var count = 1
            for tarefa in task{
                print("\(count) -  \(tarefa.descricao), do tipo \(tarefa.tipo), às \(tarefa.hora), status \(tarefa.status)")
                count += 1
            }
        
        } catch let parsingError {

          print("Error", parsingError)
            
        }
        return true
    }else {
        print("Você não tem tasks ainda!")
        return false
    }
    /*if let readData = readData, let stringFromData = String(data: readData, encoding: .utf8) {
        print(stringFromData)
      } else {
        //Se nao, printa que houve algum problema
        print("Nao foi possivel converter data para o tipo String!")
        }
        */
    
}

public func editarTask(){
    let manager = PersistenceManager()
    let condition = listarTask()
    if condition {
        print("\nQual task você deseja editar? Digite o número da task:")
        var arrayData : [Task] = []
        
        if let numTask = readLine(){
            let numTasked: Int! = Int(numTask)
            let readData: Data? = manager.read(fromFile: "arquivo.json")
            do {
                let decoder = JSONDecoder()
                let task = try decoder.decode([Task].self,from: readData!)
                
                arrayData.append(contentsOf: task)
                let chooseTask = arrayData[numTasked - 1]
                
                print("\nTask a ser editada:  \(chooseTask.descricao), do tipo \(chooseTask.tipo), às \(chooseTask.hora), status \(chooseTask.status)")
                print("\nInforme a descrição da task a ser editada:")
                if let descricaoInput = readLine(){
                    
                    print("\nInforme o tipo da task a ser editada: (Ex: Estudos, Exercícios, Lazer etc.)")
                    if let tipoInput = readLine(){
                    
                        //var dateAsString = "0:00"
                        print("\nInforme a hora da task a ser editada: (Ex: 12:00)")
                        while let horaInput = readLine(){
                            var number: [Character] = []
                            //separando os caracteres da hora para fazer o tratamento
                            for aux in horaInput {
                                number.append(aux)
                            }
                            let hour = String(number[0]) + String(number[1])
                            let minute = String(number[3]) + String(number[4])
                           //transformando os chars separados em int
                            let hourInt = Int(hour)
                            let minuteInt = Int(minute)
                            
                            //comparação de hora invalida
                            if (hourInt! > 23) || ( minuteInt! > 59){
                                print("\nHorário inválido, tente novamente.")
                                //Pode ser mudado pra tratamento de errors
                                continue
                            }else{
                                let task = Task(descricao:descricaoInput,tipo:tipoInput,hora:horaInput,status:"🟥")
                                arrayData[numTasked - 1] = task
                                let encoder = JSONEncoder()
                                if let array = try? encoder.encode(arrayData){
                                
                                    if let json = String(data: array, encoding: .utf8){
                                        guard let data = json.data(using: .utf8) else{
                                            print("\nConverter content para Data retornou nulo!")
                                            throw PersistenceError.deuRuimNaLeitura
                                        }
                                        //"Update" com os dados atuais
                                        let _ = manager.write(data: data, toFile: "arquivo.json")
                                        print("\nOperação realizada com sucesso!")
                                    }
                                    
                                }
                            }
                            break
                
                        }
                    }
                }
                
            }catch let parsingError {

                print("Error", parsingError)

            }
        
        }
    }
}

func completarTask(){
    let manager = PersistenceManager()
    let condition = listarTask()
    if condition {
        print("\nQual task você deseja concluir? Digite o número da task:")
        var arrayData : [Task] = []
        
        if let numTask = readLine(){
            let numTasked: Int! = Int(numTask)
            let readData: Data? = manager.read(fromFile: "arquivo.json")
            do {
                let decoder = JSONDecoder()
                let task = try decoder.decode([Task].self,from: readData!)
                
                arrayData.append(contentsOf: task)
                arrayData[numTasked - 1].status = "✅"
                let encoder = JSONEncoder()
                if let array = try? encoder.encode(arrayData){
                
                    if let json = String(data: array, encoding: .utf8){
                        guard let data = json.data(using: .utf8) else{
                            print("\nConverter content para Data retornou nulo!")
                            throw PersistenceError.deuRuimNaLeitura
                        }
                        //"Update" com os dados atuais
                        let _ = manager.write(data: data, toFile: "arquivo.json")
                        print("\nOperação realizada com sucesso!")
                    }
                    
                }
                
                
            }catch let parsingError {

                print("Error", parsingError)

            }
        }
    }
}

menu()







