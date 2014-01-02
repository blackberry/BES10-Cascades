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

    property string claimNo: ""
    property variant selectedData

    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/Highway_401_Night_Busy.png"
        }
    ]

    Container {
        background: back.imagePaint
        HeaderBar {
            title: qsTr("Details and Reports")
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
                    Container {
                        id: listViewItems
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight

                            }
                            Label {
                                text: ListItemData.Name
                                horizontalAlignment: HorizontalAlignment.Fill

                                textStyle.fontStyle: FontStyle.Normal
                                textStyle.fontSizeValue: 0.0
                                textStyle.color: Color.create("#fff9fb67")
                                textStyle.fontWeight: FontWeight.Bold
                                topMargin: 0.0
                                minHeight: 50.0
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 2.0

                                }

                            }

                            Label {
                                text: ListItemData.Phone
                                horizontalAlignment: HorizontalAlignment.Fill
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: -1.0

                                }
                                textStyle.fontStyle: FontStyle.Normal
                                textStyle.fontSizeValue: 0.0
                                textStyle.color: Color.create("#fff9fb67")
                                textStyle.fontWeight: FontWeight.Bold
                                minHeight: 70.0

                            }
                        }
                        Container {
                            Label {

                                text: ListItemData.Email
                                horizontalAlignment: HorizontalAlignment.Fill
                                textStyle.fontStyle: FontStyle.Normal
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.color: Color.create("#ff78aaff")

                                minHeight: 70.0

                            }

                        }

                    }

                },

                ListItemComponent {
                    type: "header"

                    Header {
                        title: ListItemData
                        opacity: 0.75
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
                        rep.data = root.selectedData;
                        rep.updateClaimantReport.connect(onUpdateClaimantReport);
                        break;
                    case "Police Reports":
                        rep = policeReportDefinition.createObject();
                        rep.data = root.selectedData
                        rep.updatePoliceReport.connect(onUpdatePoliceReport);
                        break;
                    case "Witness Reports":
                        rep = witnessReportDefinition.createObject();
                        rep.data = root.selectedData
                        rep.updateWitnessReport.connect(onUpdateWitnessReport);
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
                ReportModel {
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
                    source: "sql/data_r5.db"
                    property int loadCounter: 0

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

    function onUpdatePoliceReport(data) {
        console.log("updating PR from page");
        asyncDataSource.execute("UPDATE PoliceReport SET Name = :Name, Phone = :Phone, Email = :Email, Incident = :Incident, EventDetail = :EventDetail WHERE ClaimNo = :ClaimNo", {
                Name: data.Name,
                Phone: data.Phone,
                Email: data.Email,
                Incident: data.Incident,
                EventDetail: data.EventDetail,
                ClaimNo: claimNo
            }, data.ID);

        var indexPath = reportModel.find(root.selectedData);
        reportModel.updateItem(indexPath, data);
    }

    function onUpdateWitnessReport(data) {
        console.log("updating WR from page");
        asyncDataSource.execute("UPDATE Witness SET Name = :Name, Phone = :Phone, Email = :Email, Statement = :Statement WHERE ID = :ClaimNo", {
                Name: data.Name,
                Phone: data.Phone,
                Email: data.Email,
                Statement: data.Statement,
                ClaimNo: claimNo
            }, data.ID);

        var indexPath = reportModel.find(root.selectedData);
        reportModel.updateItem(indexPath, data);
    }

    function onUpdateClaimantReport(data) {
        console.log("updating CR from page");
        asyncDataSource.execute("UPDATE Claimant SET Name = :Name, Phone1 = :Phone, Email = :Email, Statement = :Statement WHERE ID = :ClaimNo", {
                Name: data.Name,
                Phone: data.Phone,
                Email: data.Email,
                Statement: data.Statement,
                ClaimNo: claimNo
            }, data.ID);

        var indexPath = reportModel.find(root.selectedData);
        reportModel.updateItem(indexPath, data);
    }

    onClaimNoChanged: {
        if (claimNo.trim().length == 0) {
            return;
        }
        var str = "SELECT ClaimNo, Name, Address, Phone1 as Phone, Phone2, '' as Extension, Email, Statement, 'Claimant Reports' as ReportType, '' as Incident FROM Claimant "
        str += "WHERE ClaimNo = '" + claimNo + "' UNION "
        str += "SELECT ClaimNo, Name, '' as Address, Phone, '' as Phone2, Extension, Email, EventDetail as Statement,'Police Reports' as ReportType, Incident FROM PoliceReport "
        str += "WHERE ClaimNo = " + claimNo + " UNION "
        str += "SELECT ClaimNo, Name, Address, Phone, '' as Phone2, '' as Extension, Email, Statement, 'Witness Reports' as ReportType, '' as Incident FROM Witness "
        str += "WHERE ClaimNo = " + claimNo + ""
        asyncDataSource.query = str
        //console.log("Claim No: ", claimNo)
        asyncDataSource.load();
    }
}
