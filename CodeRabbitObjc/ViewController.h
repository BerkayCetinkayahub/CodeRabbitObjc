//
//  ViewController.h
//  CodeRabbitObjc
//
//  Created by Berkay Çetinkaya on 20.10.2025.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *termsSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPickerView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

- (IBAction)submitTapped:(id)sender;

@end

