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
    id: self
    
    // state
    property bool isDown: false
    property bool beganWithPress: false
    
    signal triggered;
    
    onTouch: {
        if ( event.isDown() ) {
            self.isDown = true;
            self.beganWithPress = true;
        } else if ( event.isUp() ) {
            self.isDown = false;
            self.triggered();
        }
    }
    onTouchEnter: {
//      if ( self.beganWithPress == true ) {
//          self.isDown = true;
//      }
    }
    onTouchExit: {
        self.isDown = false;
    }
    
    onIsDownChanged: {
        if ( self.isDown == true ) {
            self.scaleDown();
        } else {
            self.translationX = 0;
            self.translationY = 0;
            self.scaleUp();
        }
    }
    
    animations: [
        ScaleTransition {
            id: scalePressDown
            fromX: 1.0
            toX: 0.95
            fromY: 1.0
            toY: 0.95
            duration: 125
        },
        ScaleTransition {
            id: scalePressUp
            fromX: 0.95
            toX: 1.0
            fromY: 0.95
            toY: 1.0
            duration: 125
        }
    ]
    
    function scaleDown() {
        scalePressDown.play();
    }
    function scaleUp() {
        scalePressUp.play();
    }
}