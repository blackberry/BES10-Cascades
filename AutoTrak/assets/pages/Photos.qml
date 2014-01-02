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
import autotrak.data 1.0
import bb.cascades.pickers 1.0
import ".."
import "../models"

Page {
    id: root
    
    property string claimNo: "";
    property variant selectedData
    
    actions: [
        ActionItem {
            title: qsTr("Add Photo")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///img/add_icon_81x81.png"
            onTriggered: {
                filePicker.open()
            }
        }
    ]
    
    attachedObjects: [
        FilePicker {
            id: filePicker
            mode: FilePickerMode.Picker
            type: FileType.Picture
            imageCropEnabled: true
            onFileSelected: {
                _app.photoImported.connect(onImported);
                _app.importPhoto(claimNo, selectedFiles[0]);
            }
        }
    ]
    
    function onImported(){
        _app.photoImported.disconnect(onImported)
        photoModel.clear();
        asyncDataSource.load()
    }
    
    Container {
        background: Color.Black
        HeaderBar {
            title: qsTr("Photos")
        }
        ListView {
            id: listView
            dataModel: photoModel
            layout: GridListLayout {
                columnCount: 3
                verticalCellSpacing: 1
                horizontalCellSpacing: 1
                
            }
            listItemComponents: [
                ListItemComponent {
                    type: "image"
                    
                    ImageView {
                        imageSource: "file://" + _app.dataPath + "/photos/" +  ListItemData.ID + ".jpg"
                        scalingMethod: ScalingMethod.AspectFill
                        contextActions: [
                        	ActionSet {
                             actions: [
                                 DeleteActionItem {
                                     onTriggered: {
                                         
                                     }
                                 }
                             ]
                         }
                        ]
                    }
                }
            ]
            
            
            attachedObjects: [
                PhotoModel {
                    id: photoModel
                    onUpdateSelectedData: {
                        if (indexPath[0] >= 0 && indexPath[1] >= 0) {
                            //quotesList.scrollToItem(indexPath, ScrollAnimation.Default);
                            root.selectedData = data(indexPath);
                        } else {
                            root.listEmpty();
                        }
                    }
                },
                
                ComponentDefinition {
                    id: viewPhotoDefinition
                    source: "asset:///pages/ViewPhoto.qml"
                },
                
                // Custom data source object, loads data using a SqlConnection, see customsqldatasource.cpp
                CustomSqlDataSource {
                    id: asyncDataSource
                    source: "sql/data_r5.db"
                    property int loadCounter: 0
                    
                    onDataLoaded: {
                        console.log(asyncDataSource.query)
                        console.log("Data loaded! Size: ", data.length);
                        if (data.length > 0) {
                            photoModel.insertList(data);
                            // Load the next batch, the last parameter is set to zero to tell the data source that we are loading data to the list.
                            //var offsetData = {"offset": (10 + 5 * loadCounter)};
                            //execute("SELECT * FROM Claim ORDER BY Created LIMIT 5 OFFSET :offset", offsetData, 0); 
                            //loadCounter ++;
                        }
                    }
                }
            ]

            onTriggered: {
                // To avoid triggering navigation when pressing the header items, we check so that the
                // index path length is larger then one (one entry would be a group under a header item).
                //if (indexPath.length > 1) {
                    // Update the data that will be shown in the Quotes Page.
                    root.selectedData = dataModel.data(indexPath);
                    var page =  viewPhotoDefinition.createObject();
                    page.claimNo = root.claimNo;
                    page.photoPath = "file://" + _app.dataPath + "/photos/" +  root.selectedData.ID + ".jpg"
                    nav.push(page);
                //}
            }
            
            function itemType(data, indexPath) {
                return "image";
            }
        }
    }
    
    onClaimNoChanged: {
        if (claimNo.trim().length == 0) {
            return;
        }
        var str = "SELECT * FROM Photos WHERE ClaimNo = '" + claimNo +"'"
        asyncDataSource.query = str
        //console.log("Claim No: ", claimNo)
        asyncDataSource.load();
    }
}
