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
    property real height: 112.0
    property alias titleLabel: itemTitleLabel
    property alias subtitleLabel: itemSubtitleLabel
    property alias accessoryImage: accessoryImageView.imageSource
    property alias percentageLabel: percentageLabel
    property alias imageView: imageView

    id: itemContainer
    preferredHeight: height

    ImageView {
        imageSource: "asset:///images/divider.png"
        maxHeight: 2
        minHeight: 2
        preferredHeight: 2

        layoutProperties: StackLayoutProperties {
            spaceQuota: 1.0
        }
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        preferredHeight: height - 2

        ImageView {
            id: imageView
            maxWidth: 155.0
            preferredHeight: height - 3
        }
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }
            
            layout: DockLayout {
                
            }
            verticalAlignment: VerticalAlignment.Center

            Container {
                layout: AbsoluteLayout {
                }
                Label {
	                id: itemTitleLabel
	                textStyle.color: Color.White
	                textStyle.fontSizeValue: 9
	                textStyle.fontSize: FontSize.PointValue
	                layoutProperties: AbsoluteLayoutProperties {
	                    positionX: 3
	                }
	            }
	            Label {
	                id: itemSubtitleLabel
	                visible: itemSubtitleLabel.text != null
                    textStyle.color: Color.create("#717854")
	                textStyle.fontSizeValue: 7
	                textStyle.fontSize: FontSize.PointValue
	                layoutProperties: AbsoluteLayoutProperties {
	                    positionY: 46
	                    positionX: 3
	                }
	            }
            }
        }
        Container {
            maxHeight: 111.0
            minHeight: 111.0
            preferredHeight: 111.0
            layout: DockLayout {
            }
            Label {
                id: percentageLabel
                verticalAlignment: VerticalAlignment.Center
            }
        }
        Container {
            maxHeight: 111.0
            minHeight: 111.0
            preferredHeight: 111.0
            layout: DockLayout {}
            ImageView {
                id: accessoryImageView
                //imageSource: 
                verticalAlignment: VerticalAlignment.Center

            }
        }

    }

    function setHighlight(highlighted) {
        if (highlighted) {
            itemContainer.background = Color.create("#454b32");
        } else {
            itemContainer.background = Color.Transparent;
        }
    }

    // Connect the onActivedChanged signal to the highlight function
    ListItem.onActivationChanged: {
        setHighlight(ListItem.active);
    }

    // Connect the onSelectedChanged signal to the highlight function
    ListItem.onSelectionChanged: {
        setHighlight(ListItem.selected);
    }
}