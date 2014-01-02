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

GroupDataModel {
    id: claimModel
    signal updateSelectedData(variant indexPath);
    signal newDataItem();

    grouping: ItemGrouping.None
    
    onItemAdded: {
        if (indexPath.length > 1){
            // Update the data that will be shown in the page.
            updateSelectedData(indexPath);
            newDataItem()            
        }
    }
    
    onItemRemoved: {
        // After removing the selected item, we want another one to be shown.
        // So we select the next item relative to the removed one in the list.
        // The header items are not of interest in this case so updates are only done if the removed
        // item indexPath has a length larger then 1.
        if (indexPath.length > 1) {
            var selectIndexPath = indexPath;

            // Check for defined data around the removed indexPath.
            if (data(selectIndexPath) == undefined) {
                selectIndexPath[1] = indexPath[1] - 1
                if (data(selectIndexPath) == undefined) {
                    selectIndexPath[0] = indexPath[0] + 1;
                    selectIndexPath[1] = indexPath[1];
                    if (data(selectIndexPath) == undefined) {
                        selectIndexPath[0] = indexPath[0] - 1
                    }
                }
            }
             updateSelectedData(selectIndexPath);
        }
    }
    
    onItemUpdated: {
        updateSelectedData(indexPath);
    }
}
