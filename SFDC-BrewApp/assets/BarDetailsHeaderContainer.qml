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
import bb.system 1.0

Container {
    property variant item: null
    property variant myapp: null

    background: woodBG.imagePaint
    maxHeight: 366
    minHeight: 366
    horizontalAlignment: HorizontalAlignment.Fill
    layoutProperties: StackLayoutProperties {
        spaceQuota: 1.0
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        leftPadding: 24
        topPadding: 24
        rightPadding: 24

        Container {
            maxWidth: 188
            maxHeight: 188
            ImageView {
                id: imgView
                imageSource: item != null ? "asset:///images/bars/" + item.__Account__r.AccountNumber + ".png" : ''
                horizontalAlignment: HorizontalAlignment.Center
            }
        }

        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }
            topMargin: 24
            leftMargin: 24
            Container {
                layout: AbsoluteLayout {
                }
                Label {
                    layoutProperties: AbsoluteLayoutProperties {
                        positionY: 0
                    }
                    text: item != null ? item.__Account__r.__Address__c : ''
                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.White
                    }
                }
                Label {
                    layoutProperties: AbsoluteLayoutProperties {
                        positionY: 52
                    }
                    text: item != null ? item.__Account__r.__City__c : ''
                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.create("#beaa79")
                    }
                }
                Label {
                    layoutProperties: AbsoluteLayoutProperties {
                        positionY: 104
                    }
                    text: item != null ? item.__Account__r.zipcode__c : ''
                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.create("#beaa79")
                    }
                }
                TouchContainer {
                    layoutProperties: AbsoluteLayoutProperties {
                        positionY: 156
                    }
                    Label {
                        id: contactPhone
                        text: item != null ? myapp.contactMap.Phone : ''
                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.create("#beaa79")
                        }
                    }
                    onTriggered: {
                        if (myapp.contactMap.Phone) app.launchPhone(myapp.contactMap.Phone);
                        //dialNumber.initiateCall(item["__phone__c"]);
                        else myapp.showToast("Contact does not have a phone")
                    }
                }
            }
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        topPadding: 24
        leftPadding: 24
        Label {
            text: "Contact"
            textStyle {
                base: SystemDefaults.TextStyles.TitleText
                color: Color.create("#beaa79")
                fontSizeValue: 10
                fontSize: FontSize.PointValue
            }
        }
        TouchContainer {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: item != null ? myapp.contactMap.Name : ''
                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.White
                    fontSizeValue: 10
                    fontSize: FontSize.PointValue
                }
            }
            ImageView {
                visible: {
                    if (item != null && myapp.contactMap.bbmpin__c) true;
                    else false
                }
                imageSource: "asset:///images/ShareBBM.png"
            }
            onTriggered: {
                if (myapp.contactMap.bbmpin__c) myapp.launchBBMChat(myapp.contactMap.bbmpin__c);
                else if (myapp.contactMap.Phone) dialNumber.initiateCall(myapp.contactMap.Phone);
                else myapp.showToast("Unable to reach the contact")

            }
        }
    }

    attachedObjects: [
        ImagePaintDefinition {
            id: woodBG
            repeatPattern: RepeatPattern.Fill
            imageSource: "asset:///images/wood_background.png"
        }
    /*,
     * Phone {
     * id: dialNumber
     * }*/
    ]
}
