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
import "pages"

TabbedPane {
    id: root
    
    Menu.definition: MenuDefinition {
        actions: [
        	ActionItem {
             title: qsTr("About")
         }
        ]
    }
    
    showTabsOnActionBar: false
    onActiveTabChanged: {
        for(var i=0; i < tabs.length; ++i) {
            if (activeTab == tabs[i]) {
                tabs[i].imageSource = "asset:///img/open_folder_icon_81x81.png";
            } else {
                tabs[i].imageSource = "asset:///img/folder_icon_81x81.png";
            }
        }
        activeTab.refresh()
    }

    tabs: [
        BaseTab {
            title: qsTr("All")
            imageSource: "asset:///img/open_folder_icon_81x81.png"
        },
        BaseTab {
            id: notViewed
            title: qsTr("Not Viewed")
            whereClause: "Status = 1"
        },
        BaseTab {
            title: qsTr("Viewed")
            whereClause: "Status = 2"
        },
        BaseTab {
            title: qsTr("Customer Contacted")
            whereClause: "Status = 3"
        },
        BaseTab {
            title: qsTr("Repair Shop Chosen")
            whereClause: "Status = 4"
        },
        BaseTab {
            title: qsTr("Quote Received")
            whereClause: "Status = 5"
        },
        BaseTab {
            title: qsTr("Repair Pending")
            whereClause: "Status = 6"
        },
        BaseTab {
            title: qsTr("Repair Completed")  
            whereClause: "Status = 7"          
        },
        BaseTab {
            title: qsTr("Funds Released")
            whereClause: "Status = 8"
        },
        BaseTab {
            title: qsTr("Closed File")
            whereClause: "Status = 9"
        }
    ]
    
    onCreationCompleted: {
        activeTab.refresh();
    }
}
