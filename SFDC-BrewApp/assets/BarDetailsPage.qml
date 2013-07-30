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
import bb.system 1.0
import bbmodel 1.0

Page {
    id: detailPage
    property real averageQuantity: 0

    property variant item: null
    property Page mapPage

    function getMapPage() {
        if (! mapPage) {
            mapPage = mapPageDefinition.createObject();
        }
        return mapPage;
    }

    onItemChanged: {
        if ( item != null ) {
//           dataRequest.execute("/services/data/v27.0/query/?q=SELECT+%NAMESPACE%__Product__r.ProductCode,+%NAMESPACE%__quantity_remaining__c,+%NAMESPACE%__quantity__c,+%NAMESPACE%__Product__r.Name+FROM+%NAMESPACE%__Volume__c+WHERE+(%NAMESPACE%__Account__r.AccountNumber+='" + item.__Account__r.AccountNumber + "' and %NAMESPACE%__date__c > LAST_WEEK)")
            dataRequest.execute("/services/data/v27.0/query/?q=SELECT+%NAMESPACE%__Product__r.ProductCode,+%NAMESPACE%__quantity_remaining__c,+%NAMESPACE%__quantity__c,+%NAMESPACE%__Product__r.Name+FROM+%NAMESPACE%__Volume__c+WHERE+(%NAMESPACE%__Account__r.AccountNumber+='" + item.__Account__r.AccountNumber + "')")
        }
    }

    onCreationCompleted: {
    }

    titleBar: TitleBar { kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            content: Container {
                background: headerBG.imagePaint
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                layout: DockLayout {
                }
                leftPadding: 16
                Label {
                    verticalAlignment: VerticalAlignment.Center
                    text: item ? item.__Account__r.Name : ''
                    textStyle.fontSizeValue: 12
                    textStyle.fontSize: FontSize.PointValue
                }
            }
        }
    }
    Container {
        BarDetailsHeaderContainer {
            item: detailPage.item
            myapp: Qt.app
        }

        Container {
            layout: DockLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Container {
                id: indicatorContainer
                layout: DockLayout {
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                ActivityIndicator {
                    id: myIndicator
                    preferredWidth: 100
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    running: dataRequest.isLoading
                    visible: dataRequest.isLoading
                }
            }
            Container {
                id: listContainer
                ListView {
                    id: listView
                    
                    property real avgQuantity : averageQuantity
                    horizontalAlignment: HorizontalAlignment.Fill

                    dataModel: beerDataModel

                    onTriggered: {
                        if (indexPath == 0) {
                            var page = detailPageDefinition.createObject();
                            var beers = [];

                            for (var i = 1; i < beerDataModel.size(); i ++) {
                                var beer = beerDataModel.value(i)["__Product__r"];
                                var queryId = "'" + beer.ProductCode + "'";
                                beers.push(queryId);
                            }
                            
                            page.bar = detailPage.item.__Account__r
                            page.beers = beers.join(",");
                            navigationPane.push(page);
                        } else {
                            var page = detailPageDefinition.createObject();
                            var beer = dataModel.value(indexPath)["__Product__r"];
                            page.bar = detailPage.item.__Account__r
                            page.beer = beer;
                            navigationPane.push(page);
                        }
                    }
                    function itemType(data, indexPath) {
                        if (indexPath == 0) return "summary";
                        return "item";
                    }
                    function getItem() {
                        return item;
                    }
                    function getApp() {
                        return Qt.app;
                    }
                    function getAverage() {
                        return averageQuantity;
                    }
                    function getColorWithBeerPercentage(percentage) {
                        if (percentage > 0.75) return Color.create("#73a039");
                        if (percentage > 0.45) return Color.create("#e5d15c");
                        return Color.create("#a53927");
                    }
                    function getAccessoryImageWithBeerPercentage(percentage) {
                        if (percentage > 0.75) return "asset:///images/ribbon_green.png";
                        if (percentage > 0.45) return "asset:///images/ribbon_yellow.png";
                        return "asset:///images/ribbon_red.png";
                    }
                    function launchBBM(pin) {
                        app.launchBBMChat(pin)
                    }

                    listItemComponents: [
                        ListItemComponent {
                            type: "summary"
                            BreweryItemContainer {
                                imageView.imageSource: "asset:///images/beer/ic_all.png"
                                titleLabel.text: "All"
                                titleLabel.textStyle.fontSizeValue: 11
                                accessoryImage: ListItem.view.getAccessoryImageWithBeerPercentage(ListItem.view.getAverage())
                                percentageLabel.text: Math.floor(ListItem.view.getAverage() * 100) + "%"
                                percentageLabel.textStyle.color: ListItem.view.getColorWithBeerPercentage(ListItem.view.getAverage())
                            }
                        },
                        ListItemComponent {
                            type: "item"
                            
                            BreweryItemContainer {
                                property variant beerData: ListItem.data.__Product__r
                                imageView.imageSource: "asset:///images/beer/" + getImageName() + ".png"
                                titleLabel.text: beerData.Name
                                titleLabel.textStyle.fontSizeValue: 11
                                accessoryImage: ListItem.view.getAccessoryImageWithBeerPercentage(ListItem.data.__quantity_remaining__c / ListItem.data.__quantity__c)
                                percentageLabel.text: Math.floor((ListItem.data.__quantity_remaining__c / ListItem.data.__quantity__c) * 100) + "%"
                                percentageLabel.textStyle.color: ListItem.view.getColorWithBeerPercentage(ListItem.data.__quantity_remaining__c / ListItem.data.__quantity__c)

                                function getImageName() {
                                    if (beerData.Name == "Blond Ale") return "blonde-ale";
                                    else if (beerData.Name == "Brown Ale") return "brown-ale";
                                    else if (beerData.Name == "Olde Pelican") return "olde-pelican";
                                    else if (beerData.Name == "Pale Ale") return "pale-ale";
                                    else if (beerData.Name == "Red Ale") return "red-ale";
                                    else return "blank.png"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }

    actions: [
        ActionItem {
            title: qsTr("Map")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/ActionBar_Map.png"
            enabled: {
                if (item != null && item.__Account__r.__BillingLatitude__c && item.__Account__r.__BillingLongitude__c) {
                    true;
                } else {
                    false;
                }
            }
            onTriggered: {
                var page = getMapPage();
                page.item = item
                navigationPane.push(page);
                page.setupMap()
            }
        },
        ActionItem {
            title: qsTr("Call")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/ActionBar_Call.png"
            enabled: {
                if (item != null && app.contactMap.Phone) {
                    true;
                } else {
                    false;
                }
            }
            onTriggered: {
                app.launchPhone(app.contactMap.Phone);
            }
        },
        ActionItem {
            title: qsTr("BBM")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/ActionBar_BBM.png"
            enabled: {
                if (item != null && app.contactMap.__bbmpin__c) {
                    true;
                } else {
                    false;
                }
            }
            onTriggered: {
                app.launchBBMChat(app.contactMap.__bbmpin__c)
            }
        }
    ]
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    attachedObjects: [
        ImagePaintDefinition {
            id: headerBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/header_blank.png"
        },
        ComponentDefinition {
            id: detailPageDefinition
            source: "BeerStatsPage.qml"
        },
        ComponentDefinition {
            id: mapPageDefinition
            source: "BarMap.qml"
        },
        /*Phone {
            id: dialNumber
        },*/
        DataRequest {
            id: dataRequest

            onAverageCalculated: {
                averageQuantity = result;
            }
            onDataReturned: {
                var dataList = result["records"];
                beerDataModel.clear()
                beerDataModel.append({itemType: "summary (AKA *All* button, this is the first record in the list..... we just need a blank record so the list has 1 additional row.............)"});
                beerDataModel.append(dataList);
            }
        },
        ArrayDataModel {
            id: beerDataModel
        },
        Header{
            id: summaryObj
            objectName: "summary"
        }
    ]
}
