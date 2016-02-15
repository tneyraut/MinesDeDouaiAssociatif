//
//  SousMenuAssociationsView.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Menu pour une association sélectionnée : évènements, partenaires et association (descriptif, membres)

#import "SousMenuAssociationsView.h"
#import "MenuAssociationsView.h"
#import "AssociationView.h"
#import "PartenairesView.h"
#import "EvenementsView.h"

#import "Association.h"
#import "Membre.h"
#import "Evenement.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

@interface SousMenuAssociationsView ()

@property(nonatomic, strong) PartenaireModel* _partenaireModel;
@property(nonatomic, strong) NSArray* _dataDownload;

@property(nonatomic, strong) MembreModel* _membreModel;
@property(nonatomic, strong) NSArray* _membres;

@property(nonatomic, strong) EvenementModel* _evenementModel;
@property(nonatomic, strong) NSArray* _evenements;

@property(nonatomic, strong) NSArray *arraySousMenu;

@property(nonatomic, weak) NSString *sousMenuChoisi;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SousMenuAssociationsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:self.associationChoisie.nom];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.associationChoisie.nom style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadData:(int)association_id
{
    if (!self._dataDownload)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._dataDownload = [[NSArray alloc] init];
    }
        
    if ([self.sousMenuChoisi isEqualToString:@"Evènements"])
    {
        if (!self._evenementModel)
        {
            self._evenementModel = [[EvenementModel alloc] init];
            
            self._evenementModel.API_url = self.API_url;
            
            self._evenementModel.delegate = self;
        }
        [self._evenementModel getEvenementsByAssociation:association_id];
    }
    else if ([self.sousMenuChoisi isEqualToString:@"Partenaires"])
    {
        if (!self._partenaireModel)
        {
            self._partenaireModel = [[PartenaireModel alloc] init];
            
            self._partenaireModel.API_url = self.API_url;
            
            self._partenaireModel.delegate = self;
        }
        [self._partenaireModel getPartenairesByAssociation:association_id];
    }
    else if ([self.sousMenuChoisi isEqualToString:@"L'association"])
    {
        if (!self._membreModel)
        {
            self._membreModel = [[MembreModel alloc] init];
            
            self._membreModel.API_url = self.API_url;
            
            self._membreModel.delegate = self;
            
            self._membres = [[NSArray alloc] init];
        }
        [self._membreModel getMembresByAssociation:association_id];
    }
}

