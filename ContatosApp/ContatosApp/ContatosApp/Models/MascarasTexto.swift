import Foundation

// Extensão para aplicar máscaras em Strings
extension String {
    
    // Máscara para telefone celular: (XX) XXXXX-XXXX
    func aplicarMascaraTelefone() -> String {
        // Remove tudo que não é número
        let numeros = self.filter { $0.isNumber }
        var resultado = ""
        
        // Limita a 11 dígitos
        let digitosLimitados = String(numeros.prefix(11))
        
        for (indice, caractere) in digitosLimitados.enumerated() {
            switch indice {
            case 0:
                resultado.append("(")
                resultado.append(caractere)
            case 2:
                resultado.append(") ")
                resultado.append(caractere)
            case 7 where digitosLimitados.count == 11:
                resultado.append("-")
                resultado.append(caractere)
            case 6 where digitosLimitados.count == 10:
                resultado.append("-")
                resultado.append(caractere)
            default:
                resultado.append(caractere)
            }
        }
        
        return resultado
    }
    
    // Máscara para data de nascimento: DD/MM/AAAA
    func aplicarMascaraData() -> String {
        let numeros = self.filter { $0.isNumber }
        var resultado = ""
        
        let digitosLimitados = String(numeros.prefix(8))
        
        for (indice, caractere) in digitosLimitados.enumerated() {
            if indice == 2 || indice == 4 {
                resultado.append("/")
            }
            resultado.append(caractere)
        }
        
        return resultado
    }
    
    // Máscara para CEP: XXXXX-XXX
    func aplicarMascaraCEP() -> String {
        let numeros = self.filter { $0.isNumber }
        var resultado = ""
        
        let digitosLimitados = String(numeros.prefix(8))
        
        for (indice, caractere) in digitosLimitados.enumerated() {
            if indice == 5 {
                resultado.append("-")
            }
            resultado.append(caractere)
        }
        
        return resultado
    }
    
    // Remove formatação (útil para enviar dados à API)
    func removerFormatacao() -> String {
        return self.filter { $0.isNumber }
    }
}
