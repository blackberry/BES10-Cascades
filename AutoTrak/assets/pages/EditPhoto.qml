/* Copyright (c) 2013 BlackBerry Limited.
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
import bb.cascades.pickers 1.0

Page {
    id: root
    property string claimNo;
    property string photoPath;
    
    objectName: "viewPhoto"
    
    actions: [
        /*
        ActionItem {
            title: "Select Image"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                webView.visible = false;
                imagePicker.visible = true;
                webView.url = webView.url;
                filePicker.open();
            }
        },
        */
        ActionItem {
            id: aiDraw
            title: "Draw"
            enabled: false
            imageSource: "asset:///img/edit_icon_81x81.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                scrollView.scrollViewProperties.scrollMode = ScrollMode.None;
                enabled = false;
                
                aiText.enabled = 
                aiZoom.enabled = true;
                
                var msg = JSON.stringify({
                        type: "setMode",
                        mode: "draw"
                });
            webView.postMessage(msg);
        
            }
        },
        ActionItem {
            id: aiText
            title: "Text"
            enabled: true
            imageSource: "asset:///img/text_icon_81x81.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                scrollView.scrollViewProperties.scrollMode = ScrollMode.None;
                enabled = false;
                
                aiDraw.enabled = 
                aiZoom.enabled = true;
                
                var msg = JSON.stringify({
                        type: "setMode",
                        mode: "text"
                });
            webView.postMessage(msg);
            }
        },
        ActionItem {
            id: aiZoom
            title: "Zoom"
            imageSource: "asset:///img/zoom_in_icon_81x81.png"
            enabled: true
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                scrollView.scrollViewProperties.scrollMode = ScrollMode.Both;
                enabled = false;
                
                aiText.enabled = 
                aiDraw.enabled = true;
                
                var msg = JSON.stringify({
                        type: "setMode",
                        mode: "zoom"
                });
            webView.postMessage(msg);
            }
        },
        ActionItem {
            id: aiUndo
            title: "Undo"
            imageSource: "asset:///img/undo_icon_81x81.png"
            enabled: false
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                var msg = JSON.stringify({
                        type: "undo"
                });
            webView.postMessage(msg);
            }
        },
        ActionItem {
            id: aiClearTags
            title: "Remove annotations"
            imageSource: "asset:///img/tag_icon_81x81.png"
            enabled: true
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                var msg = JSON.stringify({
                        type: "removeTags"
                });
            webView.postMessage(msg);
            }
        }
    ]
    Container {
        layout: DockLayout{}
        background: Color.Black
        ScrollView {
            id: scrollView
            scrollViewProperties {
                scrollMode: ScrollMode.Both
                pinchToZoomEnabled: true
                maxContentScale: 5
                minContentScale: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layoutProperties: StackLayoutProperties { spaceQuota: 1.0 }
            minWidth: 720
            minHeight: 620
            preferredHeight: 1280
            Container {
                background: Color.Black
                layout: StackLayout { 
                    orientation: LayoutOrientation.TopToBottom }
                
                layoutProperties: StackLayoutProperties { spaceQuota: 1.0 }
                minWidth: 720
                minHeight: 620
                preferredWidth: 768
                preferredHeight: 1280
                WebView {
                    id: webView
                    //visible: false
                    url: "local:///assets/web/draw.html"
                    
                    settings {
                        webInspectorEnabled: true
                        zoomToFitEnabled: true
                        devicePixelRatio: 1.0
                        background: Color.Black
                        viewport: {
                            "width": "device-width",
                            "initial-scale": 1.0
                        }
                    }

                    minWidth: 720
                    minHeight: 620
                    preferredWidth: Infinity
                    preferredHeight: Infinity
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    
                    onMinContentScaleChanged: {
                        console.log("New min scale: ", minContentScale);
                        // Update the scroll view properties to match the content scale
                        // given by the WebView.
                        scrollView.scrollViewProperties.minContentScale = minContentScale;
                        
                        // Let's show the entire page to start with.
                        scrollView.zoomToPoint(0,0, minContentScale,ScrollAnimation.None)
                    }
                    
                    onMaxContentScaleChanged: {
                        // Update the scroll view properties to match the content scale 
                        // given by the WebView.
                        scrollView.scrollViewProperties.maxContentScale = maxContentScale;
                    }
                    
                    onMessageReceived: {
                        console.log(message.data);

                        var msg = JSON.parse(message.data);
                        
                        if (msg.type == "ready") {
                            var file = _app.copyToData(root.photoPath.replace("file://",""));
                            var msg = JSON.stringify({
                                    type: "setImage",
                                    url:  file///root.photoPath
                            });
	                        scrollView.scrollViewProperties.scrollMode = ScrollMode.Both;
	                        scrollView.scrollViewProperties.minContentScale = webView.minContentScale;
	                        console.log("posting message");
	                        webView.postMessage(msg);
	                        return;
                        }
                        
                        if (msg.type == "resetScale") {
                            scrollView.scrollViewProperties.minContentScale = 0.17;
                            return;
                        }
                        
                        if (msg.type == "resetZoom") {
                            scrollView.zoomToPoint(0,0, scrollView.scrollViewProperties.minContentScale, ScrollAnimation.None);
                            return;
                        }
                        
                        if (msg.type == "disableScroll") {
                            scrollView.scrollViewProperties.scrollMode = ScrollMode.None;
                            return;
                        }
                        
                        if (msg.type == "undoCount") {
                            aiUndo.enabled = (msg.count > 0);
                            return;
                        }
                        
                        if (msg.type == "log") {
                            console.log(message);
                            return;
                        }
                    }
                } // end WebView
            }
        }
    }
    
    function setImage(file) {
        console.log("setImage : " + file);
        root.photoPath = file;
    }
}
