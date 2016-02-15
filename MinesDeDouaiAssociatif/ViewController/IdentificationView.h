//
//  IdentificationView.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 08/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "EncryptModel.h"
#import "APIModel.h"

@interface IdentificationView : UIViewController <APIModelProtocol> //<EncryptModelProtocol>

@property(nonatomic,weak) NSUserDefaults *sauvegarde;

@end
