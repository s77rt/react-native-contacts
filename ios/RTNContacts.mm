#import "RTNContacts.h"

#import <Contacts/Contacts.h>
#import <React/RCTUtils.h>

@implementation RTNContacts

RCT_EXPORT_MODULE()

- (void)getAll:(NSArray *)keys
       resolve:(RCTPromiseResolveBlock)resolve
        reject:(RCTPromiseRejectBlock)reject {
  BOOL shouldFetchGivenName = NO;
  BOOL shouldFetchFamilyName = NO;
  BOOL shouldFetchPhoneNumbers = NO;
  BOOL shouldFetchEmailAddresses = NO;
  BOOL shouldFetchThumbnailImageData = NO;
  for (NSString *key in keys) {
    if ([key isEqualToString:CNContactGivenNameKey]) {
      shouldFetchGivenName = YES;
      continue;
    }
    if ([key isEqualToString:CNContactFamilyNameKey]) {
      shouldFetchFamilyName = YES;
      continue;
    }
    if ([key isEqualToString:CNContactPhoneNumbersKey]) {
      shouldFetchPhoneNumbers = YES;
      continue;
    }
    if ([key isEqualToString:CNContactEmailAddressesKey]) {
      shouldFetchEmailAddresses = YES;
      continue;
    }
    if ([key isEqualToString:CNContactThumbnailImageDataKey]) {
      shouldFetchThumbnailImageData = YES;
      continue;
    }
  }

  CNContactStore *store = [[CNContactStore alloc] init];
  CNContactFetchRequest *fetchRequest =
      [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
  NSError *error;
  NSMutableArray *contacts = [NSMutableArray array];

  BOOL success = [store
      enumerateContactsWithFetchRequest:fetchRequest
                                  error:&error
                             usingBlock:^(CNContact *__nonnull cnContact,
                                          BOOL *__nonnull stop) {
                               if (error) {
                                 *stop = YES;
                                 return;
                               }

                               NSMutableDictionary *contact =
                                   [NSMutableDictionary dictionary];

                               if (shouldFetchGivenName) {
                                 [contact setObject:cnContact.givenName
                                             forKey:@"firstName"];
                               }

                               if (shouldFetchFamilyName) {
                                 [contact setObject:cnContact.familyName
                                             forKey:@"lastName"];
                               }

                               if (shouldFetchPhoneNumbers) {
                                 NSMutableArray *phoneNumbers =
                                     [NSMutableArray array];
                                 for (CNLabeledValue<CNPhoneNumber *>
                                          *phoneNumber in cnContact
                                              .phoneNumbers) {
                                   [phoneNumbers addObject:@{
                                     @"label" : phoneNumber.label
                                         ?: [NSNull null],
                                     @"value" : phoneNumber.value.stringValue,
                                   }];
                                 }
                                 [contact setObject:phoneNumbers
                                             forKey:@"phoneNumbers"];
                               }

                               if (shouldFetchEmailAddresses) {
                                 NSMutableArray *emailAddresses =
                                     [NSMutableArray array];
                                 for (CNLabeledValue<NSString *>
                                          *emailAddress in cnContact
                                              .emailAddresses) {
                                   [emailAddresses addObject:@{
                                     @"label" : emailAddress.label
                                         ?: [NSNull null],
                                     @"value" : emailAddress.value,
                                   }];
                                 }
                                 [contact setObject:emailAddresses
                                             forKey:@"emailAddresses"];
                               }

                               if (shouldFetchThumbnailImageData) {
                                 if (cnContact.thumbnailImageData) {
                                   NSString *filePath =
                                       RCTTempFilePath(@"png", nil);
                                   [cnContact.thumbnailImageData
                                       writeToFile:filePath
                                        atomically:YES];
                                   [contact
                                       setObject:[[NSURL
                                                     fileURLWithPath:filePath]
                                                     absoluteString]
                                          forKey:@"thumbnail"];
                                 } else {
                                   [contact setObject:[NSNull null]
                                               forKey:@"thumbnail"];
                                 }
                               }

                               [contacts addObject:contact];
                             }];

  if (!success) {
    reject(
        error ? [@(error.code) stringValue] : @"Unknown",
        [NSString
            stringWithFormat:@"Error: %@ - Reason: %@",
                             error ? error.localizedDescription : @"Unknown",
                             error ? error.localizedFailureReason : @"Unknown"],
        error);
    return;
  }

  resolve(contacts);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeRTNContactsSpecJSI>(params);
}

@end