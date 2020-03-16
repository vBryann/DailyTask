//
//  main.swift
//  DailyTasks
//
//  Created by Brena Amorim on 10/03/20.
//  Copyright © 2020 Brena Amorim. All rights reserved.
//

import Foundation

public func menu (){
    print("""

    Bem vindo ao DailyTask, onde você pode organizar suas atividades diárias!
    Clique em alguma tecla para continuar.

""")
    if let something = readLine(){
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
                case "1": criarTask()
                case "5": break
                default : print("N deu irmao, tente dnv")
            }
        }
    
    }
}

func criarTask (){
    
    //print(Date().description(with: .current))
    let formater = DateFormatter()
    formater.dateFormat = "HH:mm"
    
    let dateAsString = "9:00"
    guard let date = formater.date(from: dateAsString) else { return }
    //é um option, então é preciso tratar
    
    let hourFuture = Calendar.current.component(.hour, from: date)
    let minuteFuture = Calendar.current.component(.minute, from: date)
    // é possivel pegar a hora setada na variável date
    
    print(date.description(with: Locale(identifier: "pt-br")))
    // converte  a hora no padrão pt-br
    
    let datestr = formater.string(from: date)
    print("hora em string: ", datestr)
    print()
    
    let hour = Calendar.current.component(.hour, from: Date())
    let minutes = Calendar.current.component(.minute, from: Date())
    print("Horário atual é \(hour):\(minutes)")
//    let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
//    let hour = components.hour ?? 0
//    let minute = components.minute ?? 0
    
    print()
    
    var task: [(descricao: String, hora: String, tipo: String)] = []
    // cria um array de tasks organizadas em tuplas
    task.append(("Ir pro academy", "7:00", "Faculdade"))
    task.append(("Regar plantinhas", "15:00", "Casa"))
    // teste pra adicionar algumas tasks
    print(task[0].descricao)
    // imprime só a descriçao
    //print(task) -- imprime tudo ex:(descricao: "Ir pro academy", hora: "7:00", tipo: "Faculdade")

}

menu()






