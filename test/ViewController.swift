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

    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBAction func newGame(_ sender: Any) {
    
       
        
        // create a completely new and unique pair of keys.
        let keyPair = try! KeyPair.generateRandomKeyPair()
        
        print("Account Id: " + keyPair.accountId)
        // GCFXHS4GXL6BVUCXBWXGTITROWLVYXQKQLF4YH5O5JT3YZXCYPAFBJZB
        
        print("Secret Seed: " + keyPair.secretSeed)
        // SAV76USXIJOBMEQXPANUOQM6F5LIOTLPDIDVRJBFFE2MDJXG24TAPUU7

        
    
        // Ask the SDK to create a testnet account for you. It’ll ask the Sellar Testnet Friendbot to create the account.
        sdk.accounts.createTestAccount(accountId: keyPair.accountId) { (response) -> (Void) in
            switch response {
            case .success(let details):
                DispatchQueue.main.async {
                    
                    self.label1.text = "Account 1 created"
                    
                }
                print(details)
                
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error:", horizonRequestError: error)
            }
        }
        
        
        // Destination Account
        
        // create a completely new and unique pair of keys.
        let keyPair2 = try! KeyPair.generateRandomKeyPair()
        
        print("Account Id: " + keyPair2.accountId)
        // GCWODM5VN44LFRFSWLEU7TOAD366BBRT4UMUCV4KDZWQC3DKJAFI5BN6
        
        print("Secret Seed: " + keyPair2.secretSeed)
        // SD42ITDCOSG6N6SFKU4DYSUSDB7CTU5CE3WYRKSY45Y7CLRUHBECWNV5
        
        
        
        // Ask the SDK to create a testnet account for you. It’ll ask the Sellar Testnet Friendbot to create the account.
        sdk.accounts.createTestAccount(accountId: keyPair2.accountId) { (response) -> (Void) in
            switch response {
            case .success(let details):
                DispatchQueue.main.async {
                    
                    self.label2.text = "Account 2 created"
                    
                }
                print(details)
                
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error:", horizonRequestError: error)
            }
        }
        
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
        
        
        do {
        let sourceAccountKeyPair = try KeyPair(secretSeed: String(keyPair.secretSeed))
        
        print (sourceAccountKeyPair)
        
        let destinationAccountKeyPair = try KeyPair(accountId: String(keyPair2.accountId))
        
        print(destinationAccountKeyPair)

            
            
            
            
            sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
                switch response {
                case .success(let accountResponse):
                    do {
                        // build the payment operation
                        let paymentOperation = PaymentOperation(destination: destinationAccountKeyPair,
                                                                asset: Asset(type: AssetType.ASSET_TYPE_NATIVE)!,
                                                                amount: 10.5)
                        
                        // build the transaction containing our payment operation.
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.text("[1,0,1,0,1,0,1,0,1]"),
                                                          timeBounds:nil)
                        
                        
                        // sign the transaction
                        try transaction.sign(keyPair: sourceAccountKeyPair, network: Network.testnet)
                        
                        
                        
                        // submit the transaction.
                        try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                                case .success(_):
                                    print("Success")
                                    DispatchQueue.main.async {
                                        
                                       self.label3.text = " Array stored"
                                        
                                }
                        
                                case .failure(let error):
                                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
                                    sdk.payments.stream(for: .paymentsForAccount(account: destinationAccountKeyPair.accountId, cursor: "now")).onReceive { (response) -> (Void) in
                                        switch response {
                                        case .open:
                                            break
                                        case .response(let id, let operationResponse):
                                            if let paymentResponse = operationResponse as? PaymentOperationResponse {
                                                switch paymentResponse.assetType {
                                                case AssetTypeAsString.NATIVE:
                                                    print("Payment of \(paymentResponse.amount) XLM from \(paymentResponse.sourceAccount) received -  id \(id)" )
                                                default:
                                                    print("Payment of \(paymentResponse.amount) \(paymentResponse.assetCode!) from \(paymentResponse.sourceAccount) received -  id \(id)" )
                                                }
                                            }
                                        case .error(let error):
                                            if let horizonRequestError = error as? HorizonRequestError {
                                                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Receive payment", horizonRequestError:horizonRequestError)
                                            } else {
                                                print("Error \(error?.localizedDescription ?? "")") // Other error like e.g. streaming error, you may want to ignore this.
                                            }
                                        }
                                }
                            }
                            
                        }
            
                        
                    } catch {
                        //...
                    }
                case .failure(let error):
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
                }
            }
            
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            

                
                
                
                
                
                
                
            
            
            
            
        }
        catch {
            
        }
        
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    


}

