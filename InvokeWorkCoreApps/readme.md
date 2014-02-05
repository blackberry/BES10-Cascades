# Invoke Work Core Apps

The Invoke Work Core Apps example demonstrates how to invoke a set of core apps in the work space by using the [Invocation Framework] (https://developer.blackberry.com/cascades/documentation/device_platform/invocation/invocation_framework.html).  The core apps that are inovked in this sample:

- Enterprise Instant Messanging
- Adobe Reader
- Browser
- Phone

The implementation for the invocation of the aforementioned core apps are in the applicationui.cpp file.

The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html)

**Applies To**

* [BlackBerry 10 Cascades SDK](http://developer.blackberry.com/cascades/)
* This sample has been tested using the 10.2.1.1205 SDK


**Requirements:**

1. BlackBerry 10 Native SDK
2. BlackBerry 10 smartphone to test
3. If you intend to test in Corporate Perimeter, you will need a BlackBerry Device Service Server or access to one. (optional). If you'd like to sideload into the work space, see [this] (http://bizblog.blackberry.com/2013/10/debugging-apps-in-the-work-space/) article


##Running the example:

1. Clone the Sample repository.
2. Launch BlackBerry 10 Native SDK, and from the File menu, select Import.
3. Expand General, and select Existing Projects into Workspace. Click Next.
4. Browse to the location of your sample directory, and then click OK.
5. The sample project should display in the Projects section. 
   Click Finish to import the project into your workspace.
6. In the Project Explorer pane, Right-click the project (for example Invoke Work Core Sample) 
   and select Build Project.
7. In the Project Explorer pane, Right-click the project (for example Invoke Work Core Sample) 
   and select Run As > BlackBerry C/C++ Application.
8. The application will now install and launch on your device. If not, check that your environment is set up correctly [here] (http://developer.blackberry.com/cascades/documentation/getting_started/setting_up.html)

##Running the example in corporate perimeter 
**Steps apply to BlackBerry Balance Enabled devices**

1. Build, sign, and export the project (Create the .bar file)
2. Add it to the BlackBerry Device Server.
3. Add it to a software configuration.
2. Apply the software configuration to the user account you are testing with. [BlackBerry Device Service Documentation](http://docs.blackberry.com/en/admin/subcategories/?userType=2&category=BlackBerry+Device+Service)


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.