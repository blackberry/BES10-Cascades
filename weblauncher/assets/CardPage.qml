/* Copyright (c) 2012, 2013  BlackBerry Limited.
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
 *
 */

// Navigation pane project template
import bb.cascades 1.0
import Dialog.Alert 1.0

Page {
    // page with a browser detail
    id: pgCard
    
    property string siteURL : ""
    
    actions: []
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                // define what happens when back button is pressed here
                // in this case is closed the detail page
                //navigationPane.pop()
                alertsDialog.show();
            }
        }
    }
    Container {
        background: Color.Black
        ScrollView {
            id: scrollView
            scrollViewProperties {
                scrollMode: ScrollMode.Both
                pinchToZoomEnabled: true
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }
            Container {
                background: Color.LightGray
                WebView {
                    id: launchcardView
                    url: siteURL
                    onMinContentScaleChanged: {
                        scrollView.scrollViewProperties.minContentScale = minContentScale;
                    }
                    onMaxContentScaleChanged: {
                        scrollView.scrollViewProperties.maxContentScale = maxContentScale;
                    }
                    onLoadProgressChanged: {
                        // Update the ProgressBar while loading.
                        progressIndicator.value = loadProgress / 100.0
                    }
                    onLoadingChanged: {
                        if (loadRequest.status == WebLoadStatus.Started) {
                            // Show the ProgressBar when loading started.
                            progressIndicator.opacity = 1.0
                        } else if (loadRequest.status == WebLoadStatus.Succeeded) {
                            // Hide the ProgressBar when loading is complete.
                            progressIndicator.opacity = 0.0
                        } else if (loadRequest.status == WebLoadStatus.Failed) {
                            // If loading failed, fallback to inline HTML, by setting the HTML property directly.
                            html = "<html><head><title>Fallback HTML on Loading Failed</title><style>* { margin: 0px; padding 0px; }body { font-size: 48px; font-family: monospace; border: 1px solid #444; padding: 4px; }</style> </head> <body>Oh ooh, loading of the URL: " + launchcardView.url + " that was set on this WebView failed. Perhaps you are not connected to the Internet? Or maybe you're not connected behind the firewall?</body></html>"
                            progressIndicator.opacity = 0.0
                        }
                    }

                    // This is the Navigation-requested signal handler so just print to console to illustrate usage.
                    onNavigationRequested: {
                        console.debug("NavigationRequested: " + request.url + " navigationType=" + request.navigationType)
                    }
                }
            }
        }

        Container {
            bottomPadding: 25
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom
            ProgressIndicator {
                id: progressIndicator
                opacity: 0
            }
        }
        attachedObjects: [
            AlertDialog {
                id: alertsDialog
                cancelButton: true
                okButton: true
                alertMessage: "Navigating away from this page will end your session."
                titleText: "WARNING!!!!"
                onOk: {
                    navigationPane.pop();
                }
                onCancel: {
                    //
                }
                onCustomButton: {
                    //
                }
            }

        ]
    }
}
