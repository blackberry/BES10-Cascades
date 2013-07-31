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
	
    property variant beer: null
    property variant bar: null
    property variant beers: null
    property variant grouping: 0 // week

    property variant data: {
        "Jan": 45,
        "Feb": 23,
        "Mar": 56,
        "Apr": 55,
        "May": 45
    }
	
	property VolumeRequest volumeRequest: VolumeRequest {
	    id: volumeRequest
	    barid: bar.AccountNumber
	     
        onSuccess: {
            data = records;
            chartWebView.postMessage(chartWebView.message(chartWebView.bridgeCommandShowData, JSON.stringify(data)));
            contentContainer.visible = true;
        }
	}
	
	onBeerChanged: {
	    if ( beer != null ) {
	        console.log("BEER ID = " + beer.ProductCode)

            console.log("AccountNumber ID = " + bar.AccountNumber)
            
            volumeRequest.beerid = beer.ProductCode;
            volumeRequest.execute();
        }
    }
    onBeersChanged: {
        if (beers != null) {
            volumeRequest.beerids = beers;
            volumeRequest.execute();
        }
    }

    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            content: Container {
                background: headerBG.imagePaint
                layoutProperties: StackLayoutProperties {spaceQuota: 1.0}
                layout: DockLayout {}
                leftPadding: 16
                Label {
                    verticalAlignment: VerticalAlignment.Center
                    text: beer != null ? beer.Name : "All"
                    textStyle.fontSizeValue: 12
                    textStyle.fontSize: FontSize.PointValue
                }
                ActivityIndicator {
                    id: activityIndicator
                    preferredWidth: 100
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Center
                    running: volumeRequest.isLoading
                    visible: volumeRequest.isLoading
                }
            }
        }
    }

ScrollView{
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container {
	        Container {
	            horizontalAlignment: HorizontalAlignment.Fill
	            topPadding: 22
	            
	            //background: Color.Green
	            background: graphBG.imagePaint
	            preferredHeight: 696
	            minHeight: 696
	            
	            DropDown {
	                enabled: false
	                horizontalAlignment: HorizontalAlignment.Center
	                options: [
	                    Option {
	                        text: "Week"
	                        selected: true
	                    },
	                    Option {
	                        text: "Month"
	                    },
	                    Option {text: "Year"}
	                ]
	            }
	            
	            Container {
	                id: contentContainer
	                topPadding: 2
	                horizontalAlignment: HorizontalAlignment.Center
	                verticalAlignment: VerticalAlignment.Center
	                preferredWidth: 720
	                preferredHeight: 500
	            	background: Color.Black
	            	visible: false 
	            	
	            	layout: DockLayout {}
	
	                WebView {
	                    property variant bridgeStateInitializing: 0
	                    property variant bridgeStateReady: 1
	                    property variant bridgeState: 0
	
	                    property variant bridgeCommandBridgeState: "BridgeCommandBridgeState" // in
	                    property variant bridgeCommandDebug: "BridgeCommandDebug" // in
	                    property variant bridgeCommandShowData: "BridgeCommandShowData" // out
	
	                    implicitLayoutAnimationsEnabled: false
	                    objectName: "chartWebView"
	                    id: chartWebView
	                    url: "local:///assets/chart/index.html"
	
	                    verticalAlignment: VerticalAlignment.Fill
	                    horizontalAlignment: HorizontalAlignment.Fill
	                    
	                    onMessageReceived: {
	                        var components = message.data.split('::');
	                        var cmd = components[0];
	                        var value = components[1];
	                        if (cmd == bridgeCommandBridgeState) {
	                            bridgeState = value;
	                            if (bridgeState == bridgeStateReady) {
	                                console.log('[JavasriptDebug] Bridge Confirmed Ready by JS');
	                                //chartWebView.postMessage(chartWebView.message(bridgeCommandShowData, JSON.stringify(data)));
	                            }
	                        } else if (cmd == bridgeCommandDebug) {
	                            console.log("[JavasriptMessageDebug] " + value);
	                        }
	                    }
	                    
	                    function message(cmd, value) {
	                        return cmd + "::" + value;
	                    }
	                }
	                Container {
	                    verticalAlignment: VerticalAlignment.Top
	                    horizontalAlignment: HorizontalAlignment.Fill
	                    layout: DockLayout {}
	                    preferredHeight: 85
	
	                    TouchContainer {
	                        horizontalAlignment: HorizontalAlignment.Left
	                        preferredHeight: 85
	                        preferredWidth: 85
	                        enabled: volumeRequest.offset > 0
	                        
	                        ImageView {
	                            imageSource: "asset:///images/previous.png"
	                        }
	                        onTriggered: {
	                            volumeRequest.offset = Math.max(volumeRequest.offset - 1, 0);
	                            volumeRequest.execute();
	                        }
	                    }
	                    TouchContainer {
	                        horizontalAlignment: HorizontalAlignment.Right
	                        preferredHeight: 85
	                        preferredWidth: 85
	                        layout: DockLayout {}
	                        
	                        ImageView {
	                            horizontalAlignment: HorizontalAlignment.Right
	                            imageSource: "asset:///images/next.png"
	                        }
	                        onTriggered: {
	                            volumeRequest.offset = volumeRequest.offset + 1;
	                            volumeRequest.execute();
	                        }
	                    }
	                }
	            }
	
	        }
	        Container {
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            background: woodBG.imagePaint
	            
	            preferredHeight: 344
	            
	            Container {
	                horizontalAlignment: HorizontalAlignment.Center
	                layout: StackLayout {
	                    orientation: LayoutOrientation.LeftToRight
	                }
	                Container {
	                    layoutProperties: StackLayoutProperties {
	                        spaceQuota: 0.65
	                    }
		                Label {
		                    text: "Least Quantity"
	                        textStyle.textAlign: TextAlign.Right
	                        horizontalAlignment: HorizontalAlignment.Fill
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
		                Label {
		                    text: "Most Quantity"
	                        textStyle.textAlign: TextAlign.Right
	                        horizontalAlignment: HorizontalAlignment.Fill
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
	                    Label {
	                        text: "Average Quantity"
	                        textStyle.textAlign: TextAlign.Right
	                        horizontalAlignment: HorizontalAlignment.Fill
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
		            }
		            Container {
		                leftPadding: 18
	                    layoutProperties: StackLayoutProperties {
	                        spaceQuota: 0.35
	                    }
	                    Label {
		                    text: volumeRequest.min
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
		                Label {
		                    text: volumeRequest.max
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
		                Label {
		                    text: volumeRequest.average
	                        textStyle.fontSize: FontSize.PointValue
	                        textStyle.fontSizeValue: 12
	                    }
	                }
	            }
	        }
	    }
    }
}
    attachedObjects: [
        ImagePaintDefinition {
            id: headerBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/header_blank.png"
        },
        ImagePaintDefinition {
            id: woodBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/wood_background.png"
        },
        ImagePaintDefinition {
            id: graphBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/graph_background.png"
        }
    ]
}
