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

Container {
    property variant navigationPane

    function loadDetailsPage(barId) {
        console.log("loading details (" + app.dataModel.size() + ") page for bar id " + barId);

        for (var i = 0; i < app.dataModel.size(); i ++) {
            var item = app.dataModel.data([ i ]);
            if (item.__Account__r.AccountNumber == barId) {
                var page = detailDefinition.createObject();
                page.item = item.__Account__r;
                
                while ( navigationPane.count() > 1 ) {
                    var pane = navigationPane.at(navigationPane.count() - 1);
                    navigationPane.remove(pane);
                    pane.destroy();
                }
                
                navigationPane.push(page);
            }
        }
    }
    onCreationCompleted: {
        app.gotoDetails.connect(loadDetailsPage);
        console.log("[BarsListView] Creating Bars List View");
    }

    RefreshableListView {
        id: listView
	    horizontalAlignment: HorizontalAlignment.Fill
	
	    dataModel: app.dataModel
	    
	    onTriggered: {
	        //indexPath
            console.log("BarsListView::onTriggered")
            var page = detailDefinition.createObject();
            var item = dataModel.data(indexPath);
            page.item = item;
            app.requestContact(page.item.__Account__r.AccountNumber)
            navigationPane.push(page);

        }

        function itemType(data, indexPath) {
            return "item";
        }

        onUpdateTriggered: {
            console.log("BarsListView::onUpdateTriggered")
            app.refreshBars();
        }
        
        onCreationCompleted: {
            app.dataModelChanged.connect(listView.updateFinished)
        }

        function getAccessoryImageWithBeerState(state) {
            if (state == 1) return "asset:///images/ribbon_red.png";
            if (state == 2) return "asset:///images/ribbon_yellow.png";
            return "asset:///images/ribbon_green.png";
        }
        
        listItemComponents: [
	        ListItemComponent {
	            type: "item"	            
	            BreweryItemContainer {
	                property variant barData : ListItem.data.__Account__r
                    titleLabel.text: barData.Name
                    subtitleLabel.text: barData.__Address__c
                    accessoryImage: ListItem.view.getAccessoryImageWithBeerState(barData.__beer_state__c)
                    imageView.imageSource: barData.AccountNumber ? "asset:///images/bars/" + barData.AccountNumber + ".png" : ""
                }
            }
	    ]
    }

    attachedObjects: [
        ComponentDefinition {
            id: detailDefinition
            source: "asset:///BarDetailsPage.qml"
        }
    ]
}