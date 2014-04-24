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

NavigationPane {
    id: navPane

    Page {
        actions: [

            ActionItem {
                title: qsTr("New Expense")
                imageSource: "asset:///images/ic_add.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    // Open the New Expense Page
                    var newExp = newExpense.createObject();
                    newExp.nav = navPane;
                    navPane.push(newExp);
                }
            }
        ]

        attachedObjects: [
            ComponentDefinition {
                id: newExpense
                source: "NewExpense.qml"
            }
        ]

        Container {
            layout: AbsoluteLayout {
            }
            background: Color.create("#333B46")

            // Adding banner
            Container {
                ImageView {
                    imageSource: "asset:///images/banner.png"
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
                    if (event.localX > 500 && event.isUp()) {
                        invokeQuery.mimeType = "text/html"
                        invokeQuery.uri = "http://www.macadamian.com";
                        invokeQuery.updateQuery();
                    }
                }
            } // end of Banner container

            // Adding Pending Expense reports
            Container {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 0
                    positionY: 180
                }

                topPadding: 30
                rightPadding: 15
                leftPadding: 15
                Container {
                    background: Color.create("#fafafa")

                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        topPadding: 5
                        bottomPadding: 5

                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            ImageView {
                                imageSource: "asset:///images/ic_clock.png"
                            }

                            Container {
                                topPadding: 10

                                Label {
                                    text: qsTr("Pending Approval")
                                    textStyle {
                                        fontSize: FontSize.Large
                                        color: Color.create("#555555")
                                    }
                                }
                            }
                        }
                    }

                    // First Pending Expense report
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        leftPadding: 20
                        topPadding: 10

                        Container {
                            background: Color.create("#00a8df")
                            ImageView {
                                imageSource: "asset:///images/expenseType_travel.png"
                            }
                        }

                        Container {
                            bottomPadding: 40
                            leftPadding: 20

                            Container {
                                Label {
                                    text: "Taxi ride to downtown"
                                    textStyle {
                                        fontWeight: FontWeight.W600
                                        color: Color.create("#262626")
                                    }
                                }
                            }

                            Container {
                                Label {
                                    text: "07/08/2013"
                                    textStyle {
                                        fontSize: FontSize.Default
                                        color: Color.create("#555555")
                                    }
                                }
                            }
                        }
                    } // end of first pending expense report container

                    Container {
                        background: Color.create("#b1b1b1")
                        preferredWidth: 768
                        preferredHeight: 3
                    }

                    // Second Pending Expense report
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        leftPadding: 20
                        topPadding: 20

                        Container {
                            background: Color.create("#df00ad")
                            ImageView {
                                imageSource: "asset:///images/expenseType_meal.png"
                            }
                        }

                        Container {
                            bottomPadding: 40
                            leftPadding: 20

                            Container {
                                Label {
                                    text: "Client supper with Scotia Bank"
                                    textStyle {
                                        fontWeight: FontWeight.W600
                                        color: Color.create("#262626")
                                    }
                                }
                            }

                            Container {
                                Label {
                                    text: "07/08/2013"
                                    textStyle {
                                        fontSize: FontSize.Default
                                        color: Color.create("#555555")
                                    }
                                }
                            }
                        }
                    } // end of second pending expense report container
                }
            } // end of pending expense reports container

            // Adding Prices for each expense report
            Container {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 480
                    positionY: 362
                }

                background: Color.create("#44932C")
                Container {
                    topPadding: 2
                    bottomPadding: 5
                    leftPadding: 3

                    Label {
                        text: "  CAD $50.40                   "
                        textStyle {
                            color: Color.White
                        }
                    }
                }
            }

            Container {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 480
                    positionY: 526
                }

                background: Color.create("#44932C")

                Container {
                    topPadding: 2
                    bottomPadding: 5
                    leftPadding: 3

                    Label {
                        text: "  CAD $230.60          "
                        textStyle {
                            color: Color.White
                        }
                    }
                }
            }

            // Adding Approved expenses
            Container {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 0
                    positionY: 620
                }

                topPadding: 30
                rightPadding: 15
                leftPadding: 15

                Container {
                    minWidth: 738
                    background: Color.create("#fafafa")

                    Container {
                        topPadding: 5

                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Container {
                                topPadding: 20
                                leftPadding: 20
                                ImageView {
                                    minWidth: 89
                                    imageSource: "asset:///images/display_jared_spool.png"
                                }
                            }

                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }

                                Container {
                                    topPadding: 10
                                    leftPadding: 20
                                    bottomPadding: 100

                                    Container {
                                        layout: StackLayout {
                                            orientation: LayoutOrientation.LeftToRight
                                        }

                                        Container {
                                            Label {
                                                text: "Jared Spool"
                                                textStyle {
                                                    fontWeight: FontWeight.W600
                                                }
                                            }
                                        }

                                        Container {
                                            topPadding: 10
                                            rightPadding: 10
                                            leftPadding: 300

                                            layout: StackLayout {
                                                orientation: LayoutOrientation.LeftToRight
                                            }

                                            Container {
                                                topPadding: 10
                                                ImageView {
                                                    imageSource: "asset:///images/ic_clock_small.png"
                                                }
                                            }

                                            Container {
                                                Label {
                                                    text: "1h"
                                                    textStyle {
                                                        fontSize: FontSize.Small
                                                        color: Color.create("#555555")
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Container {
                                        layout: StackLayout {
                                            orientation: LayoutOrientation.LeftToRight
                                        }

                                        Container {
                                            Label {
                                                text: qsTr("Approved:")
                                                textStyle {
                                                    fontSize: FontSize.XSmall
                                                    color: Color.create("#44932C")
                                                }
                                            }
                                        }

                                        Container {
                                            Label {
                                                text: qsTr(" Blackberry purchase for Creativity")
                                                textStyle {
                                                    fontSize: FontSize.XSmall
                                                    color: Color.create("#555555")
                                                }
                                            }
                                        }
                                    }

                                    Container {
                                        Label {
                                            text: qsTr("Advertisement Project")
                                            multiline: true
                                            textStyle {
                                                fontSize: FontSize.XSmall
                                                color: Color.create("#555555")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } // end of approved expense container

            // Adding prices for approved expenses
            Container {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 480
                    positionY: 775
                }

                background: Color.create("#44932C")

                Container {
                    topPadding: 2
                    bottomPadding: 5
                    leftPadding: 3

                    Label {
                        text: "  CAD $350.40                         "
                        textStyle {
                            color: Color.White
                        }
                    }
                }
            }
        } // end of main container
    } // end of page
} // end of Navigation Pane