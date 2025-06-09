# Change Log

## [v2.8.0] - 20th November 2022 - Aniket Malik
- Add native payment gateways
- Update create order api

## [v2.7.0] - 20th October 2022 - Aniket Malik
- Add product review image plugin support

## [v2.6.0] - 18th October 2022 - Aniket Malik
- Added support for Digits Plugin for OTP login / signup

## [v2.5.0] -  - Aniket Malik
- Add support for woocommerce product add ons plugin.

## [v2.4.0] - 3rd December 2021 - Aniket Malik
- Added `acf` field to WooProduct

## [v2.3.0] - 3rd December 2021 - Aniket Malik
- Added new endpoints for dynamic filter selection options
- Updated phone field while creating user to support OTP login
- Added new api endpoint functions to support changes in main application 
  version 2.2.0 or higher 
- [REQUIRED] WooStore Pro Application version 2.2.0 or higher

## [v2.2.1] - 16th November 2021 - Aniket Malik
* Fixed WPIShipping method cost to be forced to be string

## [v2.2.0] - 11th November 2021 - Aniket Malik
* Updated Endpoint for Create Order which takes in the CartDetailsPayload
* Added endpoint for review cart details to get CartTotals.
* Updated Endpoint to get the shipping methods

## [v2.1.0] - 25th October 2021 - Aniket Malik
* Added native checkout functionality

## [v2.0.1] - 24th October 2021 - Aniket Malik
* Added flag to get only published products from woocommerce

## [v2.0.0] - 19th September 2021 - Aniket Malik
* Migrated to Null-Safety

## [v1.6.0] - 31th August 2021 - Aniket Malik
* Added support for Multi-vendor plugins. Currently supported plugins are 
  Dokan, WCFM, WCMP.

## [v1.5.2] - 29th August 2021 - Aniket Malik
* Null check for sold individually flag.

## [v1.5.1] - 26th August 2021 - Aniket Malik
* Null check for price, salePrice and regularPrice. 

## [v1.5.0] - 19th August 2021 - Aniket Malik
* Added support for Perfect WooCommerce Brands plugin to show brands 
  information for products

## [v1.4.1] - 14th August 2021 - Aniket Malik
* Fixed search multiple terms not working with space in between due to uri encoding

## [v1.4.0] - 17th July 2021 - Aniket Malik
* `IMPORTANT` This version of WooCommerce requires WooStore Pro Api
 wordpress plugin `v2.1.0`
* Added custom options field for product attributes endpoint data.
* Added value field for product attributes terms.
* Make all the model classes `const`

## [v1.3.0] - 14th July 2021 - Aniket Malik
* Added html unescape package to escape and convert unique html symbols

## [v1.2.0] - 20th June 2021 - Aniket Malik
* Added Multi currency feature ( supported by WPML Woocommerce Multilingual )

## [v1.0.0] - 6th June 2021 - Aniket Malik
- Updated `getProductCategories` to enable the `includes` and `excludes
` query parameters.