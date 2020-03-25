//
//  ViewController.swift
//  homework_19
//
//  Created by Александра Лесничая on 3/22/20.
//  Copyright © 2020 Alexandra Lesnichaya. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let refreshControl = UIRefreshControl()

    var currencies: [CurrencyInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()

        refreshCurrencyRates()
    }

    func configureTableView() {
        refreshControl.addTarget(self, action: #selector(refreshCurrencyRates), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func mapCurrencyModel(_ currencyModel: CurrencyModel) -> [CurrencyInfo] {
        return [
            CurrencyInfo(name: "BYN", rate: currencyModel.rates.BYN),
            CurrencyInfo(name: "RUB", rate: currencyModel.rates.RUB),
            CurrencyInfo(name: "USD", rate: currencyModel.rates.USD)
        ]
    }

    func returnDate(_ currencyModel: CurrencyModel) -> String {
        return currencyModel.date
    }

    @objc func refreshCurrencyRates() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            NetworkManager.shared.loadRates { result in
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                switch result {
                case .success(let currencyModel):
                    self.currencies = self.mapCurrencyModel(currencyModel)
                    self.title = "Exchange rates on \(self.returnDate(currencyModel))"
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension ExchangeRatesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let currency = currencies[indexPath.row]
        cell?.textLabel?.text = "EUR -> \(currency.name): \(currency.rate)"
        return cell!
    }
}

