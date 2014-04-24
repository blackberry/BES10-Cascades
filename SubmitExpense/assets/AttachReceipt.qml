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

import bb.cascades 1.0
import bb.system 1.0

Page {
    property variant nav
    property bool pictureSelected: false

    signal receiptIsAttached(); // notifies that a receipt has been selected

    actions: [
        ActionItem {
            title: qsTr("Camera")
            imageSource: "asset:///images/ic_camera.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                // Open Camera page to invoke camera app
                var camPage = cameraPage.createObject();
                nav.push(camPage);
                camPage.triggered = true;
            }
        },

        ActionItem {
            title: qsTr("Search")
            imageSource: "asset:///images/ic_search.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                toastMessage.body = qsTr("Functionality is not implemented yet");
                toastMessage.show();
            }
        }
    ]

    attachedObjects: [
        SystemToast {
            id: toastMessage
        },
        ComponentDefinition {
            id: cameraPage
            source: "CameraPage.qml"
        }
    ]

    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: qsTr("Up")
            imageSource: "asset:///images/ic_up.png"
            onTriggered: {
                nav.pop()
            }
        }
    }

    titleBar: TitleBar {
        title: pictureSelected ? qsTr("1 item selected") : qsTr("Select Picture")
        dismissAction: ActionItem {
            title: qsTr("Cancel")
            onTriggered: {
                nav.pop();
            }
        }

        acceptAction: ActionItem {
            title: qsTr("Done")
            enabled: pictureSelected
            onTriggered: {
                // notify that a receipt has been selected
                receiptIsAttached();
                nav.pop();
            }
        }
    }

    // Content of the Page
    Container {
        Container {
            topPadding: 10
            Header {
                title: qsTr("Camera")
            }
        }

        Container {
            leftPadding: 5
            topPadding: 5

            ImageView {
                imageSource: pictureSelected ? "asset:///images/thumbnail_receipt_selected.png" : "asset:///images/thumbnail_receipt.png"
            }

            onTouch: {
                if (event.isUp()) {
                    // select/de-select a photo
                    pictureSelected = ! pictureSelected;
                }
            }
        }
    } // end of content Container
} // end of Page