//
//  MenuView.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IdentificationView.h"

#import "UserModel.h"
#import "EvenementModel.h"
#import "AssociationModel.h"
#import "PartenaireModel.h"
#import "LinkModel.h"

@interface MenuView : UITableViewController <UITableViewDataSource, UITableViewDelegate, EvenementModelProtocol, UserModelProtocol, AssociationModelProtocol, PartenaireModelProtocol, LinkModelProtocol>

@property(nonatomic,weak) IdentificationView *identificationView;

@property(nonatomic,weak) NSString *login;

@property(nonatomic,weak) NSString *password;

@property(nonatomic) BOOL demandeIdentification;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
