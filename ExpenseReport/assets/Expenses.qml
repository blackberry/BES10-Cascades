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
import bb.system 1.0

NavigationPane {
    id: navigationPane
    property alias datM: topLevelList.dataModel
    property bool firstSubmissionApproved // true for "Approved", false for "Rejected"
    property bool secondSubmissionApproved // true for "Approved", false for "Rejected"
    property bool firstSubmissionPending: true // indicates if the first submission is pending
    property bool secondSubmissionPending: true // indicates if the second submission is pending

    Page {

        actions: [
            ActionItem {
                title: "Approve All"
                imageSource: "images/ic_approve_all.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    // Approves all submissions
                    approveAllSubmissions();
                }
            },

            ActionItem {
                title: "Reject All"
                imageSource: "asset:///images/ic_reject.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    // Rejects all submissions
                    rejectAllSubmissions();
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

        // Main container wrapping everything
        Container {
            background: Color.create(0.1, 0.1, 0.1)

            Container {
                background: Color.DarkGray
                horizontalAlignment: HorizontalAlignment.Fill
                Container {

                    // Adding banner
                    Container {
                        ImageView {
                            imageSource: "asset:///images/banner_expenses_report.png"
                        }

                        attachedObjects: [
                            Invocation {
                                query: InvokeQuery {
                                    id: invokeQuery
                                    mimeType: "text/html"
                                    invokeTargetId: "sys.browser"
                                }

                                onArmed: {
                                    // This gets called first time when the query is created and no uri is set
                                    if (invokeQuery.uri != "") {
                                        trigger("bb.action.OPEN");
                                    }
                                }
                            }
                        ]

                        onTouch: {
                            // On Macadamian logo touch event open the www.macadamian.com within the browser
                            if (event.localX > 500 && event.isUp()) {
                                invokeQuery.mimeType = "text/html"
                                invokeQuery.uri = "http://www.macadamian.com";
                                invokeQuery.updateQuery();
                            }
                        }
                    } // end of Banner container
                }
            }

            // First level is a ListView
            ListView {
                id: topLevelList
                dataModel: XmlDataModel {
                    source: "models/expensesReportsInitialModel.xml"
                }

                layout: GridListLayout {
                    columnCount: 1
                    headerMode: ListHeaderMode.Standard
                    spacingAfterHeader: 0
                }

                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        ListItemExpense {
                            id: listItemExpenseComponent
                            contextActions: [
                                ActionSet {

                                    ActionItem {
                                        title: qsTr("Approve")
                                        imageSource: "asset:///images/ic_approve.png"
                                        onTriggered: {
                                            // Approves the selected submission
                                            listItemExpenseComponent.ListItem.view.approveSelectedSubmission(listItemExpenseComponent.ListItem.indexInSection);
                                        }
                                    }

                                    ActionItem {
                                        title: qsTr("Reject")
                                        imageSource: "asset:///images/ic_reject.png"
                                        onTriggered: {
                                            // Rejects the selected submissions
                                            listItemExpenseComponent.ListItem.view.rejectSelectedSubmission(listItemExpenseComponent.ListItem.indexInSection);
                                        }
                                    }

                                    ActionItem {
                                        title: qsTr("Phone")
                                        imageSource: "asset:///images/ic_phone.png"
                                        onTriggered: {
                                            // Invokes the phone app with dial pad
                                            phone.requestDialpad("1-111-111-1111");
                                        }
                                    }

                                    ActionItem {
                                        title: qsTr("Email")
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
                        }
                    }
                ]

                onTriggered: {
                    var reportDetailPage = reportItemDefinition.createObject();
                    reportDetailPage.itemData = dataModel.data(indexPath);
                    reportDetailPage.index = indexPath;

                    // Push the content page to the navigation stack
                    navigationPane.push(reportDetailPage);

                    // Connect to get notified when the second submission request is approved/rejected
                    reportDetailPage.submissionApproved.connect(reportItemApproved);
                    reportDetailPage.submissionRejected.connect(reportItemRejected);
                }

                function approveSelectedSubmission(index) {
                    reportItemApproved(index);
                }

                function rejectSelectedSubmission(index) {
                    reportItemRejected(index);
                }
            }
        }

        attachedObjects: [
            ComponentDefinition {
                id: reportItemDefinition
                source: "ReportItem.qml"
            }
        ]
    }

    attachedObjects: [
        Phone {
            id: phone
        },

        Invocation {
            query: InvokeQuery {
                id: invokeEmailQuery
                invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            }
            onArmed: {
                trigger("bb.action.SENDEMAIL");
            }
        },

        SystemToast {
            id: toastMessage
        }
    ]

    onPopTransitionEnded: {
        page.destroy();
        Application.menuEnabled = true;
    }

    function approveAllSubmissions() {
        console.log("Approving all submissions...");
        datM.setSource("models/allSubmissionsApproved.xml");
        firstSubmissionApproved = true;
        secondSubmissionApproved = true;
        firstSubmissionPending = false;
        secondSubmissionPending = false;
        toastMessage.body = qsTr("You approved all expense reports.");
        toastMessage.show();
    }

    function rejectAllSubmissions() {
        console.log("Rejecting all submisstions...");
        datM.setSource("models/allSubmissionsRejected.xml");
        firstSubmissionApproved = false;
        secondSubmissionApproved = false;
        firstSubmissionPending = false;
        secondSubmissionPending = false;
        toastMessage.body = qsTr("You rejected all expense reports.");
        toastMessage.show();
    }

    function reportItemApproved(index) {
        console.log("Approved submission with index " + index);
        if (1 == index) {
            firstSubmissionPending = false;
            firstSubmissionApproved = true;
            if (secondSubmissionPending) {
                datM.setSource("models/firstApprovedSecondPending.xml");
            } else if (secondSubmissionApproved) {
                datM.setSource("models/allSubmissionsApproved.xml");
            } else {
                datM.setSource("models/firstApprovedSecondRejected.xml");
            }
        } else if (2 == index) {
            secondSubmissionPending = false;
            secondSubmissionApproved = true;
            if (firstSubmissionPending) {
                datM.setSource("models/firstPendingSecondApproved.xml");
            } else if (firstSubmissionApproved) {
                datM.setSource("models/allSubmissionsApproved.xml");
            } else {
                datM.setSource("models/firstRejectedSecondApproved.xml");
            }
        } else {
            console.log("Invalid index is provided for approved submission: " + index);
        }

        toastMessage.body = qsTr("You approved this expense report.");
        toastMessage.show();
    }

    function reportItemRejected(index) {
        console.log("Rejected submission with index " + index);
        if (1 == index) {
            firstSubmissionPending = false;
            firstSubmissionApproved = false;
            if (secondSubmissionPending) {
                datM.setSource("models/firstRejectedSecondPending.xml");
            } else if (secondSubmissionApproved) {
                datM.setSource("models/firstRejectedSecondApproved.xml");
            } else {
                datM.setSource("models/allSubmissionsRejected.xml");
            }
        } else if (2 == index) {
            secondSubmissionPending = false;
            secondSubmissionApproved = false;
            if (firstSubmissionPending) {
                datM.setSource("models/firstPendingSecondRejected.xml");
            } else if (firstSubmissionApproved) {
                datM.setSource("models/firstApprovedSecondRejected.xml");
            } else {
                datM.setSource("models/allSubmissionsRejected.xml");
            }
        } else {
            console.log("Invalid index is provided for rejected submission: " + index);
        }

        toastMessage.body = qsTr("You rejected this expense report.");
        toastMessage.show();
    }
}
