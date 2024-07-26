import Foundation

extension String {    
    func color(_ color: String) -> String {
        //return Array(self).map({ "\($0)\u{fe07}"}).joined()
        return Array(self).map({ "\($0)\(String(color))" }).joined()
    }
}

extension String {
    var sourcefile: String {
        let components = self.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last ?? ""
    }
}
