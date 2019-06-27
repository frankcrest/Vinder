//
//  Notification.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation

enum CallReponseType{
  case accepted
  case rejected
  case error
  case hangup
}

struct CallResponse {
  var uid:String
  var title:String
  var body:String
  var status: CallReponseType {
    get{
      if body == "Accepted"{
        return .accepted
      }else if body == "Rejected"{
        return .rejected
      }else if body == "HangUp"{
        return .hangup
      }
      else{
        return .error
      }
    }
  }

}

extension NSNotification.Name {

  static let CallResponseNotification = NSNotification.Name("CallResponseNotification")
}
