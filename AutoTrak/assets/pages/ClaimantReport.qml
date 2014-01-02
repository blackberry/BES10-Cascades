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
import ".."

Page {
    id: root
    property variant data
    property variant editPage

    signal updateClaimantReport(variant data)

    function update() {
        console.log("updating CR data")
        root.data = null;
        root.data = editPage.data;

        updateClaimantReport(editPage.data);
    }

    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/green_sign.png"
        },
        ComponentDefinition {
            id: editReportDefinition
            source: "asset:///pages/EditClaimantReport.qml"
        }
    ]


        Container{
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: back.imagePaint
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        HeaderBar {
            title: "Claimant Report"

        }
        ScrollView{
        Container {
            rightPadding: 30
            leftPadding: 30
            bottomPadding: 30
            topPadding: 30
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Contact Info ") + "</span></html>"
                    minWidth: 175

                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Name: ") + "</span></html>"
                    minWidth: 175

                }

                Label {
                    id: repName
                    text: ""
                }
            }

            Container {
                topPadding: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Address: ") + "</span></html>"
                    minWidth: 175

                }

                Label {
                    id: address
                    multiline: true
                    text: qsTr("")
                    minHeight: 100.0
                    autoSize.maxLineCount: 2

                }
            }

            Container {
                topPadding: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Phone: ") + "</span></html>"
                    minWidth: 175
                }

                Label {
                    id: phoneNo
                    textStyle {
                        fontWeight: FontWeight.Bold
                    }
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                _app.callNumber(data.phoneNo)
                            }
                        }
                    ]
                }
            }

            Container {
                topPadding: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Phone 2: ") + "</span></html>"
                    minWidth: 175
                }

                Label {
                    id: phoneNo2
                    textStyle {
                        fontWeight: FontWeight.Bold
                    }
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                _app.callNumber(data.phoneNo2)
                            }
                        }
                    ]
                }
            }

            Container {
                topPadding: 30
                id: emailBlock
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Email: ") + "</span></html>"
                    minWidth: 175
                }

                Label {
                    id: email
                    textStyle {
                        fontWeight: FontWeight.Bold
                    }
                    attachedObjects: [
                        Invocation {
                            id: invoke
                            query {
                                invokeActionId: "bb.action.SENDEMAIL"
                                invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                                mimeType: "message/rfc822"
                            }
                        }
                    ]
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                invoke.trigger("bb.action.SENDEMAIL")
                            }
                        }
                    ]
                    multiline: true
                    autoSize.maxLineCount: 2
                    minHeight: 100.0
                }
            }

            Container {
                topPadding: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    minWidth: 175
                    text: "<html><span style='color:#FFFFFF'>" + qsTr("Statement: ") + "</span></html>"
                }
                ScrollView {
                    scrollViewProperties.scrollMode: ScrollMode.Vertical
                    Container {
                        Label {
                            id: statement
                            multiline: true
                            minHeight: 100
                            textStyle {
                                fontWeight: FontWeight.Bold
                            }
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                        }
                    }
                }
            }

        }

    }
}
    actions: [
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///img/edit_icon_81x81.png"

            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                editPage = editReportDefinition.createObject(root);
                editPage.updateClaimantReport.connect(update);
                editPage.data = root.data;
                editPage.open();
                //nav.push(editPage);
            }
        },
        ActionItem {
            id: shareAction

            attachedObjects: [
                Invocation {
                    id: shareInvoke
                    property bool autoTrigger: false
                    query {
                        mimeType: "text/plain"

                        onDataChanged: {
                            shareInvoke.query.updateQuery()
                        }
                    }
                    onArmed: {

                        if (autoTrigger)
                            trigger("bb.action.SHARE");
                        autoTrigger = true;
                    }
                }
            ]

            title: qsTr("Share")
            imageSource: "asset:///img/share_icon_81x81.png"
            onTriggered: {
                var str = "Claim #: " + data.ClaimNo + "\nClaimant: " + data.Name + "\nAddress:" + (data.Address) + "\nPhone #:" + (data.Phone1 || '') + "\nPhone 2#:" + (data.Phone2 || '') + "\nStatement:\n\n" + data.Statement;
                shareInvoke.query.data = str
            }
            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]

    onDataChanged: {
        if (data) {
            statement.text = "<html><span style='color:#FFFFFF'>" + data.Statement + "</span></html>"
            phoneNo.text = "<html><span style='color:#FFFFFF'>" + data.Phone + "</span></html>"
            phoneNo2.text = "<html><span style='color:#FFFFFF'>" + data.Phone2 + "</span></html>"
            repName.text = "<html><span style='color:#FFFFFF'>" + data.Name + "</span></html>"
            address.text = "<html><span style='color:#FFFFFF'>" + data.Address + "</span></html>"

            if (data.Email && data.Email.length > 0) {
                emailBlock.visible = true
                email.text = "<html><span style='color:#FFFFFF'>" + data.Email + "</span></html>"
                invoke.query.uri = "mailto:" + data.Email + "?subject=Your%20Claim"
                invoke.query.updateQuery()
            }
        }
    }
}
