BB10_ECL - Emergency Contact List Application.
========

## Description

The Emergency Contact List (ECL) Application stores and displays the latest 
emergency contact list. It allows the user to display the list and then 
call, email, or sms the appropriate contact.

The contact list is updated by a push to the device.  When a new list is
received, a local copy of that list is stored.  The user can start the 
application manually.  Since the data is stored locally it is available 
when offline.
    
## Data Transports and Upgrading to ECL 

This version of ECL uses JSON (JavaScript Object Notation) as a transport for efficiency.  
For those upgrading from earlier versions of ECL, you should export your XLS to CSV and 
then use a standard tool like csv2json (https://github.com/shawnbot/csv2json) to convert 
that data to a compact and usable transport.  As an alternative, you may do on-the-fly 
binary conversion of the Excel XLS format with a server-side tool like Apache POI 
(http://poi.apache.org), but this solution would require a Java Application server and
is beyond the scope of this document to set up.

There is a blog @ http://devblog.blackberry.com that goes into this migration path in 
greater detail.    


## How to Build

1. Import the project into QNX Momentics IDE. 

2. Build the application using build option in IDE.

3. To deploy use the Run option from IDE.

##  File Structure

bar-descriptor.xml - Cascades project file.  Contains application parameters 
and permissions.

assets:
    /data: This folder contains a configuration file and sample json and text 
            files for testing.
    /data/ecl_data.txt: This file is used in the "Demo with Text File" feature.
            It is converted to a json file using the config.json file below. 
            This file has contact data formatted in a similar manner as in 
            the ECL Application on the BB 7 Platform. 
    /data/config.json: This json is used to map fields from Text File to json 
            for the above text file.
    /data/ecl_data.json: This is used to support the "Demo with JSON File" 
            feature. This json is used to populate the Contact list in the 
            application.
    /images: images and icons for the application.
    UI qml files.


src:
    eclconfig: Config file with application ENUMs and utility functions maps 
            json fields with display strings.
    eclcontact: Implements the adding the ECL contact to device address book.
    ecldatamodel: Data model, loads and holds data from json file.
    ecllistitem: Custom list item. 
    eclutils: Utility functions.
    filtereddatamodel: Filtered data model, used for expandable and collapsible
             list.
    main: Application main file.
    pushclient\pushclientnotification: Push notification handler.
    pushclient\pushconfiguration: Push related configuration file.


## Server Component

The server/index.htm is a small test application that can be used to send requests
to the enterprise server to push an emergency contact list to a device/phone.
This is a standalone HTML file and can run directly from the BlackBerry filesystem,
on a simple webserver (like Apache or Nginx), or packaged and deployed as a hybrid app
itself on BlackBerry platforms.

## Known Issues
- Initiating calls doesn’t work on work perimeter.
- SMS sending feature is not implemented.

## More Info

Icons from BBUI.js and also Myers Design Limited (http://myersdesign.com/).


