/* Copyright (c) 2012 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


import bb.cascades 1.0
import bbmodel 1.0

Page {
    signal login
    property int timeout: 30000
    property variant indicatorVisibility: activityIndicator.visible
    property variant indicatorRunning: activityIndicator.running
    property ActivityIndicator indicator: activityIndicator
    property int deviceW: uiConstants.deviceW
    property int deviceH: uiConstants.deviceH
    property WebView myWebView : theWebview
    id: thePage

    content: Container {
        layout: AbsoluteLayout {
        }
        
        background: Color.White

        ScrollView {
            id: scrollview
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            scrollViewProperties {
                pinchToZoomEnabled: false
                scrollMode: ScrollMode.Vertical
            }
            preferredHeight: deviceH
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }
            Container {
                id: webview
                objectName: "webview"
                WebView {
                    id: theWebview
                    objectName: "theWebview"
                    url: "https://login.salesforce.com/services/oauth2/authorize?response_type=token&display=touch&client_id=3MVG9A2kN3Bn17hsPYpFs3rM41gU2sM1ECpdJ.gaLZA8ti9nJ4980zNiDpAfrx63c5t_9H_icxsLKKwCx_gQZ&redirect_uri=sfdc://success"
                    visible: false
                    onCreationCompleted: {
                        app.loggedIn.connect(login)
                    }
                    onLoadingChanged: {
                        if (loadRequest.status == WebLoadStatus.Started) {
                            activityIndicator.visible = true;
                            activityIndicator.running = true;
                            timer.start(timeout);
                        } else if (loadRequest.status == WebLoadStatus.Succeeded) {
                            activityIndicator.visible = false;
                            activityIndicator.running = false;
                            timer.stop();
                            
                            theWebview.evaluateJavaScript("document.getElementById('username').value = 'waasample@gmail.com';");
                            theWebview.evaluateJavaScript("document.getElementById('password').value = 'blackberry10';");

                            theWebview.visible = true
                        } else if (loadRequest.status == WebLoadStatus.Failed) {
                            activityIndicator.visible = false;
                            activityIndicator.running = false;
                            timer.stop();
                            theWebview.visible = true
                        }
                    }
                    onLoadProgressChanged: {
                        timer.start(timeout);
                        activityIndicator.visible = true;
                        activityIndicator.running = true;
                    }
                    onNavigationRequested: {
                        app.navigationRequested(request.url)
                    }
                    attachedObjects: [
                        QTimer {
                            id: timer
                            interval: timeout
                            singleShot: true
                            onTimeout: {
                                app.showToast("Request timed out. Please try again later.")
                                theWebview.stop();
                                activityIndicator.visible = false;
                                activityIndicator.running = false;
                            }
                        }
                    ]
                }
            }
        }
        ActivityIndicator {
            id: activityIndicator
            preferredHeight: 100
            preferredWidth: 100
            layoutProperties: AbsoluteLayoutProperties {
                positionX: deviceW / 2 - 50
                positionY: (deviceH) / 2 - 50 // 110 is title bar height - 140 is nav bar height ... 50 is our height/2...
            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

            visible: false
            running: false
        }
    }
}