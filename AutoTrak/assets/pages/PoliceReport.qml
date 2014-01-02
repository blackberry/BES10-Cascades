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
    property variant data;
    property variant editPage
    
    signal updatePoliceReport(variant data);
    
    function update() {
        console.log("updating PR data")
        root.data = null;
        root.data = editPage.data;
        
        updatePoliceReport(editPage.data);
    }
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/blue_sign.png"
        },
        ComponentDefinition {
            id: editReportDefinition
            source: "asset:///pages/EditPoliceReport.qml"
        }
    ]
    

        Container {
            background: back.imagePaint
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            HeaderBar {
                title: "Police Report"
            }
            
            Header {
                title: qsTr("Contact Info")   
            }
            ScrollView{
            Container {
                rightPadding: 30
                leftPadding: 30
                bottomPadding: 30
                topPadding: 30
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Name: ")
                        minWidth: 175
                    textStyle.color: Color.create("#FFFFFF")
                }
                    
                    Label {
                        id: repName
                    textStyle.color: Color.create("#FFFFFF")
                }
                }
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Phone: ")
                        minWidth: 175
                    textStyle.color: Color.create("#FFFFFF")
                }
                    
                    Label {
                        id: phoneNo
                        textStyle {
                            fontWeight: FontWeight.Bold
                        }
                        gestureHandlers: [
                            TapHandler {
                                onTapped: {
                                    _app.callNumber(phoneNo.text)
                                }
                            }
                        ]
                    textStyle.color: Color.create("#FFFFFF")
                }
                }
                
                Container {
                    topPadding: 30
                    id: emailBlock
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Email: ")
                        minWidth: 175
                    textStyle.color: Color.create("#FFFFFF")
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
                    textStyle.color: Color.create("#FFFFFF")
                    minHeight: 100.0
                    multiline: true
                    autoSize.maxLineCount: 2
                }
                }
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                        //orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Incident: ")
                        minWidth: 175
                    textStyle.color: Color.create("#FFFFFF")
                }

                
                    Label {
                        id: incident
                        multiline: true
                        textStyle.color: Color.create("#FFFFFF")
                    }
                }
            
                
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                        //orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Detail of Event: ")
                        minWidth: 175
                    textStyle.color: Color.create("#FFFFFF")
                }

                ScrollView {
                    Label {
                        id: eventDetail
                        multiline: true
                        minHeight: 100
                        textStyle.color: Color.create("#FFFFFF")
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
                editPage.updatePoliceReport.connect(update);
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
                var str = "Claim #: "+data.ClaimNo+"\nName: "+data.Name+"\nPhone #:"+(data.Phone || '')+"\nIncident: "+data.Incident+"\nEvent Detail: " + data.Statement;
                shareInvoke.query.data = str
            }
            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]
    
    onDataChanged: {
        if (data) {
	        phoneNo.text = data.Phone + " Ext. " + data.Extension
	        repName.text = data.Name
	        
	        if (data.Email && data.Email.length > 0) {
	            emailBlock.visible = true
	            email.text = data.Email
	            invoke.query.uri = "mailto:" + data.Email + "?subject=Police%20Report%20-%20Claimant%20" + data.Name
	            invoke.query.updateQuery()
	        }
	        incident.text = data.Incident
	        eventDetail.text = data.Statement
	    }
    }
}