// Méthode liée à MembreModel appelée automatiquement après téléchargement
- (void) membresDownloaded:(NSArray *)items
{
    self._membres = items;
    
    if (items.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        [self alert:@"Information" message:@"Aucune donnée récupérée." button:@"OK"];
    }
    else
    {
        AssociationView *associationView = [[AssociationView alloc] init];
        
        associationView.afficherImage = self.afficherImage;
        
        associationView.associationChoisie = self.associationChoisie;
        
        associationView.dataMembres = self._membres;
        
        associationView.sousMenuChoisi = @"L'association";
        
        associationView.API_url = self.API_url;
        
        associationView.imagesArray = [[NSMutableArray alloc] init];
        
        if (self.afficherImage && ![self.associationChoisie.logo isKindOfClass:[NSNull class]] && [self.associationChoisie.logo rangeOfString:@"svg"].location == NSNotFound && [self.associationChoisie.logo rangeOfString:@"bmp"].location == NSNotFound && [self.associationChoisie.logo rangeOfString:@"gif"].location == NSNotFound)
        {
            NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[self.associationChoisie.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            
            NSURL *url = [[NSURL alloc] initWithString:urlString];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
            
            [associationView.imagesArray addObject:[UIImage imageWithData:imageData]];
        }
        else if (self.afficherImage && ![self.associationChoisie.logo isKindOfClass:[NSNull class]] && [self.associationChoisie.logo rangeOfString:@"svg"].location != NSNotFound)
        {
            NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[self.associationChoisie.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            
            [associationView.imagesArray addObject:urlString];
        }
        else
        {
            [associationView.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
        }
        
        for (int i=0;i<items.count;i++)
        {
            Membre *membre = items[i];
            
            if (self.afficherImage && ![membre.avatar isKindOfClass:[NSNull class]] && [membre.avatar rangeOfString:@"svg"].location == NSNotFound && membre.avatar.length > 0 && [membre.avatar rangeOfString:@"bmp"].location == NSNotFound && [membre.avatar rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[membre.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                [associationView.imagesArray addObject:[UIImage imageWithData:imageData]];
            }
            else if (self.afficherImage && ![membre.avatar isKindOfClass:[NSNull class]] && [membre.avatar rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[membre.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [associationView.imagesArray addObject:urlString];
            }
            else
            {
                [associationView.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_USER", @"ICON_NAME_USER")]];
            }
        }
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:associationView animated:YES];
    }
}

// Méthode liée à PartenaireModel appelée automatiquement après téléchargement
- (void) partenairesDownloaded:(NSArray *)items
{
    self._dataDownload = items;
    
    NSArray *partenairesFirstType = items[0];
    
    NSArray *partenairesSecondType = items[1];
    
    NSArray *partenairesThirdType = items[2];
    
    NSArray *partenairesFourthType = items[3];
    
    if (partenairesFirstType.count == 0 && partenairesSecondType.count == 0 && partenairesThirdType.count == 0 && partenairesFourthType.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        [self alert:@"Information" message:@"Aucune donnée récupérée." button:@"OK"];
    }
    else
    {
        PartenairesView *partenairesView = [[PartenairesView alloc] initWithStyle:UITableViewStylePlain];
        
        partenairesView.afficherImage = self.afficherImage;
        
        partenairesView.data = self._dataDownload;
        
        partenairesView.API_url = self.API_url;
        
        partenairesView.imagesArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<items.count;i++)
        {
            NSArray *partenairesArray = items[i];
            
            NSMutableArray *arrayImage = [[NSMutableArray alloc] init];
            
            for (int j=0; j<partenairesArray.count; j++)
            {
                Partenaire *partenaire = partenairesArray[j];
                
                if (self.afficherImage && ![partenaire.logo isKindOfClass:[NSNull class]] && [partenaire.logo rangeOfString:@"svg"].location == NSNotFound && partenaire.logo.length > 0 && [partenaire.logo rangeOfString:@"bmp"].location == NSNotFound && [partenaire.logo rangeOfString:@"gif"].location == NSNotFound)
                {
                    NSString *urlString = [@"http://api.minesdedouai.fr/uploads/partenaire/" stringByAppendingString:[partenaire.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                    
                    NSURL *url = [[NSURL alloc] initWithString:urlString];
                    
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                    
                    [arrayImage addObject:[UIImage imageWithData:imageData]];
                }
                else if (self.afficherImage && ![partenaire.logo isKindOfClass:[NSNull class]] && [partenaire.logo rangeOfString:@"svg"].location != NSNotFound)
                {
                    NSString *urlString = [@"http://api.minesdedouai.fr/uploads/partenaire/" stringByAppendingString:[partenaire.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                    
                    [arrayImage addObject:urlString];
                }
                else
                {
                    [arrayImage addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_PARTENAIRE", @"ICON_NAME_PARTENAIRE")]];
                }
            }
            
            [partenairesView.imagesArray addObject:arrayImage];
        }
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:partenairesView animated:YES];
    }
}

// Méthode liée à EvenementModel appelée automatiquement après téléchargement
- (void) evenementsDownloaded:(NSArray *)items
{
    self._dataDownload = items;
    if (items.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        [self alert:@"Information" message:@"Aucune donnée récupérée." button:@"OK"];
    }
    else
    {
        
        EvenementsView *evenementsView = [[EvenementsView alloc] initWithStyle:UITableViewStylePlain];
        
        evenementsView.afficherImage = self.afficherImage;
        
        evenementsView.evenementsArray = self._dataDownload;
        
        evenementsView.API_url = self.API_url;
        
        evenementsView.imagesArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<items.count;i++)
        {
            Evenement *evenement = items[i];
            
            if (self.afficherImage && ![evenement.image isKindOfClass:[NSNull class]] && [evenement.image rangeOfString:@"svg"].location == NSNotFound && evenement.image.length > 0 && [evenement.image rangeOfString:@"bmp"].location == NSNotFound && [evenement.image rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/evenement/" stringByAppendingString:[evenement.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                [evenementsView.imagesArray addObject:[UIImage imageWithData:imageData]];
            }
            else if (self.afficherImage && ![evenement.image isKindOfClass:[NSNull class]] && [evenement.image rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/evenement/" stringByAppendingString:[evenement.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [evenementsView.imagesArray addObject:urlString];
            }
            else
            {
                [evenementsView.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR")]];
            }
        }
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:evenementsView animated:YES];
    }
}

- (void) setImageCell:(UITableViewCell *)cell i:(int)indice
{
    NSString *imageName;
    if ([[self.arraySousMenu objectAtIndex:indice] isEqualToString:@"Evènements"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_CALENDAR", @"ICON_NAME_CALENDAR");
    }
    else if ([[self.arraySousMenu objectAtIndex:indice] isEqualToString:@"Partenaires"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_PARTENAIRE", @"ICON_NAME_PARTENAIRE");
    }
    else if ([[self.arraySousMenu objectAtIndex:indice] isEqualToString:@"L'association"])
    {
        imageName = NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION");
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titre message:contenu delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.arraySousMenu = [[NSArray alloc] initWithObjects:@"L'association", @"Evènements", @"Partenaires", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arraySousMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.logoAssociationSVG)
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        [cell addWebViewAndImage:self.logoAssociationSVG];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setText:[self.arraySousMenu objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row != 0 || [self.associationChoisie.logo isKindOfClass:[NSNull class]] || self.associationChoisie.logo.length <= 0 || [self.associationChoisie.logo rangeOfString:@"svg"].location != NSNotFound)
    {
        [self setImageCell:cell i:(int)indexPath.row];
    }
    else
    {
        [cell.imageView setImage:self.logoAssociation];
    }
    
    [cell.textLabel setText:[self.arraySousMenu objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView startAnimating];
        
        self.sousMenuChoisi = [self.arraySousMenu objectAtIndex:indexPath.row];
        
        [self downloadData:self.associationChoisie.association_id];
    }
}

@end
