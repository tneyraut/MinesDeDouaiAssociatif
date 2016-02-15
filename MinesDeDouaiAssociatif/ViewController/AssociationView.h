//
//  AssociationView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Partenaire.h"
#import "Association.h"

#import "EvenementModel.h"

@interface AssociationView : UITableViewController <UITableViewDelegate, UITableViewDataSource, EvenementModelProtocol>

@property(nonatomic, weak) NSString *sousMenuChoisi;

@property(nonatomic, weak) NSArray *dataMembres;

@property(nonatomic, strong) NSArray *data;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@property(nonatomic, weak) Association *associationChoisie;

@property(nonatomic, weak) Partenaire *partenaireChoisi;

@property(nonatomic) BOOL modePartenaire;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
