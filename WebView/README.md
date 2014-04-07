WebView Example - A simple jquery example of leveraging a webview in Cascades
========

## Description

This is a rather feature-rich template to create an app that performs extremely
fast when built entirely in Cascades with a webview for dynamic content.
Cascades provides a simple wrapper and animation effects, while all the program
logic lies within the assets folder as Javascript.

The logic goes out and runs JSONp against the IMDB movie database, returns and 
parses the JSON result into a nice view within Jquerymobile.  The animations
are designed and timed precisely to limit the user's awareness that web-service
calls are waiting to be returned.  This is a great way to give a web app the 
appearance of running natively!

See inline docs for more information...

## How to Build

1. Import the project into QNX Momentics IDE. 

2. Build the application using build option in IDE.

3. To deploy use the Run option from IDE.

##  File Structure

bar-descriptor.xml - Cascades project file.  Contains application parameters 
and permissions.

assets:
    /images: images and icons for the application.


## Known Issues
- Cannot utilize WebWorks extensions directly with this model

## More Info
Contact me with any questions or concerns at @latestlinux or
email me seb@blackberry.com

Icons are from Crystal - Free and reusable without permission.
