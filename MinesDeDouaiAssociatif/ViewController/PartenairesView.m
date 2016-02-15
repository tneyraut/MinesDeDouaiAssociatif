//
//  PartenairesView.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 11/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Liste des partenaires

#import "PartenairesView.h"
#import "AssociationView.h"

#import "Partenaire.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

@interface PartenairesView ()

@end

@implementation PartenairesView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Partenaires"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Partenaires" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    [self initialisationView];
    
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
    int numberOfSections = 0;
    
    for (int i=0;i<self.data.count;i++)
    {
        NSArray *array = [self.data objectAtIndex:i];
        
        if (array.count > 0)
        {
            numberOfSections++;
        }
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *array = [self.data objectAtIndex:section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Restauration";
    }
    else if (section == 1)
    {
        return @"Loisirs";
    }
    else if (section == 2)
    {
        return @"Informatique";
    }
    else if (section == 3)
    {
        return @"Autres partenaires utiles";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayPartenaires = [self.data objectAtIndex:indexPath.section];
    
    NSArray *arrayImages = [self.imagesArray objectAtIndex:indexPath.section];
    
    if ([arrayImages[indexPath.row] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell addWebViewAndImage:arrayImages[indexPath.row]];
        
        Partenaire* unPartenaire = [arrayPartenaires objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:unPartenaire.nom];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Partenaire* unPartenaire = [arrayPartenaires objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:unPartenaire.nom];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:[arrayImages objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.data objectAtIndex:indexPath.section];
    
    NSArray *arrayImages = [self.imagesArray objectAtIndex:indexPath.section];
    
    AssociationView *associationView = [[AssociationView alloc] init];
    
    associationView.afficherImage = self.afficherImage;
    
    associationView.modePartenaire = YES;
    
    associationView.partenaireChoisi = [array objectAtIndex:indexPath.row];
    
    associationView.sousMenuChoisi = @"Partenaires";
    
    associationView.imagesArray = [[NSMutableArray alloc] init];
    
    associationView.API_url = self.API_url;
    
    [associationView.imagesArray addObject:[arrayImages objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:associationView animated:YES];
}

@end
