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
import "../js/utils.js" as Utils

Page {
    id: root
    property alias modelObjectName: claimModel.objectName
    property variant selectedData
    property alias dataSource: asyncDataSource
    property string whereClause: "1"
    property string searchClause: ""

    signal showClaimDetail()
    signal listEmpty()

    function updateData() {
        refresh();
    }

    function refresh() {
        claimModel.clear();
        asyncDataSource.load();
    }

    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/Highway_Night.png"
        }
    ]

    Container {
        HeaderBar {
            title: "AutoTrak"
        }

        Container {
            id: searchBar
            visible: false
            background: Color.LightGray

            onVisibleChanged: {
                console.log("Is search visible: ", visible);
                if (! visible) {
                    searchText.text = "";
                    root.searchClause = "";
                    refresh();
                }
            }

            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            leftPadding: 15
            rightPadding: 15
            topPadding: 15
            bottomPadding: 15

            TextField {
                id: searchText
                hintText: qsTr("Search")
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.7
                }

                input {
                    submitKey: SubmitKey.Search
                    onSubmitted: {
                        root.searchClause = " AND (Claimant.Name LIKE '%" + searchText.text + "%'"
                        root.searchClause += " OR Claim.ClaimNo LIKE '%" + searchText.text + "%'"
                        root.searchClause += ")"
                        refresh();
                    }
                }
                onTextChanging: {
                    if (searchText.text.length == 0) {
                        root.searchClause = ""
                        refresh();
                    }
                }
            }

            Button {
                text: qsTr("Cancel")
                onClicked: {
                    searchBar.visible = false;
                }

                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.3
                }
            }
        }
        Container {
            background: back.imagePaint

            ListView {

                layout: StackListLayout {
                    headerMode: ListHeaderMode.Sticky
                }
                horizontalAlignment: HorizontalAlignment.Fill
                // The data model used defined in the attachedObjects for the list.
                dataModel: claimModel

                // There are two types of item; header for alphabetic groups and standard items
                // showing the person name.
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        Container {
                            id: listViewItems
                            layout: StackLayout {
                                orientation: LayoutOrientation.TopToBottom
                            }

                            Container {

                                Label {
                                    text: ListItemData.Name
                                    horizontalAlignment: HorizontalAlignment.Fill

                                    textStyle.fontStyle: FontStyle.Normal
                                    textStyle.fontSizeValue: 0.0
                                    textStyle.color: Color.create("#fff9fb67")
                                    textStyle.fontWeight: FontWeight.Bold
                                    topMargin: 0.0
                                    minHeight: 50.0

                                }

                            }
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight

                                }

                                Label {
                                    text: ListItemData.StatusName
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 2.0

                                    }
                                    textStyle.fontStyle: FontStyle.Normal
                                    textStyle.fontWeight: FontWeight.Bold
                                    textStyle.color: Color.create("#ff78aaff")

                                    minHeight: 70.0

                                }
                                Label {
                                    text: ListItemData.ClaimNo
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: -1.0

                                    }
                                    textStyle.fontStyle: FontStyle.Normal
                                    textStyle.fontSizeValue: 0.0
                                    textStyle.color: Color.create("#ff78aaff")
                                    textStyle.fontWeight: FontWeight.Bold
                                    minHeight: 70.0

                                }
                            }
                        }

                    },
                    ListItemComponent {
                        type: "header"
                        Header {
                            title: _app.formatDate(ListItemData)
                            opacity: 0.75
                        }
                    }
                ]

                onTriggered: {
                    // To avoid triggering navigation when pressing the header items, we check so that the
                    // index path length is larger then one (one entry would be a group under a header item).
                    if (indexPath.length > 1) {
                        // Update the data that will be shown in the Claim Detail Page.
                        root.selectedData = dataModel.data(indexPath);
                        root.showClaimDetail();
                    }
                }

                attachedObjects: [
                    ClaimModel {
                        id: claimModel
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
                        source: "sql/data_r5.db"
                        query: {
                            "SELECT *, ClaimStatus.Name as StatusName FROM Claim LEFT JOIN Claimant ON Claimant.ClaimNo = Claim.ClaimNo LEFT JOIN ClaimStatus ON ClaimStatus.ID = Claim.Status WHERE 1 AND " + root.whereClause + root.searchClause
                        }
                        property int loadCounter: 0

                        onDataLoaded: {
                            console.log(asyncDataSource.query)
                            console.log("Data loaded! Size: ", data.length);
                            if (data.length > 0) {
                                claimModel.insertList(data);
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
    }

    function updateClaim(data) {
        console.log("updating claim from page");
        asyncDataSource.execute("UPDATE Claim SET ClaimDate = :ClaimDate, PolicyNo = :PolicyNo, Insurer = :Insurer, InsuredUntil = :InsuredUntil, Vehicle = :Vehicle, SerialNo = :SerialNo, LicensePlateNo = :LicensePlateNo, LossDamageDate = :LossDamageDate, Location = :Location, PoliceUnit = :PoliceUnit, UnitNotifyDate = :UnitNotifyDate WHERE ClaimNo = :ClaimNo", {
                ClaimDate: data.ClaimDate,
                PolicyNo: data.PolicyNo,
                Insurer: data.Insurer,
                InsuredUntil: data.InsureUntil,
                Vehicle: data.Vehicle,
                SerialNo: data.SerialNo,
                LicensePlateNo: data.LicensePlate,
                LossDamageDate: data.LossDate,
                Location: data.Location,
                PoliceUnit: data.PoliceUnit,
                UnitNotifyDate: data.UnitNotifyDate,
                ClaimNo: data.ClaimNo
            }, data.ID);

        var indexPath = claimModel.find(root.selectedData);
        claimModel.updateItem(indexPath, data);
    }
    actions: [
        ActionItem {
            title: qsTr("Search")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///img/search_icon_81x81.png"

            onTriggered: {
                searchBar.visible = true;
                searchText.requestFocus();
            }
        }
    ]
}
