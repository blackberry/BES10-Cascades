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
 * This is the details screen and it displays all the details of the selected
 * contact.
 *****************************************************************************/
import bb.cascades 1.0
import bb.system 1.0
import ecl.contact.utils 1.0

Page {
    id: viewPage
    property variant detailData: undefined
    property variant list: undefined
    onDetailDataChanged: {
        console.log("before setting map")
        /*
        * An "Unknown symbol" warning is shown for all the objects exposed from c++
        * could not figure out fix, this seems a qml editor problem
        */
        list = _eclutils.mapToList(detailData);
        var i = 0;
        
        /*
         * For each JSON field it assigns as display string for UI
         * assigns the icon for the field
         * assign action for each filed
         * and add the item to list 
         */
        function changeFieldNameAndInsert(jSonFieldName, displayFieldName, imageName, action) {
            var fieldMap;
            for (i = 0; i < list.length; i ++) {
                if (list[i].fieldName == jSonFieldName) {
                    fieldMap = list[i];
                    break;
                }
            }
            if (i < list.length) {
                fieldMap.image = imageName;
                fieldMap.fieldName = displayFieldName;
                fieldMap.action = action;
                listView.dataModel.append(fieldMap);
            }
        }
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.OfficePhone), 
                                 eclConfig.displayString(EclConfig.OfficePhone, "Call "),
                                 eclConfig.fieldIcon(EclConfig.OfficeIcon), EclConfig.Call)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.OfficePhone),
                                 eclConfig.displayString(EclConfig.OfficePhone, "SMS "),
                                 eclConfig.fieldIcon(EclConfig.SMSIcon), EclConfig.SendSMS)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.CellPhone), 
                                 eclConfig.displayString(EclConfig.CellPhone, "Call "),
                                 eclConfig.fieldIcon(EclConfig.CellIcon), EclConfig.Call)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.CellPhone),
                                 eclConfig.displayString(EclConfig.CellPhone, "SMS "),
                                 eclConfig.fieldIcon(EclConfig.SMSIcon), EclConfig.SendSMS)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.Email),
                                 eclConfig.displayString(EclConfig.Email),
                                 eclConfig.fieldIcon(EclConfig.EmailIcon), EclConfig.SendEmail)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.Backup), 
                                 eclConfig.displayString(EclConfig.Backup),
                                 eclConfig.fieldIcon(EclConfig.BackupIcon), EclConfig.None)
        changeFieldNameAndInsert(eclConfig.jsonFieldName(EclConfig.BBPin),
                                 eclConfig.displayString(EclConfig.BBPin),
                                 eclConfig.fieldIcon(EclConfig.BBMIcon), EclConfig.None)
    }
    content: Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        Container {
            id: innerContainer
            layout: DockLayout {
            }
            ImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                preferredWidth: innerContainer.maxWidth
                imageSource: "asset:///images/header.png"
            }
            Container {
                leftPadding: 20
                bottomPadding: 20
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                clipContentToBounds: false
                Label {
                    text: detailData.Name
                    textStyle {
                        base: SystemDefaults.TextStyles.BigText
                    }
                }
                Label {
                    text: detailData.Role
                }
            }
        }
        ListView {
            id: listView
            objectName: "listView"
            horizontalAlignment: HorizontalAlignment.Center
            dataModel: ArrayDataModel {
            }
            property int activeItem: -1
            listItemComponents: [
                ListItemComponent {
                    type: "header"
                    Container {
                    }
                },
                ListItemComponent {
                    StandardListItem {
                        id: listItem
                        title: ListItemData.fieldName
                        description: ListItemData.fieldValue
                        imageSource: ListItemData.image
                    }
                }
            ]
            onTriggered: {
                clearSelection();
                select(indexPath);
                var selectedItemData = dataModel.data(indexPath);
                if (selectedItemData.action == EclConfig.Call) {
                    _eclutils.makeCall(selectedItemData.fieldValue);
                } else if (selectedItemData.action == EclConfig.SendEmail) {
                    _eclutils.sendEmail(selectedItemData.fieldValue)
                } else if (selectedItemData.action == EclConfig.SendSMS) {
                    console.log("sending SMS...");
                    _eclutils.sendSMS(selectedItemData.fieldValue)
                }
            }
            leftPadding: 10
        }
    }
    onCreationCompleted: {
        // this slot is called when declarative scene is created
        // write post creation initialization here
        console.log("Page - onCreationCompleted()")

        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }
    actions: [
        ActionItem {
            title: qsTr("Add To Contact")
            imageSource: "asset:///images/action_addcontact.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                addContactDialog.show();
            }
        }
    ]
    attachedObjects: [
        EclContact {
            id: eclContact
        },
        EclConfig {
            id: eclConfig
        },
        SystemDialog {
            id: addContactDialog
            title: qsTr("Confirmation!!")
            body: qsTr("Contact will be added to device contacts ?")
            onFinished: {
                console.log(addContactDialog.result)
                if (addContactDialog.result == SystemUiResult.ConfirmButtonSelection) {
                    if (false == eclContact.saveToAddressBook(detailData)) {
                        console.log("Error in adding contact");
                        userInfo.body = qsTr("Add to contact is failed")
                    } else {
                        userInfo.body = qsTr("Add to contact is successfull")
                    }
                    userInfo.show();
                }
            }
        },
        SystemToast {
            id: userInfo
        }
    ]
}
