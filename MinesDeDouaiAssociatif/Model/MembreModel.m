//
//  MembreModel.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 19/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "MembreModel.h"
#import "Membre.h"

@interface MembreModel()

@property(nonatomic, strong) NSMutableData* downloadedDataMembres;

@end

@implementation MembreModel

- (void) getMembresByAssociation:(int)association_id {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@association/membres?association_id=%d", self.API_url, association_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedDataMembres = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedDataMembres appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* membres = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataMembres options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        Membre* membre = [[Membre alloc] init];
        membre.membre_id  = [jsonElement[@"id"] intValue];
        membre.prenom = (NSString*)jsonElement[@"prenom"];
        membre.nom = (NSString*)jsonElement[@"nom"];
        
        membre.email = [NSString stringWithFormat:@"%@@minesdedouai.fr", jsonElement[@"username"]];
        
        if (![jsonElement[@"chambre"] isKindOfClass:[NSNull class]])
        {
            membre.chambre = [NSString stringWithFormat:@"%d",[jsonElement[@"chambre"] intValue]];
        }
        else
        {
            membre.chambre = (NSString*)jsonElement[@"chambre"];
        }
        
        membre.telephone = (NSString*)jsonElement[@"telephone"];
        membre.role = (NSString*)jsonElement[@"role"];
        membre.residence = (NSString*)jsonElement[@"residence"];
        membre.avatar = (NSString*)jsonElement[@"avatar"];
        
        [membres addObject:membre];
    }
    if (self.delegate) {
        [self.delegate membresDownloaded:membres];
    }
}

@end
