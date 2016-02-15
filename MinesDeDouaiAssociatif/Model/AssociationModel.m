//
//  AssociationModel.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "AssociationModel.h"

@interface AssociationModel()

@property(nonatomic, strong) NSMutableData* downloadedDataAssociations;

@property(nonatomic) BOOL modeGetAssociationByName;

@end

@implementation AssociationModel

- (void) getListeAsssociations:(NSString *)nom {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@association/listByParent?parent_name=%@", self.API_url, nom]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAssociationByName:(NSString *)nom
{
    self.modeGetAssociationByName = YES;
    
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@association/list?nom=%@", self.API_url, nom]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getAssociationById:(int)ID {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@association/list?association_id=%d", self.API_url, ID]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedDataAssociations = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedDataAssociations appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* associations = [[NSMutableArray alloc] init];
    
    NSError* error;
    
    if (self.modeGetAssociationByName)
    {
        NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataAssociations options:NSJSONReadingAllowFragments error:&error];
        
        Association* association = [[Association alloc] init];
        association.association_id = [jsonArray[@"id"] intValue];
        association.nom = (NSString*)jsonArray[@"nom"];
        association.descrip = (NSString*)jsonArray[@"description"];
        association.type = (NSString*)jsonArray[@"type"];
        association.site = (NSString*)jsonArray[@"site"];
        association.alias = (NSString*)jsonArray[@"alias"][@"adresse"];
        association.logo = (NSString*)jsonArray[@"logo"];
        
        [associations addObject:association];
    }
    
    else
    {
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataAssociations options:NSJSONReadingAllowFragments error:&error];
        
        if (self.associationParente)
        {
            [associations addObject:self.associationParente];
        }
        
        for (int i=0;i<jsonArray.count; i++) {
            NSDictionary* jsonElement = jsonArray[i];
            Association* association = [[Association alloc] init];
            association.association_id = [jsonElement[@"id"] intValue];
            association.nom = (NSString*)jsonElement[@"nom"];
            association.descrip = (NSString*)jsonElement[@"description"];
            association.type = (NSString*)jsonElement[@"type"];
            association.site = (NSString*)jsonElement[@"site"];
            association.alias = (NSString*)jsonElement[@"alias"][@"adresse"];
            association.logo = (NSString*)jsonElement[@"logo"];
            
            [associations addObject:association];
        }
        
    }
    
    if (self.delegate) {
        [self.delegate associationsDownloaded:associations];
    }
}

@end
