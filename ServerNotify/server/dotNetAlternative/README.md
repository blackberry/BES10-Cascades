# ServerNotify: Server JavaScript Implementation

*Note: The JavaScript version is very bare-bones and meant to be a manual push.

The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

**Author(s)**

* [Brent Thornton](http://www.twitter.com/brentthornton32)

## How To Use

1. Enter the Destination Email or PIN of the device you are pushing to.
2. Enter the BES address that the user is on.
3. Enter the BES MDS-CS Push Listen port. Usually 8080.
4. Click Do Push.

## Options for Push Payload

The push payload is separated into 4 segments (delimeted by |). The first is the priority (see Priority section below for explaination). The second is the Title of the push. The third is the Description. Finally the forth is a url (ie. could be a url of the server you are alerting on).

**Priority**

Priority can be set to 0, 1, or 2.

0 - No notification. Will only show up in the push list if the application is open.

1 - Notification in the hub (if app isn't in foreground). Will show up in the push list if the application is closed or open in foreground.

2 - Will popup a dialog alerting the user of the push. Will show up in the application push list.

## Bug Reporting and Feature Requests

If you find a bug in a Sample, or have an enhancement request, simply file an Issue for the Sample.

## Disclaimer

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.