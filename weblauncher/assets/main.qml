/* Copyright (c) 2012, 2013  BlackBerry Limited.
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

NavigationPane {
    id: navigationPane
    property variant imageCenter
    property bool asCard: true
    property bool appUsed: false

    Menu.definition: MenuDefinition {
        // Add a Help action
        helpAction: HelpActionItem {
            onTriggered: {
                myHelpToast.show();
            }
        }
        
        settingsAction: SettingsActionItem {
            
            title: "Settings"
            imageSource: "asset:///images/settings.png"
            onTriggered: {
                navigationPane.push(settingsPage.createObject());
            }    
        }
    }

	onCreationCompleted: {
     	
     	if (app.getValueFor("asCard", "false") == "false"){
     	    navigationPane.asCard = false;
     	} else {
            navigationPane.asCard = true;
        }
     	
     
     }

    Page {
    Container {
            background: back.imagePaint
            attachedObjects: [
                ImagePaintDefinition {
                    id: back
                    repeatPattern: RepeatPattern.Fill
                    imageSource: "asset:///images/bg.png"
                }
            ]
            layout: DockLayout {
            }
            Carousel {
                id: carousel
            }
            SwipeHandler {
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                property int dragScrollSpeed: 1200 // Lower value gives higher scroll speed
                property int momentumScrollSpeed: 300 // Lower value gives higher scroll speed
                onDragOffsetChanged: {
                    carousel.angle = (dragOffset / dragScrollSpeed) * 180
                }
                onMomentumOffsetChanged: {
                    carousel.angle = (momentumOffset / momentumScrollSpeed) * 180
                }
                onScrollingStart: {
                    carousel.baseAngle += carousel.angle;
                    carousel.angle = 0;
                }
                onDragScrollingEnd: {
                carousel.releaseSpeed = speed;
                carousel.momentumSpeed = 0;
                carousel.baseAngle += carousel.angle;
                carousel.angle = 0;
                carousel.snapToItem();
                }
                onMomentumScrollingEnd: {
                carousel.baseAngle += carousel.angle;
                carousel.angle = 0;
                carousel.releaseSpeed = endSpeed
                carousel.momentumSpeed = endSpeed
                carousel.snapToItem();
                }
            }
        }

        attachedObjects: [
            SystemToast {
                id: myHelpToast
                property bool state
                body: "FAQs: \r\rBroken links? \r\rUse + icon to notify:\r SETEMAIL@SETDOMAIN.com \r\r Site Renders Funny?\r\r Try switching invoke method in Settings Page."
                
            },
            ComponentDefinition {
                id: settingsPage
                source: "SettingsPage.qml"
            }
        ]
            
    }
}