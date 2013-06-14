# ServerNotify Sample
This sample demonstrates how to implement a BlackBerry Enterprise Push client and server application.

The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).


**Applies To**

* Client: [BlackBerry 10 Cascades SDK](http://developer.blackberry.com/cascades/)
* Server: Microsoft .NET C# Application
* This sample has been tested using the 10.1.0.1020 and 10.1.0.1720 SDK

**Author(s)**

* [Brent Thornton](http://www.twitter.com/brentthornton32)
* [John Mutter](http://www.twitter.com/muttejo)

**Special Thanks To**
* [Garett Beukeboom](https://twitter.com/garettBeuk) for the simple push starter app.
* [Maurice White](https://twitter.com/MoReeseMo) for the last minute server additions and testing.

**Dependencies**

1. You will need a BlackBerry 10 smartphone to test.
2. You with need a BlackBerry Device Service Server or access to one.
3. A .NET web server to run the monitoring (optional).

*Note: If you don't use .NET on the backend you can use any server side technology that can make an HTTP POST. You create the POST in a similar manner to the C# example provided.

## Initial Client Setup

1. Clone the repository to your local machine.
2. Open the Cascades IDE.
3. Import the project to your workspace.
4. Modify bar-descriptor.xml source to include your unique invoke-target id:
```
	<invoke-target id="com.abccompany.servernotify">
```

5. In the src/PushManager.cpp file modify the BLACKBERRY_INVOKE_TARGET_ID to match the unique id you used above
```
	const QString PushManager::BLACKBERRY_INVOKE_TARGET_ID = "com.abccompany.servernotify";
```

6. You can modify the BLACKBERRY_PUSH_APPLICATION_ID as well. This has to match the server though.
7. Build, sign, and export the project. (Create the bar file)

## Deployment

Usually you can pass the signed bar file to your BES administrator and have them:

1. Add it to the BDS.
2. Add it to a software configuration.
3. Apply the software configuration to the user account you are testing with.
*Note: Software policies can take some time to be applied to your device.
[BlackBerry Device Service Documentation](http://docs.blackberry.com/en/admin/subcategories/?userType=2&category=BlackBerry+Device+Service)

## Initial Server Setup

1. In Visual Studio Create a New Visual C# Web Project (ASP.Net Empty Web Application) ASP.Net 3.5.0+.
2. Name it ServerNotify and set the location where you would like, then click OK.
3. Copy Default.aspx, Default.aspx.cs, web.config, and the entire contents of IMG folder, including the IMG folder into the project (Overwriting existing files).
4. Click on the ServerNotify Project, if it's an option, "Convert to Web Application".
5. Clean, Build, and Debug.
6. When ready, build and publish to web server.

## Now What?

1. Launch the application once on the device.
2. Either leave the application open or close it. Now that it has registered with the push service once, the app can receive pushes while open or closed.
3. Visit the Server page Default.aspx
4. Enter a server Name and IP and click Add Server. If you want to test failure (when a push occurs) enter an IP address you know will fail
5. Click Start Monitoring and within the interval you specified a push will occur and you should see the dialog box show up.

*Note: You should only use global dialog boxes in urgent situations. You can push behind the scenes, notify using the hub, or some other method for processing non-urgent items.

## More Info

* [Push Blog Post](http://bizblog.blackberry.com/2013/06/push-enterprise-apps/)
* [BlackBerry Enterprise Push Development Guide](http://docs.blackberry.com/en/admin/deliverables/50897/index.jsp?name=Development+Guide+-+Push+Service+for+Enterprise+Apps6.2&language=English&userType=2&category=BlackBerry+Device+Service&subCategory=)


## Bug Reporting and Feature Requests

If you find a bug in a Sample, or have an enhancement request, simply file an Issue for the Sample.

## Disclaimer

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.