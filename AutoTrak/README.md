
***AUTOTRAK***                                                                  
                                                                    


# Table of Contents

[Introduction](#toc_1)
[Contributors](#toc_2)
[Tested On](#toc_3)
[Application Permissions](#toc_4)
[Summary](#toc_5)
[Project Build](#toc_6)
[Disclaimer](#toc_7)

# Introduction

This is a sample insurance mobile application to review submitted insurace claims by individuals.
The application allows insurance adjusters to lookup information pertaining to insurance claims.
Relevant information included in this application are: claim details, claimant reports, police reports,
and witness reports. Additional functionality for searching for repair facilities is also provided in the
sample application.

# Contributors

1. Jesse Boudreau
2. HyunJun Jung @hjung

# Tested On

BlackBerry Z30 v. 10.2.1.x
BlackBerry Z10 v. 10.2.1.x
BlackBerry Q10 v. 10.2.0.x

# Application Permissions

Requires the following permissions to be accepted by the user:
1. Camera
2. Internet
3. Location
4. Phone
5. Shared Files

# Summary

The application is a BlackBerry 10 Native application written in the Cascades UI framework. 
This sample application demonstrates the usage of many BlackBerry 10 core controls which include
Navigation pane, Page, Container, Scroll View, Picker, Header, Image View, and List View. 
This application keeps its collected data in a local SQLite database and provides the functionality
to edit existing records as well as share content using the share framework.

# Project Build

Assumptions:
- Momentics is installed and you have installed SDK version 10.1 or higher. If not please download
the latest version by following the link below.

1. Import this project into the [BlackBerry Momentics IDE](https://developer.blackberry.com/native/).
2. Perform a clean build
3. Create a run configuration for your device connected via USB
4. Run the application in Debug mode with a Debug token unless you are ready to release the build

# Issues
1. The event details within the police report detail page is not updating the database properly
2. Adding a photo after the picker selection results in a black tile (10.2.1 only)
3. Choosing a repair shop functionality has not been implemented
4. Claim detail page does not update all fields to the database. Fields that do not currently update are
	a. Loss Damage Time
	b. Cause
	c. Notified Time

# Disclaimer

HE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.


