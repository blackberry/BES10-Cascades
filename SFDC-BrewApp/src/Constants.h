/* Copyright (c) 2012 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


#ifndef CONSTANTS_H
#define CONSTANTS_H

/*
 * Constants class
 */

#define SF_NAMESPACE	"waalabs"
#define TEST_ACCOUNT	"waasample@gmail.com"
// #define SF_NAMESPACE	"your namespace"
// #define TEST_ACCOUNT	"sfdc cloud email addr"

//Bar - Referred to as account object in salesforce.com
#define BAR_NAME 		"Name"
#define BAR_ADDRESS		SF_NAMESPACE "__Address__c"
#define BAR_LAT			"__BillingLatitude__c"
#define BAR_LONG		"__BillingLongitude__c"
//#define BAR_LAT			SF_NAMESPACE "__BillingLatitude__c"
//#define BAR_LONG		SF_NAMESPACE "__BillingLongitude__c"
#define BAR_ID			"AccountNumber"
#define BAR_PHONE		"Phone"
#define BAR_ZIPCODE		SF_NAMESPACE "__zipcode__c"
#define BAR_CITY		SF_NAMESPACE "__City__c"

//Beer product - Referred to as product object in salesforce.com
#define BEER_NAME		"Name"
#define BEER_ID			"ProductCode"

//Bar contact - referred to as the Contact object in salesforce.com
#define CONTACT_NAME		"Name"
#define CONTACT_PHONE		"Phone"
#define CONTACT_BBM			SF_NAMESPACE "__bbmpin__c"

//Relationship prefixes
//#define REL_PRE_BAR		SF_NAMESPACE "__Account__r"
#define REL_PRE_BAR		"__Account__r"
#define REL_PRE_BEER	SF_NAMESPACE "__Product__r"
#define REL_PRE_CONTACT	SF_NAMESPACE "__Contact__r"

#define DOT "."

#endif

