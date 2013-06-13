/****************************************************************************
 * Copyright 2012 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/
/*
* This is custom Header list Item for ECL groups
*
*****************************************************************************/

import bb.cascades 1.0

Container {
    id: headerListitem
    property string title
    property bool isExpand: true
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    Container {
        layout: DockLayout {
        }
        ImageView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            imageSource: "asset:///images/header.png"
        }
        Container {
            id: innerContainer
            layout: DockLayout {
            }
            verticalAlignment: VerticalAlignment.Center
            Label {
                bottomMargin: 10
                text: headerListitem.title
                preferredWidth: innerContainer.maxWidth
                horizontalAlignment: HorizontalAlignment.Left
                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                }
            }
            Container {
                rightPadding: 20
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Right
                ImageView {
                    id: imageView
                    imageSource: "images/up.png"
                    animations: [
                        RotateTransition {
                            id: rotateAnimation
                            duration: 100
                        }
                    ]
                }
            }
        }
    }
    onIsExpandChanged: {
        console.log("isExpandChanged ", isExpand);
        rotateAnimation.toAngleZ = isExpand ? 0 : 180
        rotateAnimation.play();
    }
}
