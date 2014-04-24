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
import bb.system.phone 1.0

Page {
    property variant index: 0 // the index of the selected item
    property variant itemData: "" // the list item info
    property alias datM: topLevelList.dataModel

    // Signals to notify the listeners that the report item has been approved/rejected
    signal submissionApproved(int index);
    signal submissionRejected(int index);

    actions: [
        ActionItem {
            title: "Approve"
            imageSource: "images/ic_approve.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                // Approves the submission
                approveSubmission();
            }
        },

        ActionItem {
            title: "Reject"
            imageSource: "asset:///images/ic_reject.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                // Rejects the submission
                rejectSubmission();
            }
        },

        ActionItem {
            title: "Phone"
            imageSource: "asset:///images/ic_phone.png"
            onTriggered: {
                // Invokes the phone app with dial pad
                phone.requestDialpad("1-111-111-1111");
            }
        },

        ActionItem {
            title: "Email"
            imageSource: "asset:///images/ic_email.png"
            onTriggered: {
                // Invokes the email app with pre-populated "To" field
                invokeEmailQuery.uri = "mailto:test@domain.com";
                invokeEmailQuery.updateQuery();
            }
        },

        InvokeActionItem {
            title: "BBM Chat"
            imageSource: "asset:///images/ic_bbm.png"
            query {
                mimeType: "text/plain"
                invokeTargetId: "sys.bbm.sharehandler"
                invokeActionId: "bb.action.SHARE"
            }
        }
    ]

    content: Container {
        // Main container wrapping everything ... holds 3 containers
        Container {
            background: Color.create("#444444")

            Container {
                layout: DockLayout {
                }

                Container {
                    ImageView {
                        imageSource: "asset:///images/banner_itemized_expenses.png"
                    }

                    onTouch: {
                        // On Macadamian logo touch event open the www.macadamian.com within the browser
                        if (event.localX > 620 && event.isUp()) {
                            invokeQuery.mimeType = "text/html"
                            invokeQuery.uri = "http://www.macadamian.com";
                            invokeQuery.updateQuery();
                        }
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
                }

                // Construct the Title Bar
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    Container {
                        ImageView {
                            imageSource: itemData.image
                        }
                    }

                    Container {
                        leftPadding: 15
                        bottomPadding: 5
                        verticalAlignment: VerticalAlignment.Bottom

                        Container {
                            Label {
                                text: itemData.firstName + ", " + itemData.lastName
                                textStyle {
                                    color: Color.White
                                }
                            }
                        }

                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                Label {
                                    text: "CAD "+ itemData.total
                                    textStyle {
                                        color: Color.create("#555555")
                                        fontSize: FontSize.Small
                                    }
                                }
                            }

                            Container {
                                leftPadding: 30
                                ImageView {
                                    imageSource: "asset:///images/bg_itemized_expenses.png"
                                }
                            }
                        }
                    }

                } // end of title bar container
            } // end of Container

            // First level is a ListView
            ListView {
                id: topLevelList
                dataModel: XmlDataModel {
                    source: "models/firstSubmissionExpenses.xml"
                }

                layout: GridListLayout {
                    columnCount: 1
                    headerMode: ListHeaderMode.Standard
                    cellAspectRatio: 1.0
                    spacingAfterHeader: 10
                    verticalCellSpacing: 0
                }

                listItemComponents: [
                    ListItemComponent {
                        type: "header"

                        Container {
                            Container {
                                background: Color.create("#444444")
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }

                                Container {
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 0.65
                                    }
                                    horizontalAlignment: HorizontalAlignment.Left
                                    verticalAlignment: VerticalAlignment.Center
                                    leftPadding: 10

                                    Label {
                                        text: ListItemData.title
                                        textStyle {
                                            fontSize: FontSize.Large
                                            color: Color.White
                                            fontWeight: FontWeight.Bold
                                        }
                                    }
                                }

                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.RightToLeft
                                    }

                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 0.35
                                    }

                                    horizontalAlignment: HorizontalAlignment.Right
                                    verticalAlignment: VerticalAlignment.Center
                                    rightPadding: 10

                                    Label {
                                        text: ListItemData.total
                                        textStyle {
                                            fontSize: FontSize.XLarge
                                            color: Color.create("#FFD686")
                                            fontWeight: FontWeight.Bold
                                        }
                                    }
                                }
                            }
                        }
                    },

                    ListItemComponent {
                        type: "item"
                        Container {

                            Container {
                                background: Color.create("#444444")

                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }

                                Container {
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 0.7
                                    }
                                    leftPadding: 20

                                    Label {
                                        text: "  " + ListItemData.text
                                        textStyle {
                                            fontSize: FontSize.Medium
                                            fontWeight: FontWeight.Bold
                                            color: Color.LightGray
                                        }
                                    }
                                }

                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.RightToLeft
                                    }

                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 0.3
                                    }

                                    rightPadding: 20

                                    Label {
                                        text: ListItemData.total
                                        textStyle {
                                            fontSize: FontSize.Medium
                                            fontWeight: FontWeight.Bold
                                            color: Color.LightGray
                                        }
                                    }
                                }
                            }

                            Container {
                                background: Color.create("#444444")
                                preferredHeight: 24
                                verticalAlignment: VerticalAlignment.Bottom
                                horizontalAlignment: HorizontalAlignment.Fill
                            }

                            Container {
                                background: Color.create(ListItemData.cellDividerColor) // "#111111"
                                preferredHeight: 2
                                verticalAlignment: VerticalAlignment.Bottom
                                horizontalAlignment: HorizontalAlignment.Fill
                            }
                        }
                    }
                ]

                onTriggered: {
                    console.log("ReportItem: onTriggered called.... ");

                    var expenseSnapShotPage = expenseSnapShot.createObject();
                    expenseSnapShotPage.employeeName = itemData.firstName + ", " + itemData.lastName;
                    expenseSnapShotPage.employeePic = itemData.image;

                    // Get receipt name and image based on the index of the selected item. Look at the firstSubmissionExpenses.xml
                    // and secondSubmissionExpenses.xml for deatils how to get the correct header
                    var headerItem;
                    if (1 == index) {
                        headerItem = indexPath < 2 ? dataModel.data([0]) : dataModel.data([2]);
                    } else if (2 == index) {
                        if (indexPath < 2) {
                            headerItem = dataModel.data([0]);
                        } else if (indexPath < 6) {
                            headerItem = dataModel.data([2]);
                        } else {
                            headerItem = dataModel.data([6]);
                        }
                    } else {
                        console.log("Unexpected value of index: " + index);
                    }

                    expenseSnapShotPage.total = headerItem.total;
                    expenseSnapShotPage.imagePath = headerItem.image;

                    // Push the content page to the navigation stack
                    navigationPane.push(expenseSnapShotPage);

                    // Connect to get notified when the second submission request is approved/rejected
                    expenseSnapShotPage.submissionApproved.connect(approveSubmission);
                    expenseSnapShotPage.submissionRejected.connect(rejectSubmission);
                }
            }
        }

        contextActions: [
            ActionSet {
                ActionItem {
                    title: "Approve"
                    imageSource: "asset:///images/ic_approve.png"
                    onTriggered: {
                        // Approves the submission
                        approveSubmission();
                    }
                }

                ActionItem {
                    title: "Reject"
                    imageSource: "asset:///images/ic_reject.png"
                    onTriggered: {
                        // Rejects the submission
                        rejectSubmission();
                    }
                }

                ActionItem {
                    title: "Phone"
                    imageSource: "asset:///images/ic_phone.png"
                    onTriggered: {
                        // Invokes the phone app with dial pad
                        phone.requestDialpad("1-111-111-1111");
                    }
                }

                ActionItem {
                    title: "Email"
                    imageSource: "asset:///images/ic_email.png"
                    onTriggered: {
                        // Invokes the email app with pre-populated "To" field
                        invokeEmailQuery.uri = "mailto:test@domain.com";
                        invokeEmailQuery.updateQuery();
                    }
                }

                InvokeActionItem {
                    title: "BBM Chat"
                    imageSource: "asset:///images/ic_bbm.png"
                    query {
                        mimeType: "text/plain"
                        invokeTargetId: "sys.bbm.sharehandler"
                        invokeActionId: "bb.action.SHARE"
                    }
                }
            }
        ]
    } // end of Container

    attachedObjects: [
        ComponentDefinition {
            id: expenseSnapShot
            source: "ExpenseSnapShot.qml"
        },

        Phone {
            id: phone
        }
    ]

    onIndexChanged: {
        index == 1 ? datM.setSource("models/firstSubmissionExpenses.xml") : datM.setSource("models/secondSubmissionExpenses.xml");
    }

    function approveSubmission() {
        // Notify the submission is approved
        submissionApproved(index);
    }

    function rejectSubmission() {
        // Notify the submission is rejected
        submissionRejected(index);
    }
} // end of Page
