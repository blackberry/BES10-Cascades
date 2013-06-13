/****************************************************************************
 * Copyright 2012 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/
/*
 * This is the main screen of the application. This will create listview
 * having custom Header list Item for ECL groups and also custom list item
 * for expanded header item.
 *****************************************************************************/
import bb.cascades 1.0
import ecl.contact.utils 1.0

NavigationPane {
    id: mainPane
    Page {
        titleBar: TitleBar {
            title: qsTr("Emergency Contact List")
        }
        Container {
            layout: DockLayout {
            }
            //! [0]
            ListView {
                // This function creates the phone list screen when the user 
                // tries to call a contact from the context menu. 
                function phoneListScreen(indexPath, actionText) {
                    console.log("phoneListScreen\n");
                    var selectedItemData = dataModel.data(indexPath);
                    var list = _eclutils.getPhoneList(selectedItemData);
                    console.log("\n List Count %d", list.length);
                    if (list.length > 1) {
                        var p = phoneList.createObject();
                        p.detailData = list;
                        p.titleText = actionText + " To \"" + selectedItemData.Name + "\"";
                        p.actionText = actionText;
                        mainPane.push(p);
                    } else if ((list.length == 1) && (list[0].fieldName == eclConfig.jsonFieldName(EclConfig.CellPhone) || 
                                    list[0].fieldName == eclConfig.jsonFieldName(EclConfig.OfficePhone))) {
                        _eclutils.makeCall(list[0].fieldValue);
                    }
                }
                // This function invokes the Email Client pre-populated with the email address 
                // of the contact. 
                function invokeEmailClient(indexPath, actionText) {
                    var selectedItemData = dataModel.data(indexPath);
                    var email = _eclutils.getEmailAddress(selectedItemData);
                    _eclutils.sendEmail(email.fieldValue);
                }
                id: mainList
                horizontalAlignment: HorizontalAlignment.Center
                dataModel: _model

                //! [0]
                listItemComponents: [
                    // Standard header height is too short to be selectable.
                    // Using custom header item
                    //! [1]
                    ListItemComponent {
                        type: "header"
                        EclHeaderListitem {
                            title: ListItemData.data.Title
                            isExpand: ListItemData.expanded
                        }
                    },
                    ListItemComponent {
                        type: "item"
                        CustomListItem {
                            id: itemRoot
                            title: ListItemData.Name
                            description: ListItemData.Role
                            contextActions: [
                                ActionSet {
                                    actions: [
                                        ActionItem {
                                            id: call
                                            title: qsTr("Call")
                                            imageSource: "asset:///images/outgoingcall.png"
                                            onTriggered: {
                                                console.log("Call the contact");
                                                var mainList = itemRoot.ListItem.view;
                                                mainList.phoneListScreen(mainList.selected(), call.title);
                                            }
                                        },
                                        ActionItem {
                                            id: sms
                                            title: qsTr("SMS")
                                            imageSource: "asset:///images/chat.png"
                                            onTriggered: {
                                                console.log("Send SMS to contact");
                                                var mainList = itemRoot.ListItem.view;
                                                mainList.phoneListScreen(mainList.selected(), sms.title);
                                            }
                                        },
                                        ActionItem {
                                            id: email
                                            title: qsTr("Email")
                                            imageSource: "asset:///images/mail.png"
                                            onTriggered: {
                                                console.log("Send Email to contact");
                                                var mainList = itemRoot.ListItem.view;
                                                mainList.invokeEmailClient(mainList.selected(), email.title);
                                            }
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                ]
                onTriggered: {
                    //console.log("On Triggered Called for mainList");
                    mainList.clearSelection();
                    select(indexPath);
                    if (_model.itemType(indexPath) == "item") {
                        var p = viewDetails.createObject();
                        var selectedItemData = dataModel.data(indexPath);
                        console.log(selectedItemData);
                        p.detailData = selectedItemData;
                        mainPane.push(p);
                    } else { //Header item triggered
                        scrollToItem(indexPath, 2)
                    }
                }
                onSelectionChanged: {
                    _app.selectionChanged(indexPath, selected);
                }
            }
        }
        attachedObjects: [
            ComponentDefinition {
                id: viewDetails
                source: "viewdetails.qml"
            },
            ComponentDefinition {
                id: phoneList
                source: "phonelist.qml"
            },
            EclConfig {
                id: eclConfig
            }
        ]
        onCreationCompleted: {
            OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
        }
        actions: [
            // Demos ECL app by loading the data from a text file
            // instead of via the push notification
            ActionItem {
                ActionBar.placement: ActionBarPlacement.InOverflow
                title: "Demo with Text File"
                onTriggered: {
                    _app.demoTextActionTriggered();
                }
            },
            // Demos ECL app by loading the data from a JSON file
            // instead of via the push notification
            ActionItem {
                ActionBar.placement: ActionBarPlacement.InOverflow
                title: "Demo with JSON File"
                onTriggered: {
                    _app.demoJSONActionTriggered();
                }
            }
        ]
    }
}
