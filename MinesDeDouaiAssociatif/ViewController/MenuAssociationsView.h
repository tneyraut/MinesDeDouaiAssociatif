//
//  MenuAssociationsView.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssociationModel.h"
#import "Association.h"

@interface MenuAssociationsView : UITableViewController <UITableViewDataSource, UITableViewDelegate, AssociationModelProtocol>

@property(nonatomic, weak) Association *associationParenteChoisie;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
