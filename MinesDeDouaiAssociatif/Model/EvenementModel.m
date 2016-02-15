//
//  EvenementModel.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "EvenementModel.h"
#import "Evenement.h"

@interface EvenementModel()

@property(nonatomic, strong) NSMutableData* downloadedDataEvenements;

@property(nonatomic) BOOL inscription;

@end

@implementation EvenementModel

- (void) getAllEvenements {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@evenement/list", self.API_url]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getEvenementsByAssociation:(int)association_id {
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@evenement/list?association_id=%d", self.API_url, association_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) inscriptionEvenementWithId:(int)evenement_id
{
    self.inscription = YES;
    
    NSString *url = [NSString stringWithFormat:@"evenement_id=%d", evenement_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@evenement/participer", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)desinscriptionEvenementWithId:(int)evenement_id
{
    self.inscription = YES;
    
    NSString *url = [NSString stringWithFormat:@"evenement_id=%d", evenement_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@evenement/nePlusParticiper", self.API_url]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedDataEvenements = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedDataEvenements appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.delegate && self.inscription)
    {
        [self.delegate evenementsDownloaded:[[NSArray alloc] init]];
        
        return;
    }
    
    NSMutableArray* evenements = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedDataEvenements options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count; i++) {
        NSDictionary* jsonElement = jsonArray[i];
        
        Evenement* evenement = [[Evenement alloc] init];
        
        evenement.evenement_id = [jsonElement[@"id"] intValue];
        evenement.descrip = (NSString*)jsonElement[@"description"];
        evenement.title = (NSString*)jsonElement[@"title"];
        evenement.start = (NSString*)jsonElement[@"start"];
        evenement.end = (NSString*)jsonElement[@"end"];
        evenement.lieu = (NSString*)jsonElement[@"lieu"];
        evenement.image = (NSString*)jsonElement[@"image"];
        evenement.paymentNecessaire = [jsonElement[@"paymentNeeded"] boolValue];
        
        if ([jsonElement[@"dejaInscrit"] intValue] == 0)
        {
            evenement.dejaInscrit = NO;
        }
        else
        {
            evenement.dejaInscrit = YES;
        }
        
        NSString *test = jsonElement[@"price"];
        if (evenement.paymentNecessaire && ![test isEqual:[NSNull null]])
        {
            evenement.prix = [jsonElement[@"price"] floatValue];
        }
        else if (evenement.paymentNecessaire)
        {
            evenement.prix = 0;
        }
        
        [evenements addObject:evenement];
    }
    
    if (self.delegate) {
        [self.delegate evenementsDownloaded:evenements];
    }
}

@end
