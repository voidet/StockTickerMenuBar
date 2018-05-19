import Foundation

struct Stock {
  var symbol: String
  var changePercent: Double
  var price: Double
}

class AlphaAdvantageAPI {
  let BASE_URL = "https://api.iextrading.com/1.0/stock/market/batch?symbols=%@&types=quote&range=1m&last=5"
  
  func fetchStocks(_ symbols: [String]) {
    let session = URLSession.shared
    let urlString = String(format: BASE_URL, symbols.joined(separator: ","))
    let escapedQuery = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let url = URL(string: escapedQuery)
    
    print("Fetching \(url!)")
    
    let task = session.dataTask(with: url!) { data, response, err in

      if let error = err {
        NSLog("Error fetching quotes: \(error)")
      }
      
      // then check the response code
      if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200: // all good!
          let _ = self.parseStocks(data!)
        case 401: // unauthorized
          NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
        default:
          NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
        }
      }
    }
    task.resume()
  }
  
  private func parseStocks(_ data: Data) -> [Stock]? {
    let json:[String: AnyObject]
    
    do {
      json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
    } catch {
      NSLog("JSON parsing failed: \(error)")
      return nil
    }
    
    let stockDict = json as! [String: [String: AnyObject]]
    var stocks = [Stock]()
    
    for (_, value) in stockDict {
      if let quote = value["quote"] as? [String: AnyObject] {
        stocks.append(Stock(symbol: quote["symbol"] as! String,
                            changePercent: quote["changePercent"] as! Double * 100,
                            price: quote["latestPrice"] as! Double))
      }
    }
    
    return stocks
  }
  
}
