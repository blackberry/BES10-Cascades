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
import bb.data 1.0
import autotrak.data 1.0
import "../models"
import ".."

Page {
    id: root
    
    property string claimNo: "";
    property variant selectedData
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/orange_sign.png"
        }
    ]
    
    Container {
        background: back.imagePaint
        HeaderBar {
            title: qsTr("Repair Shops")
        }
        
        ListView {
            id: reportList
            layout: StackListLayout {
                headerMode: ListHeaderMode.Sticky
            }
            
            // The data model used defined in the attachedObjects for the list.
            dataModel: reportModel
            
            // There are two types of item; header for alphabetic groups and standard items
            // showing the person name.
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id: claimItem
                        // Some entries only have a last name (we enforce last name always being added)
                        title: ListItemData.Name
                        description: ListItemData.Email
                        status: ListItemData.Phone
                        contextActions: [

                        ]
                    }
                },
                ListItemComponent {
                    type: "header"
                    Container {
                        background: Color.White
                        Header {
                            title: ListItemData
                        }
                    }
                }
            ]
            
            onTriggered: {
                // To avoid triggering navigation when pressing the header items, we check so that the
                // index path length is larger then one (one entry would be a group under a header item).
                if (indexPath.length > 1) {
                    // Update the data that will be shown in the Quotes Page.
                    root.selectedData = dataModel.data(indexPath);
                    reportList.showReport();
                }
            }
            
            function showReport() {
                var rep = null;
                
                switch (selectedData.ReportType) {
                case "Claimant Reports":
                    rep = claimantReportDefinition.createObject();
                    rep.data = root.selectedData
                    break;
                case "Police Reports":
                    rep = policeReportDefinition.createObject();
                    rep.data = root.selectedData
                    break;
                case "Witness Reports":
                    rep = witnessReportDefinition.createObject();
                    rep.data = root.selectedData
                    break;
                }
                nav.push(rep);
            }
            
            attachedObjects: [
                ComponentDefinition {
                    id: claimantReportDefinition
                    source: "asset:///pages/ClaimantReport.qml"
                },
                ComponentDefinition {
                    id: policeReportDefinition
                    source: "asset:///pages/PoliceReport.qml"
                },
                ComponentDefinition {
                    id: witnessReportDefinition
                    source: "asset:///pages/WitnessReport.qml"
                },
                RepairModel {
                    id: reportModel
                    onUpdateSelectedData: {
                        if (indexPath[0] >= 0 && indexPath[1] >= 0) {
                            //quotesList.scrollToItem(indexPath, ScrollAnimation.Default);
                            root.selectedData = data(indexPath);
                        } else {
                            root.listEmpty();
                        }
                    }
                },
                // Custom data source object, loads data using a SqlConnection, see customsqldatasource.cpp
                CustomSqlDataSource {
                    id: asyncDataSource
                    source: "sql/data/_r5.db"
                    property int loadCounter: 0
                    query: "SELECT * FROM RepairShops"
                    onDataLoaded: {
                        //console.log(asyncDataSource.query)
                        //console.log("Data loaded! Size: ", data.length);
                        if (data.length > 0) {
                            reportModel.insertList(data);
                            // Load the next batch, the last parameter is set to zero to tell the data source that we are loading data to the list.
                            //var offsetData = {"offset": (10 + 5 * loadCounter)};
                            //execute("SELECT * FROM Claim ORDER BY Created LIMIT 5 OFFSET :offset", offsetData, 0); 
                            //loadCounter ++;
                        }
                    }
                }
            ] // attachedObjects
        }         
    }

        actions: [
            ActionItem {
                title: qsTr("Choose Repair Shop")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///img/check_icon_81x81.png"
            }
        ]

    onClaimNoChanged: {
        if (claimNo.trim().length == 0) {
            return;
        }

        //asyncDataSource.query = str
        //console.log("Claim No: ", claimNo)
        asyncDataSource.load();
    }
}
