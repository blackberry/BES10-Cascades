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

Tab {
    ActionBar.placement: ActionBarPlacement.InOverflow
    imageSource: "asset:///img/folder_icon_81x81.png"
    
    property alias pageObjectName: pg.objectName
    property alias modelObjectName: pg.modelObjectName
    property alias dataSource: pg.dataSource
    property alias whereClause: pg.whereClause
    property bool autoLoad: false
    
    property variant claimDetail;
    
    function refresh() {
        pg.refresh();
    }
    
    function updateData() {
        pg.updateData();
    }
    
    NavigationPane {
        id: nav
        
        onTopChanged: {
            nav.peekEnabled = (page.objectName != "editPhoto");
        }
        
	    BaseTabPage {
	    	id: pg
	    	
	    	onShowClaimDetail: {
	            // Create the content page and push it on top to drill down to it.
	            claimDetail = claimDetailDefinition.createObject();
	            claimDetail.claimData = selectedData;
	            claimDetail.updateClaim.connect(pg.updateClaim)
	            claimDetail.nav = nav; 
	            nav.push(claimDetail);
	        }
	    }
	    
	    attachedObjects: [
	        ComponentDefinition {
	            // Definition used for creating a Content Page to which the
	            // user can drill down to read the quote.
	            id: claimDetailDefinition
	            source: "pages/ClaimDetail.qml"
	        }
	    ]
    }
}
