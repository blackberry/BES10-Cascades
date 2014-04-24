/* Copyright (c) 2013, 2014  BlackBerry Limited.
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
 *
 */

// Tabbed Pane project template
import bb.cascades 1.0

TabbedPane {
    id: tabbedPane
    showTabsOnActionBar: false
    Menu.definition: MenuDefinition {
        attachedObjects: [
            ComponentDefinition {
                id: aboutComponent
                source: "About.qml"
            }
        ]
        actions: [
            ActionItem {
                title: qsTr("About")
                imageSource: "asset:///images/ic_info.png"
                onTriggered: {
                    var pageAbout = aboutComponent.createObject();
                    tabbedPane.activePane.push(pageAbout);
                    Application.menuEnabled = false;
                }
            }
        ]
    }

    Tab {
        title: qsTr("Expenses")
        imageSource: "asset:///images/ic_Expense.png"
        Expenses {
        }
    }

    onCreationCompleted: {
        console.log("TabbedPane - onCreationCompleted()")

        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }
}
