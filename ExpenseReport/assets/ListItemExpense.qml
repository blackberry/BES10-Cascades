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

// Container is an item in the list
Container {
    // Second level container {0}
    // Creates a custom divider

    Container {
        layout: DockLayout {
        }
        background: Color.Black
        preferredHeight: 1
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
    }

    // Second level container {1}
    Container {
        opacity: parseFloat(ListItemData.opacity)
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // Third level container {1} (includes two containers)
        Container {
            preferredWidth: 30
            preferredHeight: 218
            background: Color.create(ListItemData.sideContainerColor)
            opacity: parseFloat(ListItemData.opacity)
            layout: DockLayout {
            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }

        Container {
            opacity: parseFloat(ListItemData.opacity)
            layout: AbsoluteLayout {
            }
            // ImageView containing the background image

            ImageView {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 0
                    positionY: 0
                }
                imageSource: ListItemData.imageBack // "asset:///images/CellBackr.png"
            }

            ImageView {
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 15
                    positionY: 15
                }
                imageSource: ListItemData.image
            }

            Label {
                text: ListItemData.fullName
                textStyle {
                    color: Color.White
                    fontSize: FontSize.Large
                    fontWeight: FontWeight.Bold
                }
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 180
                    positionY: 10
                }
            }

            Label {
                text: ListItemData.total
                textStyle {
                    color: Color.create("#FFD686")
                    fontSize: FontSize.XLarge
                    fontWeight: FontWeight.Bold
                }
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 180
                    positionY: 53
                }
            }

            Label {
                text: ListItemData.expenseGroup
                textStyle {
                    color: Color.White
                    fontSize: FontSize.PointValue
                    fontSizeValue: 9
                }
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 180
                    positionY: 120
                }
            }

            Label {
                text: ListItemData.projectStatus
                textStyle {
                    color: Color.White
                    fontSize: FontSize.PointValue
                    fontSizeValue: 7
                }
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 378
                    positionY: 200
                }
            }

            Label {
                text: ListItemData.projectStatusDate
                textStyle {
                    color: Color.White
                    fontSize: FontSize.PointValue
                    fontSizeValue: 6
                }
                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 560
                    positionY: 204
                }
            }
        }
    }

    // Second level container {2}
    // Creates a custom divider
    Container {
        layout: DockLayout {
        }
        background: Color.Black
        preferredHeight: 1
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
