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

Page {
    property string employeeName: ""
    property string employeePic: ""
    property string total: ""
    property url imagePath

    // Signals to notify the listeners that the report item has been approved/rejected
    signal submissionApproved()
    signal submissionRejected()

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
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.Black

        Container {

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
                            imageSource: employeePic
                        }
                    }

                    Container {
                        leftPadding: 15
                        bottomPadding: 5
                        verticalAlignment: VerticalAlignment.Bottom

                        Container {
                            Label {
                                text: employeeName
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
                                    text: "CAD "+ total
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

            Container {
                ScrollView {
                    scrollViewProperties {
                        scrollMode: ScrollMode.Both
                        minContentScale: 1.0
                        maxContentScale: 3.0
                        pinchToZoomEnabled: true
                        overScrollEffectMode: OverScrollEffectMode.OnPinch
                        initialScalingMethod: ScalingMethod.AspectFill
                    }

                    ImageView {
                        id: receiptImage
                        imageSource: imagePath
                        scalingMethod: ScalingMethod.None
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        preferredWidth: 850.0
                        preferredHeight: 1200.0
                    }
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
                        rejectSubmission()
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

    function approveSubmission() {
        // Notify the first submission in the list is approved
        submissionApproved();
    }

    function rejectSubmission() {
        // Notify the first submission in the list is rejected
        submissionRejected();
    }
}
