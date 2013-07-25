# BBM Carousel

The BBM Carousel example allows the developer to invoke BlackBerry Messenger(BBM)
using the [Invocation Framework] (https://developer.blackberry.com/cascades/documentation/device_platform/invocation/invocation_framework.html).  For devices running 10.1 that are also [BlackBerry Balance] (http://us.blackberry.com/business/software/blackberry-balance.html?lpos=us:bb:search:Business&lid=us:bb:search:Business:BlackBerry-Balance-Technology#tab-1) enabled, the work perimeter only allows for a limited set of BBM features to be invokable. This sample implements those features:

- Invite a user to chat 
- Share text to an individual contact
- Share text to a group 
- Share an image to an individual contact 
- Share an image to a group 

The implementation for the invocation of the aforementioned features are in the Carousel.cpp file.

The sample was built using the "bbjamcarousel" example located [here] (https://github.com/blackberry/Cascades-Community-Samples/tree/master/stumpers/bbjamcarousel)

The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html)

**Special Thanks**

- [Johan Larsby] (https://github.com/jlarsby) the author of that "bbjamcarousel" sample
- [Rich Balsewich] (https://twitter.com/OnlineODB) for modifying the "bbjamcarousel" sample and providing the implementation framework to tie in the BBM invocation code to

**Applies To**

* [BlackBerry 10 Cascades SDK](http://developer.blackberry.com/cascades/)
* This sample has been tested using the 10.1.0.1020 SDK


**Requirements:**

1. BlackBerry 10 Native SDK
2. BlackBerry 10 smartphone to test
3. If you intend to test in Corporate Perimeter, you will need a BlackBerry Device Service Server or access to one. (optional)


##Running the example:

1. Clone the Sample repository.
2. Launch BlackBerry 10 Native SDK, and from the File menu, select Import.
3. Expand General, and select Existing Projects into Workspace. Click Next.
4. Browse to the location of your sample directory, and then click OK.
5. The sample project should display in the Projects section. 
   Click Finish to import the project into your workspace.
6. In the Project Explorer pane, Right-click the project (for example BBM Carousel) 
   and select Build Project.
7. In the Project Explorer pane, Right-click the project (for example BBM Carousel) 
   and select Run As > BlackBerry C/C++ Application.
8. The application will now install and launch on your device. If not, check that your environment is set up correctly [here] (http://developer.blackberry.com/cascades/documentation/getting_started/setting_up.html)

##Running the example in corporate perimeter 
**Steps apply to BlackBerry Balance Enabled devices**

1. Build, sign, and export the project (Create the .bar file)
2. Add it to the BlackBerry Device Server.
3. Add it to a software configuration.
2. Apply the software configuration to the user account you are testing with. [BlackBerry Device Service Documentation](http://docs.blackberry.com/en/admin/subcategories/?userType=2&category=BlackBerry+Device+Service)


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.