/* Copyright (c) 2013, 2014  BlackBerry Limited.
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

// About page
import bb.cascades 1.0
import bb.system.phone 1.0

Page {

    Container {
        topPadding: 20
        leftPadding: 5
        rightPadding: 5
        background: Color.Black
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        Container{
            WebView {
                url: "local:///assets/htmlText/text.html"
            }
        }

        Container {
            leftPadding: 5
            Label {
                text: "www.macadamian.com"
                textStyle {
                    color: Color.create("#2A94D6")
                    fontSize: FontSize.Small
                }
            }

            onTouch: {
                // Invoke the browser with the www.macadamian.com
                if (event.isUp()) {
                    invokeQuery.mimeType = "text/html"
                    invokeQuery.uri = "http://www.macadamian.com";
                    invokeQuery.updateQuery();
                }
            }

            attachedObjects: [
                Invocation {
                    query: InvokeQuery {
                        id: invokeQuery
                        mimeType: "text/html"
                        invokeTargetId: "sys.browser"
                    }

                    onArmed: {
                        // This gets called first time when the
                        // query is created and no uri is set
                        if (invokeQuery.uri != "") {
                            trigger("bb.action.OPEN");
                        }
                    }
                }
            ]
        }

        Container {
            leftPadding: 5
            topPadding: 4
            Label {
                text: "1-111-111-1111"
                textStyle {
                    color: Color.create("#FFFFFF")
                    fontSize: FontSize.Small
                }
            }

            onTouch: {
                // Invokes the phone app with dial pad
                phone.requestDialpad("1-111-111-1111");
            }

            attachedObjects: [
                Phone {
                    id: phone
                }
            ]
        }
    } // end of Container
} // end of Page
