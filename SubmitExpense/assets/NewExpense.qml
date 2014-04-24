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
    property bool receiptAttached: false
    property string filePath: ""

    actions: [
        ActionItem {
            title: qsTr("Attach")
            imageSource: "asset:///images/ic_attach.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                // For the demo purpose we have custom card implemented (AttachReceipt.qml).
                // This allows us to force the user to select the embedded receipt image.
                // In real app instead of custom card the standard FilePicker with images can be invoked.
                // This will also allow to get the Camera app invoked right from the FilePicker (instead of
                // invoking it from the CameraPage.qml). If it is preferable to use the custom AttachReceipt then
                // make sure that you show the image taken from the camera in the AttachReceipt page
                var attachRec = attachReceipt.createObject();
                attachRec.nav = nav;
                nav.push(attachRec);
                attachRec.receiptIsAttached.connect(onReceiptIsAttached);
            }
        },

        ActionItem {
            title: qsTr("Submit")
            imageSource: "asset:///images/ic_send_expense.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: receiptAttached
            onTriggered: {
                toastMessage.body = qsTr("Your Expense Report has been Submitted");
                toastMessage.show();
                receiptAttached = false;

                // Send a notification for Expense Reports app
                cppSubmitExpense.sendNotificationForExpenses();
            }
        },

        ActionItem {
            id: nfcItem
            title: qsTr("NFC Submit")
            imageSource: "asset:///images/ic_nfc.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: receiptAttached
            onTriggered: {
                receiptAttached = false;
                if (filePath == invokeNFC.query.uri) {
                    invokeNFC.armed();
                } else {
                    invokeNFC.query.mimeType = "image/jpg";
                    invokeNFC.query.invokeTargetId = "sys.NFCViewer";
                    invokeNFC.query.setUri(filePath);
                }
            }
        }
    ]

    attachedObjects: [
        SystemToast {
            id: toastMessage
        },

        ComponentDefinition {
            id: attachReceipt
            source: "AttachReceipt.qml"
        },

        Invocation {
            id: invokeNFC
            query {
                onUriChanged: {
                    console.log("onUriChanged", uri);
                    invokeNFC.query.updateQuery();
                }
            }
            onArmed: {
                console.log("onArmed ready to trigger");
                invokeNFC.trigger("bb.action.SHARE");
            }
        }
    ]

    // Main container
    Container {
        background: Color.Black
        horizontalAlignment: HorizontalAlignment.Fill

        // Construct the Title Bar
        Container {
            topPadding: 5
            bottomPadding: 3
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            Container {
                ImageView {
                    imageSource: "asset:///images/display_johnathan_davis.png"
                }
            }

            Container {
                leftPadding: 20
                Container {
                    ImageView {
                        imageSource: "asset:///images/bg_new_expense.png"
                    }
                }

                Container {
                    leftPadding: 15
                    Label {
                        text: "Johnathan, Devis"
                        textStyle {
                            color: Color.White
                        }
                    }
                }

                Container {
                    leftPadding: 15
                    Label {
                        text: "UX Design"
                        textStyle {
                            color: Color.create("#b1b1b1")
                            fontSize: FontSize.XSmall
                        }
                    }
                }
            }

            Container {
                leftPadding: 210
                topPadding: 5

                ImageView {
                    imageSource: "asset:///images/new_expense_builtby_logo.png"
                }

                attachedObjects: [
                    Invocation {
                        query: InvokeQuery {
                            id: invokeQuery
                            mimeType: "text/html"
                            invokeTargetId: "sys.browser"
                        }

                        onArmed: {
                            // This gets called first time when the
                            // query is created and no uri is set
                            if (invokeQuery.uri != "") {
                                trigger("bb.action.OPEN");
                            }
                        }
                    }
                ]

                onTouch: {
                    // On Macadamian logo touch event open the www.macadamian.com within the browser
                    if (event.isUp()) {
                        invokeQuery.mimeType = "text/html"
                        invokeQuery.uri = "http://www.macadamian.com";
                        invokeQuery.updateQuery();
                    }
                }
            }
        } // end of title bar container

        // Construct the Content
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            background: Color.create("#333B46")

            ScrollView {
                Container {

                    // Expense Date container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        topPadding: 30
                        leftPadding: 5
                        rightPadding: 5

                        DateTimePicker {
                            id: picker
                            title: qsTr("Date")
                            mode: DateTimePickerMode.Date
                        }
                    }

                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        topPadding: 30
                        leftPadding: 5
                        rightPadding: 5

                        DropDown {
                            title: qsTr("Category")
                            Option {
                                text: qsTr("Travel")
                                selected: true
                            }
                        }
                    } // end of expense Date container

                    // Expense Tax amount container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: 40
                        rightPadding: 25
                        leftPadding: 25

                        Container {
                            background: Color.create("#fafafa")
                            horizontalAlignment: HorizontalAlignment.Fill
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                horizontalAlignment: HorizontalAlignment.Left
                                topPadding: 35
                                bottomPadding: 5
                                leftPadding: 30

                                Label {
                                    text: qsTr("Tax:")
                                    textStyle {
                                        fontSize: FontSize.Large
                                        color: Color.create("#555555")
                                    }
                                }
                            }

                            Container {
                                topPadding: 20
                                bottomPadding: 20
                                rightPadding: 20
                                leftPadding: 205

                                TextField {
                                    inputMode: TextFieldInputMode.NumbersAndPunctuation
                                }
                            }
                        }
                    } // end of expense tax amount container

                    // Expense Total amount container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: 3
                        rightPadding: 25
                        leftPadding: 25

                        Container {
                            background: Color.create("#fafafa")
                            horizontalAlignment: HorizontalAlignment.Fill
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                horizontalAlignment: HorizontalAlignment.Left
                                topPadding: 35
                                bottomPadding: 5
                                leftPadding: 30

                                Label {
                                    text: qsTr("Total:")
                                    textStyle {
                                        fontSize: FontSize.Large
                                        color: Color.create("#555555")
                                    }
                                }
                            }

                            Container {
                                topPadding: 20
                                bottomPadding: 20
                                rightPadding: 20
                                leftPadding: 175

                                TextField {
                                    inputMode: TextFieldInputMode.NumbersAndPunctuation
                                }
                            }
                        }
                    } // end of expense Total amount container

                    // Expense description container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: 3
                        rightPadding: 25
                        leftPadding: 25

                        Container {
                            background: Color.create("#fafafa")
                            horizontalAlignment: HorizontalAlignment.Fill
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                horizontalAlignment: HorizontalAlignment.Left
                                topPadding: 35
                                bottomPadding: 5
                                leftPadding: 30

                                Label {
                                    text: qsTr("Description:")
                                    textStyle {
                                        fontSize: FontSize.Large
                                        color: Color.create("#555555")
                                    }
                                }
                            }

                            Container {
                                topPadding: 20
                                bottomPadding: 20
                                rightPadding: 20
                                leftPadding: 50

                                TextField {
                                }
                            }
                        }
                    } // end of expense description container

                    // "Email me a copy" container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: 40
                        rightPadding: 25
                        leftPadding: 25

                        Container {
                            background: Color.create("#fafafa")
                            horizontalAlignment: HorizontalAlignment.Fill

                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                horizontalAlignment: HorizontalAlignment.Left
                                topPadding: 25
                                bottomPadding: 5
                                leftPadding: 20

                                Label {
                                    text: qsTr("Email me a copy of this report")
                                    textStyle {
                                        fontSize: FontSize.Small
                                        color: Color.create("#555555")
                                    }
                                }
                            }

                            Container {
                                topPadding: 10
                                bottomPadding: 10
                                leftPadding: 50
                                ToggleButton {
                                    checked: true
                                }
                            }
                        }
                    } // end of expense tax amount container

                    // Attachement container
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: 40
                        rightPadding: 25
                        leftPadding: 25
                        visible: receiptAttached

                        Container {
                            background: Color.create("#fafafa")
                            horizontalAlignment: HorizontalAlignment.Fill

                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                horizontalAlignment: HorizontalAlignment.Left
                                topPadding: 20
                                bottomPadding: 20
                                leftPadding: 20
                                ImageView {
                                    imageSource: "asset:///images/attachments_thumbnail.png"
                                }
                            }

                            Container {
                                topPadding: 35
                                leftPadding: 20

                                Container {
                                    Label {
                                        text: qsTr("Attached:")
                                        textStyle {
                                            fontSize: FontSize.Small
                                            fontWeight: FontWeight.W600
                                        }
                                    }
                                }

                                Container {
                                    Label {
                                        text: qsTr("IMG_00000007.png")
                                        textStyle {
                                            color: Color.create("#555555")
                                        }
                                    }
                                }
                            }

                            Container {
                                leftPadding: 80

                                Container {
                                    background: Color.Red

                                    ImageView {
                                        imageSource: "asset:///images/button_remove_attachment.png"
                                    }

                                    onTouch: {
                                        if (event.isUp()) {
                                            receiptAttached = false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } // end of ScrollView
        } // end of content container
    } // end of main container

    function onReceiptIsAttached() {
        var reg = new RegExp('/data', 'g');
        filePath = "file://" + cppSubmitExpense.getHomeDir().replace(reg, '/app/native/assets/images/nfc_share_info.png');
        receiptAttached = true;
    }
}// end of Page
