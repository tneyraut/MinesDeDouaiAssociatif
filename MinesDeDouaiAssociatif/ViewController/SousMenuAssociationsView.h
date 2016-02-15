//
//  SousMenuAssociationsView.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EvenementModel.h"
#import "PartenaireModel.h"
#import "MembreModel.h"

#import "Association.h"

@interface SousMenuAssociationsView : UITableViewController <UITableViewDataSource, UITableViewDelegate, EvenementModelProtocol, PartenaireModelProtocol, MembreModelProtocol>

@property(nonatomic, weak) Association *associationChoisie;

@property(nonatomic, weak) UIImage *logoAssociation;

@property(nonatomic, weak) NSString *logoAssociationSVG;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
