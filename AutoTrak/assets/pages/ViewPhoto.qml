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

Page {
    id: root
    objectName: "viewPhoto"
    property string photoID: ""
    property string claimNo: ""
    property string photoPath
    property variant selectedData
    
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        background: Color.Black
        
        ImageView {
            id : img
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            scalingMethod: ScalingMethod.AspectFit
            
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        root.actionBarVisibility = root.actionBarVisibility == ChromeVisibility.Hidden ?
                        	ChromeVisibility.Overlay : ChromeVisibility.Hidden;
                    }
                }
            ]
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: editPhotoDefinition
            source: "asset:///pages/EditPhoto.qml"
        }
    ]
    
    actions: [
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///img/edit_icon_81x81.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                var page =  editPhotoDefinition.createObject();
                page.claimNo = root.claimNo;
                nav.push(page);
                nav.peekEnabled = false;
                page.setImage(photoPath);
            }
        },
        
        ActionItem {
            title: qsTr("Share")
            imageSource: "asset:///img/share_icon_81x81.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            attachedObjects: [
                Invocation {
                    property bool armed: false
                    id: invokeShare
                    
                    onArmed: {
                        if (armed) {
                            invokeShare.trigger("bb.action.SHARE")
	                    }
                        armed = true;
                    }
                }
            ]
            
            onTriggered: {
               invokeShare.trigger("bb.action.SHARE")
            }
        },
        
        DeleteActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
        }
    ]
    
    onPhotoPathChanged: {
        img.imageSource = photoPath;
        
        invokeShare.query.uri = photoPath
        invokeShare.query.updateQuery();
    }
}
