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
    
    signal updateWitnessReport(variant data);
    
    function update() {
        console.log("updating PR data")
        root.data = null;
        root.data = editPage.data;
        
        updateWitnessReport(editPage.data);
    }
    
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///img/yellow_sign.png"
        },
        ComponentDefinition {
            id: editReportDefinition
            source: "asset:///pages/EditWitnessReport.qml"
        }
    ]
    
        Container {
            background: back.imagePaint
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            HeaderBar {
                title: "Witness Report"
            }
           ScrollView { 
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
                    }
                    
                    Label {
                        id: repName
                    }
                }
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Address: ")
                    }
                    
                    Label {
                        id: address
                    multiline: true
                    minHeight: 100.0
                }
                }
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Phone: ")
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
                    minHeight: 100.0
                }
                }
                
                Container {
                    topPadding: 30
                    layout: StackLayout {
                       // orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Statement: ")
                    }

                ScrollView {
                    Label {
                        id: statement
                        multiline: true
                        minHeight: 100
                        textStyle {
                            fontWeight: FontWeight.Bold
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
                editPage.updateWitnessReport.connect(update);
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
                var str = "Claim #: "+data.ClaimNo+"\nWitness: "+data.Name+"\nAddress:"+data.Address+"\nPhone #:"+(data.Phone||'')+"\nStatement:\n\n" + data.Statement;
                shareInvoke.query.data = str
            }
            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]
    
    onDataChanged: {
        if (data) {
	        phoneNo.text = data.Phone
	        repName.text = data.Name
	        address.text = data.Address
            statement.text = data.Statement
            
	        if (data.Email && data.Email.length > 0) {
	            emailBlock.visible = true
	            email.text = data.Email
	            invoke.query.uri = "mailto:" + data.Email + "?subject=Witness%20Report"
	            invoke.query.updateQuery()
	        }
	    }
    }
}
