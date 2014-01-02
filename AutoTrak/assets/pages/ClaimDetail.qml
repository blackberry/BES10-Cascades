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
import "../models"

Page {
    id: root
    property variant claimData
    property variant nav
    property variant editPage

    signal updateClaim(variant data)

    function updateClaimData() {
        console.log("updating claim data")
        root.claimData = null;
        root.claimData = editPage.claimData;

        updateClaim(editPage.claimData);
    }

    titleBar: TitleBar {
        id: titleBar
    }
    Container {
        background: back.imagePaint

        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            background: Color.create("#333333")

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.5
                    }
                    Label {
                        id: claimantName
                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.White
                        }
                    }
                }

                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.5
                    }
                    Label {
                        id: claimNo
                        horizontalAlignment: HorizontalAlignment.Right
                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.White
                        }
                    }
                }

            }

            topPadding: 30
            bottomPadding: 30
            rightPadding: 30
            leftPadding: 30
        }

        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
            }

            Container {
                Header {
                    id: header
                    opacity: 0.75
                }

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    leftPadding: 20
                    rightPadding: 20
                    Container {
                        topPadding: 20
                        bottomPadding: 20

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Claim Date: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: claimDate
                                text: "."
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Insurer: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: insurer
                                text: "."
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Policy #: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: policyNo
                                text: "."
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Insured Until: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: insureUntil
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                //orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Auto Year/Make/Model: ")
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: autoModel
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("License Plate: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: licensePlate
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Loss/Damage Date: ")
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: lossDate
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Location: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: location
                                multiline: true
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Cause: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: cause
                                multiline: true
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Police Unit Notified: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: policeUnit
                                multiline: true
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }

                        Container {
                            topPadding: 10
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: qsTr("Notified Date: ")
                                minWidth: 250
                                textStyle.color: Color.create("#fff9fb67")
                            }
                            Label {
                                id: unitNotifyDate
                                text: "."
                                textStyle.color: Color.create("#ff78aaff")
                            }
                        }
                    }

                    Container {
                        horizontalAlignment: HorizontalAlignment.Right
                    }
                }

            }
        }

    }

    attachedObjects: [
        ComponentDefinition {
            id: editClaimDefinition
            source: "asset:///pages/EditClaim.qml"
        },
        ComponentDefinition {
            id: reportDefinition
            source: "asset:///pages/Reports.qml"
        },
        ComponentDefinition {
            id: photoDefinition
            source: "asset:///pages/Photos.qml"
        },
        ComponentDefinition {
            id: repairDefinition
            source: "asset:///pages/Repairs.qml"
        },
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/Highway_Night_HKG.png"
        }
    ]

    actions: [
        ActionItem {
            title: qsTr("Photos")
            imageSource: "asset:///img/picture_icon_81x81.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                var photoPage = photoDefinition.createObject();
                photoPage.claimNo = root.claimData.ClaimNo;
                nav.push(photoPage);
            }
        },
        ActionItem {
            title: qsTr("Details & Reports")
            imageSource: "asset:///img/details_icon.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                var reportPage = reportDefinition.createObject();
                reportPage.claimNo = root.claimData.ClaimNo;
                nav.push(reportPage);
            }
        },
        ActionItem {
            title: qsTr("Repairs")
            imageSource: "asset:///img/car_icon.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                var reportPage = repairDefinition.createObject();
                reportPage.claimNo = root.claimData.ClaimNo;
                nav.push(reportPage);
            }
        },
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///img/edit_icon_81x81.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                editPage = editClaimDefinition.createObject(root);
                editPage.updateClaim.connect(updateClaimData);
                editPage.claimData = root.claimData;
                editPage.open();
                //nav.push(editPage);
            }
        },
        InvokeActionItem {
            id: shareAction
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
                data: ""
            }
            title: qsTr("Share")
            //imageSource: "asset:///img/share_icon_81x81.png"

            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]

    onClaimDataChanged: {
        if (claimData) {
            claimantName.text = claimData.Name;
            header.title = qsTr("Status:") + " " + claimData.StatusName;
            claimDate.text = Qt.formatDateTime(_app.strToDate(claimData.ClaimDate), "MMMM d, yyyy");
            claimNo.text = qsTr("Claim #: ") + claimData.ClaimNo;
            policyNo.text = claimData.PolicyNo;
            insurer.text = claimData.Insurer;
            insureUntil.text = Qt.formatDateTime(_app.strToDate(claimData.InsuredUntil), "M/d/yyyy");
            autoModel.text = claimData.Vehicle;
            licensePlate.text = claimData.LicensePlateNo;
            lossDate.text = Qt.formatDateTime(_app.strToDate(claimData.LossDamageDate), "M/d/yyyy h:mmA");
            location.text = claimData.Location;
            cause.text = claimData.DamageLossCause;
            policeUnit.text = claimData.PoliceUnit;
            unitNotifyDate.text = Qt.formatDateTime(_app.strToDate(claimData.UnitNotifyDate), "M/d/yyyy h:mmA");

            var str = "Claim #: %1\n\nClaim Date: %2\nClaimant: %3";

            shareAction.query.data = str.arg(claimData.ClaimNo).arg(claimDate.text).arg(claimData.Name);

            shareAction.query.updateQuery();
        }
    }
}
