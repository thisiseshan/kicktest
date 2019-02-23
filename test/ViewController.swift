//
//  ViewController.swift
//  test
//
//  Created by Eshan Arora on 20/02/19.
//  Copyright © 2019 Eshan Arora. All rights reserved.
//

import UIKit
import stellarsdk

 let sdk = StellarSDK()

class ViewController: UIViewController {

    @IBAction func newGame(_ sender: Any) {
    
        let sdk = StellarSDK()
        
        sdk.accounts.getAccountDetails(accountId: "GAWE7LGEFNRN3QZL5ILVLYKKKGGVYCXXDCIBUJ3RVOC2ZWW6WLGK76TJ") { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                print("Account ID: \(accountResponse.accountId)")
                print("Account Sequence: \(accountResponse.sequenceNumber)")
                for balance in accountResponse.balances {
                    if balance.assetType == AssetTypeAsString.NATIVE {
                        print("Account balance: \(balance.balance) XLM")
                    } else {
                        print("Account balance: \(balance.balance) \(balance.assetCode!) of issuer: \(balance.assetIssuer!)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        do {
        let sourceAccountKeyPair = try KeyPair(secretSeed:"SA3QF6XW433CBDLUEY5ZAMHYJLJNHBBOPASLJLO4QKH75HRRXZ3UM2YJ")
        let destinationAccountKeyPair = try KeyPair(accountId: "GCKECJ5DYFZUX6DMTNJFHO2M4QKTUO5OS5JZ4EIIS7C3VTLIGXNGRTRC")
            
            
            
            sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
                switch response {
                case .success(let accountResponse): // account exists
                    do {
                        // create the payment operation
                        let paymentOperation = PaymentOperation(sourceAccount: sourceAccountKeyPair,
                                                                destination: destinationAccountKeyPair,
                                                                asset: Asset(type: AssetType.ASSET_TYPE_NATIVE)!,
                                                                amount: 10.0)
                        
                        // create the transaction containing the payment operation
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                        
                        // Sign the transaction to prove you are actually the person sending it.
                        try transaction.sign(keyPair: sourceAccountKeyPair, network: Network.testnet)
                        
                        // And finally, send it off to Stellar!
                        try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                            case .success(_):
                                print("Transaction successfully sent!")
                            case .failure(let error):
                                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Sample", horizonRequestError:error)
                            }
                        }
                    } catch {
                        print ("...")
                    }
                case .failure(let error):
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Sample", horizonRequestError:error)
                    
                }
            }
        } catch {
            print("...")
        }
      
       

        
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    


}

