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
import bb.platform 1.0
import bbmodel 1.0

Container {
    property variant navigationPane
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    background: Color.Red
    
    MapView {
        id: barMapView
        objectName: "barMapView"
        horizontalAlignment: HorizontalAlignment.Fill
        preferredWidth: 768
    }
    
    onCreationCompleted: {
        barMapView.captionButtonClicked.connect(mapGoInvoker)
        barMapView.captionLabelTapped.connect(mapCaptionLabelTapped)
        app.dataModelChanged.connect(setupMapPins)
    }
    
    function setupMapPins(){
        app.showMapAll(barMapView)
    }
    
    function mapCaptionLabelTapped(){
        var page = detailDefinition.createObject();
        var item = app.dataModel.value(barMapView.focusedId);
        item.id = barMapView.focusedId;
        page.item = item;
        navigationPane.push(page);
    }
    
    function mapGoInvoker(){
        var item1 = app.dataModel.value(barMapView.focusedId);
        var item = item1["__Account__r"]
        routeInvokerID.endLatitude = item["__BillingLatitude__c"]
        routeInvokerID.endLongitude = item["__BillingLongitude__c"]
        routeInvokerID.endName = item["Name"]
        routeInvokerID.endDescription = (item["__Address__c"] + ", " + item["__City__c"])
        routeInvokerID.go();
    }
    
    attachedObjects: [
        RouteMapInvoker {
            id: routeInvokerID
        },
        ComponentDefinition {
            id: detailDefinition
            source: "BarDetailsPage.qml"
        }
    ]
}
