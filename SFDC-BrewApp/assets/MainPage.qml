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


// Navigation pane project template
import bb.cascades 1.0

Page {
    id: transitionPage
    property Container barsListView
    property Container barsMapView

    //function pushPage
    function getBarsView() {
        if (barsListView == null) {
            barsListView = barsDefinition.createObject();
            barsListView.navigationPane = navigationPane;
            contentView.add(barsListView);
        }
        return barsListView;
    }
    function showBarsView() {
        getMapsView().visible = false;
        getBarsView().visible = true;
    }
    
    function getMapsView() {
        if ( barsMapView == null ) {
            barsMapView = mapDefinition.createObject();
            barsMapView.navigationPane = navigationPane;
            contentView.add(barsMapView);
        }
        
        return barsMapView;
    }
    function showMapsView() {
        getBarsView().visible = false;
        getMapsView().visible = true;
    }

    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            content: Container {
                ImageView {
                    imageSource: "asset:///images/header.png"
                }
            }
        }
    }
    
    Container {/*
        Container {
            ImageView {
                imageSource: "asset:///images/header.png"
            }
        }*/
        SegmentedControl {
            options: [
                Option {
                    text: "Bars"
                },
                Option {
                    text: "Map"
                }
            ]
            onSelectedIndexChanged: {
                //selectedIndex
                if ( selectedIndex == 0 ) {
                    transitionPage.showBarsView();
                } else {
                    transitionPage.showMapsView();
                }
            }
        }
        
    	background: Color.Black
    	
    	Container {
    	    id: contentView
    	    
    	    layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        }

    }
    onCreationCompleted: {
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.DisplayPortrait;

        transitionPage.showBarsView();
        transitionPage.getMapsView();
    }

    attachedObjects: [
        ComponentDefinition {
            id: barsDefinition
            source: "BarsListView.qml"
        },
        ComponentDefinition {
            id: mapDefinition
            source: "BarsMapView.qml"
        }
    ]
}

