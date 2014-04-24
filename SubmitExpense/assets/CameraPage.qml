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
import bb.multimedia 1.0
import bb.cascades.multimedia 1.0
import bb.system 1.0

Page {
    property bool triggered: false

    onTriggeredChanged: {
        // Set settings
        camera.getSettings(settings);
        settings.flashMode = CameraFlashMode.Auto;
        camera.applySettings(settings);

        // Start the Camera
        camera.open(CameraUnit.Rear);
    }

    // The root container.
    content: Container {

        // The Camera control.
        Camera {
            id: camera
            property bool photoBeingTaken;

            attachedObjects: [
                // Required to play the shutter sound.
                SystemSound {
                    id: shutterSound
                    sound: SystemSound.CameraShutterEvent
                },

                 CameraSettings {
                    id: settings
                },

                SystemToast {
                    id: toastMessage
                }
            ]

            onTouch: {
                if (photoBeingTaken == false) {
                    photoBeingTaken = true;
                    // Take a photo, and automatically
                    // save it to the file system.
                    camera.capturePhoto();
                }
            }

            onCameraOpened: {
                // When the camera is open, start the viewfinder.
                console.log("Camera started.");
                camera.startViewfinder();
            }

            onViewfinderStarted: {
                console.log("Viewfinder started.");
                photoBeingTaken = false;
            }

            onShutterFired: {
                shutterSound.play();
            }

            onPhotoSaved: {
                photoBeingTaken = false;
                toastMessage.body = qsTr("The photo is captured.");
                toastMessage.show();
                console.log("Photo URI: " + fileName);
            }
        } // End of Camera control.
    } // End of Container
} // End of Page