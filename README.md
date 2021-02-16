# Property Managment

This is a demo application that display list of apartments with booking functionlaity.

<img src="https://user-images.githubusercontent.com/21119818/108268781-51a3df00-716d-11eb-8037-9da2244a0834.gif" width="300" height="658"/>

## About the Property Managment

This application uses an api to display apartments with following functionlity

- List of apartment
- Search by From, To Dates and Number of Bedrooms
- Booking facility
- Once Booked, it cannot be booked again in same date span

## Location

First, we have hard coded location
User can tap "location" (location default icon on top-right) to use current location
If previously denied, restriced, we will display dialog to allow location services in Settings of iPhone

## Tech
- AWS api for apartment data
- MVP Architecture
- Xcode Version 12.4 (12D4e)
- SDKs - iOS 14.4
- Apple Swift version 5.3.2
- Only apple's default UI components like UITableView, UIButton
- CoreData for Booked aprtment information
- URLSession for Netorking
- No third party library is used.

## How to Run
- Download OR Use Git or checkout with SVN using the web URL. https://github.com/digitacs/property.git
- Build
- Run

## Modules
Only one Module is in the application: List
