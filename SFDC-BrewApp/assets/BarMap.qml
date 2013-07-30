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
import bb.cascades.maps 1.0
import bbmodel 1.0

Page {
    property variant item: {}
    property Page detailPage

    function getDetailPage() {
        if (! detailPage) {
            detailPage = detailPageDefinition.createObject();
        }
        return detailPage;
    }
    titleBar: TitleBar {kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            content : Container {
                background: headerBG.imagePaint
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                layout: DockLayout {
                }
                leftPadding: 16
                Label {
                    verticalAlignment: VerticalAlignment.Center
                    text: item.Name
                    textStyle.fontSizeValue: 12
                    textStyle.fontSize: FontSize.PointValue
                }
            }
        }
    }
    Container {
        MapView {
            id: mapView
            horizontalAlignment: HorizontalAlignment.Fill
            preferredWidth: 768
            preferredHeight: 1100
            altitude: 2000
            latitude : 28.408615
            longitude : -81.586189

            onCreationCompleted:{
                mapView.captionButtonClicked.connect(invokeGo)
                mapView.captionLabelTapped.connect(popPage)
            }
        }
    }

    function popPage() {
        navigationPane.pop()
    }
    
    function invokeGo(){
        routeInvokerID.endLatitude = item.__Account__r.__BillingLatitude__c; // item["__BillingLatitude__c"]
        routeInvokerID.endLongitude = item.__Account__r.__BillingLongitude__c // item["__BillingLongitude__c"]
        routeInvokerID.endName = item.__Account__r.Name // item["Name"]
        routeInvokerID.endDescription = (item.__Account__r.__Address__c + ", " + item.__Account__r.__City__c ) // (item["__address__c"] + ", " + item["__city__c"])
        routeInvokerID.go();
    }

	function setupMap(){
	    // app.showMap(mapView, item["__BillingLatitude__c"], item["__BillingLongitude__c"], item["Name"], (item["__address__c"] + ", " + item["__city__c"]))
	    app.showMap(mapView, item.__Account__r.__BillingLatitude__c, item.__Account__r.__BillingLongitude__c,item.__Account__r.Name, (item.__Account__r.__Address__c + ", " + item.__Account__r.__City__c ));
     }

    attachedObjects: [
        ImagePaintDefinition {
            id: headerBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/header_blank.png"
        },
        RouteMapInvoker {
            id: routeInvokerID
        }
    ]
}
