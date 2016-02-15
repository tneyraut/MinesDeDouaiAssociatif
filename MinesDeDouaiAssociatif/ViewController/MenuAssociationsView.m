//
//  MenuAssociationsView.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Menu d'un BDX : Liste des associations sous le BDX sélectionné

#import "MenuAssociationsView.h"
#import "SousMenuAssociationsView.h"
#import "MenuView.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

@interface MenuAssociationsView ()

@property(nonatomic, strong) AssociationModel* _associationModel;

@property(nonatomic, strong) NSArray* _associationsItems;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MenuAssociationsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:self.associationParenteChoisie.nom];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.associationParenteChoisie.nom style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadData
{
    if (!self._associationModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._associationsItems = [[NSArray alloc] init];
        
        self._associationModel = [[AssociationModel alloc] init];
        
        self._associationModel.API_url = self.API_url;
        
        self._associationModel.delegate = self;
        
        self._associationModel.associationParente = self.associationParenteChoisie;
    }
    [self._associationModel getListeAsssociations:self.associationParenteChoisie.nom];
}

// Méthode liée à AssociationModel appelée automatiquement après téléchargement de données
- (void) associationsDownloaded:(NSArray *)items
{
    self._associationsItems = items;
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<items.count;i++)
    {
        Association *uneAssociation = items[i];
        
        if (self.afficherImage && ![uneAssociation.logo isKindOfClass:[NSNull class]] && [uneAssociation.logo rangeOfString:@"svg"].location == NSNotFound && uneAssociation.logo.length > 0 && [uneAssociation.logo rangeOfString:@"bmp"].location == NSNotFound && [uneAssociation.logo rangeOfString:@"gif"].location == NSNotFound)
        {
            NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[uneAssociation.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            
            NSURL *url = [[NSURL alloc] initWithString:urlString];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        
            [self.imagesArray addObject:[UIImage imageWithData:imageData]];
        }
        else if (self.afficherImage && ![uneAssociation.logo isKindOfClass:[NSNull class]] && [uneAssociation.logo rangeOfString:@"svg"].location != NSNotFound)
        {
            NSString *urlString = [@"http://api.minesdedouai.fr/uploads/association/" stringByAppendingString:[uneAssociation.logo stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            
            [self.imagesArray addObject:urlString];
        }
        else
        {
            [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ASSOCIATION", @"ICON_NAME_ASSOCIATION")]];
        }
    }
    
    if (items.count == 0) {
        [self alert:@"Information" message:@"Aucune donnée trouvée..." button:@"OK"];
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle
{
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
    
    [self.activityIndicatorView startAnimating];
    
    [self downloadData];
    
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
    return self._associationsItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Association* uneAssociation = self._associationsItems[indexPath.row];
    
    if ([self.imagesArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        [cell addWebViewAndImage:[self.imagesArray objectAtIndex:indexPath.row]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setText:uneAssociation.nom];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setText:uneAssociation.nom];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:[self.imagesArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SousMenuAssociationsView *sousMenuAsssociationsView = [[SousMenuAssociationsView alloc] initWithStyle:UITableViewStylePlain];
    
    sousMenuAsssociationsView.afficherImage = self.afficherImage;
    
    if([self.imagesArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        sousMenuAsssociationsView.logoAssociationSVG = self.imagesArray[indexPath.row];
    }
    else
    {
        sousMenuAsssociationsView.logoAssociation = self.imagesArray[indexPath.row];
    }
    
    sousMenuAsssociationsView.associationChoisie = self._associationsItems[indexPath.row];
    
    sousMenuAsssociationsView.API_url = self.API_url;
    
    [self.navigationController pushViewController:sousMenuAsssociationsView animated:YES];
}

@end
