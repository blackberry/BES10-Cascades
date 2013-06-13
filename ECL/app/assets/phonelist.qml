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
 * This is the phone list screen and is displayed only if multiple phone
 * numbers are associated with the contact.
 *****************************************************************************/
import bb.cascades 1.0
import ecl.contact.utils 1.0

Page {
    property variant detailData
    property string titleText
    property string actionText
    
    onDetailDataChanged: {    
        listView.dataModel.clear();    
        for (var i = 0; i < detailData.length; i++) {
            var fieldMap = detailData[i]; 
            
            if(fieldMap.fieldName == eclConfig.jsonFieldName(EclConfig.OfficePhone))
            {
                fieldMap.fieldName = eclConfig.displayString(EclConfig.OfficePhone);
                fieldMap.image = eclConfig.fieldIcon(EclConfig.OfficeIcon);
            } else
            {
                fieldMap.fieldName = eclConfig.displayString(EclConfig.CellPhone);
                fieldMap.image = eclConfig.fieldIcon(EclConfig.CellIcon);
            }
     
            listView.dataModel.append(fieldMap);
        }
    }
    titleBar: TitleBar {
        title: qsTr(titleText)
    }
    content: Container {
        layout: DockLayout {
        }
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Center
            dataModel: ArrayDataModel {
                id: phonelistmodel
            }
            listItemComponents: [
                // define delegates for different item types here
                ListItemComponent {
                    // StandardListItem is a convinient component for lists with default cascades look and feel
                    StandardListItem {
                        id: item
                        title: ListItemData.fieldName
                        description: ListItemData.fieldValue
                        imageSource: ListItemData.image
                        bottomMargin: 20
                    }
                }
            ]
            
            onTriggered: {
                if (actionText == qsTr("Call")) {
                    clearSelection();
                    select(indexPath);
                    var selectedItemData = dataModel.data(indexPath);
                    _eclutils.makeCall(selectedItemData.fieldValue);
                }
                else
                {   
                    //SMS
                    clearSelection();
                    select(indexPath);
                    var selectedItemData = dataModel.data(indexPath);
                    _eclutils.sendSMS(selectedItemData.fieldValue);
                }
            }
        }
    }
    onCreationCompleted: {
        // this slot is called when declarative scene is created
        // write post creation initialization here
        console.log("Page 2 - onCreationCompleted()")

        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }
    
    attachedObjects: [
            EclConfig {
                id: eclConfig
            }
        ]
}
