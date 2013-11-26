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

Page {

    Container {
        background: Color.Black
        opacity: 1.0

        layout: StackLayout {

        }

        Container {
            id: settingsContainer
            
            Label {
                text: "If any site displays incorrectly, try switching invoke method:"
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W500
                multiline: true
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Center

            }
            
            Container {
                
	            RadioGroup {
	                id: invokeSettings
	
	                topMargin: 25.0
	                leftMargin: 50.0
	
	                Option {
	                    id: withCard
	                    text: "Invoke as Card"
	                    value: "asCard"
	                   // selected: true
	                }
	                Option {
	                    id: withBrowser
	                    text: "Invoke in Browser"
	                    value: "asBrowser"
	                }
	                onSelectedIndexChanged: {
	                    console.debug(invokeSettings.selectedValue)
	                    if (invokeSettings.selectedValue == "asCard") {
	                        navigationPane.asCard = true;
	                        app.saveValueFor("asCard", "true");
	
	                    } else {
	                        navigationPane.asCard = false;
	                        app.saveValueFor("asCard", "false");
	                    }
	
	                }
	                verticalAlignment: VerticalAlignment.Center
	                horizontalAlignment: HorizontalAlignment.Center
	                dividersVisible: true
	            } //end radiogroup
	        }

            Label {
                text: "For any questions contact:\r SETEMAIL@SETDOMAIN.com"
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W500
                multiline: true
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 75.0

            }

        }

    }
    
    onCreationCompleted: {
        if (navigationPane.asCard){
            withCard.selected = true;
        } else {
            withBrowser.selected = true;
        }   
    }
    
    
}
