//
//  main.swift
//  DailyTasks
//
//  Created by Brena Amorim and Vitor Bryan on 10/03/20.
//  Copyright © 2020 Brena Amorim. All rights reserved.
//

import Foundation

public func menu (){
    var condition = true
    print("""

        Bem vindo ao DailyTask, onde você pode organizar suas atividades diárias!

    """)
    while condition{
        print("\nClique em alguma tecla para continuar.")
        if readLine() != nil  {
            print("""

        ---------------------Menu---------------------


        1. Criar Task
        2. Editar Task
        3. Completar Task
        4. Listar Task

        5. Sair

        ----------------------------------------------

    """)
            if let command = readLine(){
                switch command{
                    case "1": try? criarTask()
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
                    //case "2":
                    //editarTask()
                    //condition = false
                    case "5":
                    condition = false
                    break
                    default : print("N deu irmao, tente dnv. Pressione alguma tecla pra continuar")
                }
            }
        
        }
    }
}

func criarTask () throws{
    
    let formater = DateFormatter()
    formater.dateFormat = "HH:mm"
    enum PersistenceError: Error {
       case deuRuimNaLeitura
       case deuRuimNaEscrita
    }
   
    struct PersistenceManager {
       
       //Funcao que acessa o diretório Documents no Mac
       func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
       //Funcao que persiste dados em um arquivo
       func write(data: Data, toFile path: String) -> Bool {
           let fm = FileManager.default
           let filePath = getDocumentsDirectory().appendingPathComponent(path).relativePath
           
           //Cria um arquivo no diretório especificado, e tenta escrever o conteudo em formato Data nesse arquivo.
           let sucess = fm.createFile(atPath: filePath, contents: data, attributes: nil)
           return sucess // retorna se a escrita foi bem sucedida
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
        
    }
    
    
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
                    //dateAsString = horaInput
                    //guard let date = formater.date(from: dateAsString) else { return }
                    //é um option, então é preciso tratar
                    //let hourFuture = Calendar.current.component(.hour, from: date)
                    //let minuteFuture = Calendar.current.component(.minute, from: date)
                    // é possivel pegar a hora setada na variável date
                    //task.append((descricaoInput,tipoInput,horaInput))
                    let manager = PersistenceManager()
                    
                    let task = Task(descricao:descricaoInput,tipo:tipoInput,hora:horaInput)
                    
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(task){
                        //Aqui faz o encoding da Struct
                        if let json = String(data: encoded, encoding: .utf8) {
                            guard let data = json.data(using: .utf8) else{
                                print("Converter content para Data retornou nulo!")
                                throw PersistenceError.deuRuimNaLeitura
                            }
                            let success = manager.write(data: data, toFile: "arquivo.json")
                            print("Bem sucedido:",success)
                        }
                    break
                
                }
        
            }
        }
    }
    //print(date.description(with: Locale(identifier: "pt-br")))
    // converte  a hora no padrão pt-br
    //let datestr = formater.string(from: date)
    //print("hora em string: ", datestr)
    //print()
    
    //let hour = Calendar.current.component(.hour, from: Date())
    //let minutes = Calendar.current.component(.minute, from: Date())
    //print("Horário atual é \(hour):\(minutes)")
    //    let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
    //    let hour = components.hour ?? 0
    //    let minute = components.minute ?? 0
    
    //print()
    // cria um array de tasks organizadas em tuplas
    //task.append(("Ir pro academy", "7:00", "Faculdade"))
    //task.append(("Regar plantinhas", "15:00", "Casa"))
    // teste pra adicionar algumas tasks
    //print(task[0].descricao)
    // imprime só a descriçao
    //print(task) //-- imprime tudo ex:(descricao: "Ir pro academy", hora: "7:00", tipo: "Faculdade")
   
    
}
/*func editarTask () throws{
           let decoder = JSONDecoder()
        //Aqui faz o decoding da Struct
           if let decoded = try? decoder.decode(Task.self, from: encoded) {
               print(decoded)
           }
    }*/
    // Aqui, no caso de JSON, você usa o JSONEncoder() pra converter uma Struct que está em conformidade com o protocolo Encodable para o tipo Data?. O guard let darante que essa conversão deu certo e Data não é nil. Lembrando que Codable é a junção de ambos protocolos, Encodable e Decodable.

    //Conversão da String content para o tipo Data
   

    // chamando a função write para criar um arquivo

    // chamando a função read para ler o conteúdo do arquivo e retorná-lo em formato Data?
    //let readData: Data? = manager.read(fromFile: "arquivo.txt")

    //Aqui você pode usar o data pra construir um struct com JSONDecoder() e retorná-lo na função.
    //Decode Data? -> AlgumaStruct, essa struct sendo Decodable. Lembrando que Codable é Encodable e Decodable ao mesmo tempo.

    //Nesse exemplo, estamos lendo e retornando dados do tipo String
    //Se data nao for nula e for convertível para String, converte pra string e printa
    //if let readData = readData, let stringFromData = String(data: readData, encoding: .utf8) {
      //  print(stringFromData)
    //} else {
        //Se nao, printa que houve algum problema
    //    print("Nao foi possivel converter data para o tipo String!")
    //}
    
}





menu()






