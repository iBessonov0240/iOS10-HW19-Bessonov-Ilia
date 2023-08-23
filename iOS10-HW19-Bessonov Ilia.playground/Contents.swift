import UIKit

enum NetWorkError: Error {
    case networkProblem
    case badRequest
    case badResponce
    case notFound
}

extension NetWorkError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .networkProblem: return "No Internet Connection"
        case .badRequest: return "Bad Request: 400"
        case .badResponce: return "Bad Responce"
        case .notFound: return "Not Found: 404"
        }
    }
}

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error as NSError? {
            switch error.code {
            case NSURLErrorNotConnectedToInternet:
                NetWorkError.networkProblem.errorDescription
                print("No Internet Connection")
            case NSURLErrorBadServerResponse:
                NetWorkError.badResponce.errorDescription
                print("Bad Responce")
            case NSURLErrorBadURL:
                NetWorkError.badRequest.errorDescription
                print("Bad Request: 400")
            case NSURLErrorCannotFindHost:
                NetWorkError.notFound.errorDescription
                print("Not Found: 404")
            default:
                print("Error: \(error)")
            }
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print("Status code: \(response.statusCode)\n")
            print("\(String(describing: dataAsString))")
        }
    }.resume()
}
// Первое задание если код 200
//getData(urlRequest: "https://screenshotlayer.com/")

// Первое задание если код 404
//getData(urlRequest: "https://screenshotlayerLoL.com/")


// Задание со звездочкой
getData(urlRequest: "http://gateway.marvel.com/v1/public/comics?ts=1&apikey=cb27167c4dce10cd59fb1968b971df57&hash=3768edceb96d70710ab3045fea36fc6d")

// MARK: - Задача со звездочкой

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

//Test:
let md5Data = MD5(string:"13b6e5fc305dfea5cf76ed702282b46cb4def0ed1cb27167c4dce10cd59fb1968b971df57")

let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
print("md5Hex: \(md5Hex)")

let md5Base64 = md5Data.base64EncodedString()
print("md5Base64: \(md5Base64)\n")
