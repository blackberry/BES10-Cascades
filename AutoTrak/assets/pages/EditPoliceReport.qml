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
import ".."

Sheet {
    id: root
    
    property variant data;
    signal updatePoliceReport(variant d);
    
    Page {
        titleBar: TitleBar {
            title: qsTr("Edit Police Report")
            dismissAction: ActionItem {
                title: "Cancel"
                onTriggered: {
                    root.close();
                }
            }
            acceptAction: ActionItem {
                title: "Save"
                onTriggered: {
                    console.log("Updating..")
                    var dat = root.data;
                    data.Phone = phoneNo.text 
                    data.Name = repName.text
                    data.Email = email.text 
                    data.Incident = incident.text
                    data.EventDetail = eventDetail.text
                    root.data = dat;
                    updatePoliceReport(dat);
                    root.close();
                }
            }
        }
        ScrollView {
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
            }
            Container {
                topPadding: 20
                bottomPadding: 20
                leftPadding: 20
                rightPadding: 20
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Name: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: repName  
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Label {
                        text: qsTr("Email: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: email 
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Label {
                        text: qsTr("Phone #: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: phoneNo
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Label {
                        text: qsTr("Incident: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: incident
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Label {
                        text: qsTr("Event Detail: ")
                        verticalAlignment: VerticalAlignment.Top
                    }
                    TextArea {
                        id: eventDetail
                    }
                }
            }
        }
    }
    
    onDataChanged: {        
        phoneNo.text = data.Phone
        repName.text = data.Name
        email.text = data.Email
        incident.text = data.Incident
        eventDetail.text = data.Statement
    }
}
