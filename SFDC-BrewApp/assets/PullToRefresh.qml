/* Copyright (c) 2012 Research In Motion Limited.
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

Container {
    id: refresh
    objectName: "pullToRefresh"

    layout: DockLayout {
    }

    signal update

    preferredHeight: 150
    preferredWidth: 768
    
    property int y : 0
    property bool updating : false
    property bool shouldAnimateReset : true
    
    property variant list
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left

        leftPadding: 40

        ActivityIndicator {
            id: activityIndicator
            preferredWidth: 50
            preferredHeight: 50
            visible: activityIndicator.running
        }

        ImageView {
            id: arrow
            imageSource: "asset:///images/pullToRefreshArrow.png"
            preferredWidth: 50
            preferredHeight: 50
            rotationZ: 180
        }

        Container {
            layout : DockLayout {

            }

            leftMargin: 20
            verticalAlignment: VerticalAlignment.Center

            Label {
                id:loading
                textStyle.color: Color.create("#f5f5f5")
                text: qsTr("Loading...")
                verticalAlignment: VerticalAlignment.Center
                opacity: 0.0
                textStyle {
                    fontSize: FontSize.PointValue
                    fontSizeValue: 7
                    fontWeight: FontWeight.W500
                }
                attachedObjects: [
                    ImplicitAnimationController {
                        propertyName: "opacity"
                        enabled: false
                    }
                ]
            }

            Label {
                id: pull
                textStyle.color: Color.create("#f5f5f5")
                text: qsTr("Pull down to update", "Text in pull-to-refresh view to update stores")
                verticalAlignment: VerticalAlignment.Center
                textStyle {
                    fontSize: FontSize.PointValue
                    fontSizeValue: 7
                    fontWeight: FontWeight.W500
                }
                attachedObjects: [
                    ImplicitAnimationController {
                        propertyName: "opacity"
                        enabled: false
                    }
                ]
            }
            Label {
                id: release
                textStyle.color: Color.create("#f5f5f5")
                text: qsTr("Release to update", "Text in pull-to-refresh view to update stories")
                verticalAlignment: VerticalAlignment.Center
                textStyle {
                    fontSize: FontSize.PointValue
                    fontSizeValue: 7
                    fontWeight: FontWeight.W500
                }
                attachedObjects: [
                    ImplicitAnimationController {
                        propertyName: "opacity"
                        enabled: false
                    }
                ]
            }
        }
    }
    
    function onListTouchEvent(event) {
        if (arrow.visible && event.touchType == TouchType.Up && refresh.y > 0) {
            pull.opacity = 0.0;
            release.opacity = 0.0
            loading.opacity = 1.0
            arrow.visible = false;
            activityIndicator.start();
            refresh.update();
        }
    }
    
    function reset() {
        y = -150;
        pull.opacity = 1.0;
        release.opacity = 0.0
        loading.opacity = 0.0
        arrow.visible = true;
        arrow.rotationZ = 180;
        activityIndicator.stop();
        
        var animate = refresh.shouldAnimateReset;
        refresh.shouldAnimateReset = true;
        
        return animate;
    }

    attachedObjects: [
        LayoutUpdateHandler {
            onLayoutFrameChanged: {
                refresh.y = layoutFrame.y;

                if (!arrow.visible) {
                    if (layoutFrame.y < 0) refresh.shouldAnimateReset = false;
                    return;
                }

                if (layoutFrame.y <= 0) {
                    arrow.rotationZ = 180;
                    pull.opacity = 1.0;
                    release.opacity = 0.0
                } else {
                    arrow.rotationZ = 360;
                    pull.opacity = 0.0;
                    release.opacity = 1.0;
                }
            }
        }
    ]
}
