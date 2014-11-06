

BESSafeTcp

[Introduction](#toc_1)
[Contributors](#toc_2)
[Tested On](#toc_3)
[Summary](#toc_4)
[Disclaimer](#toc_5)

# Introduction

BESSafeTcp is a sample Cascades application that demonstrates how to successfully use Tcp / SSL sockets using various APIs in the work perimeter.  The sample demonstrates how to do this using QTcpSockets, QSslSockets, BSD sockets / OpenSSL, and cURL.  The classes demonstrating each test case are designed to be pluggable into developers existing code in most cases but may require some effort in the case of integrating the changes into a larger libary of networking code.

# Contributors

Roberto Speranza

# Tested On

BlackBerry Z30 v. 10.0.x through 10.3.1.x

# Summary

The application is a BlackBerry 10 Native application written in the Cascades UI framework. 
The current sample app shows developers how to create working TCP / SSL sockets in the work perimeter with the following APIs: Qt - QTcpSockets and QSslSockets, BSD Sockets / OpenSSL, and cURL.
In each case, the concept is the same.  The utility classes provided lookup the IP address hostname / port to which you want to connect to determine if a proxy is required.  If so, an HTTP CONNECT request is made to the proxy to setup a tunnel and then the connection continues normally after that and the connect functions returns the socket to the caller to continue using as normal.  The utility classes were designed to be plugged in easily into other's code but developers are free to extract what they need and incorporate it their own way.  The following table summarizes the different utility classes and which networking APIs they apply to:
Utility Class	 	Networking API 
BESConnect	 	Covers the QT APIs with cases for QTcpSockets and QSslSockets
SSLSocketThread	 	Covers the BSD / OpenSSL APIs for SSL connections
TCPSocketThread	 	Covers the BSD socket APIs (no SSL)
CurlConnectThread	Covers the cURL API

UDP sockets will not work with the BES proxy so they are not covered in this sample.  However, BES deployments with corporate VPN should be able to support UDP sockets because VPN deployments do not use the proxy mechanism and network connections are transparent in that case.  Utilizing these utility classes will allow your app to work with TCP sockets for both the proxy case and direct since it checks to see whether a proxy is required or not at runtime.
The sample app logs most of its debug output to a log file under shared/documents/logs in the work perimeter.  The files are text files that are viewable in File Manager.


# Disclaimer

HE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.


