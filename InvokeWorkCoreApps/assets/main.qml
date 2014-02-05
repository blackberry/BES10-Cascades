/*Copyright (c) 2013 BlackBerry Limited.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/


import bb.cascades 1.0

Page {
    
    content: Container {
        background: Color.Black
        
        Label {
            // Localized text with the dynamic translation and locale updates support
            horizontalAlignment: HorizontalAlignment.Center
            text: qsTr("Invocation Sample") + Retranslate.onLocaleOrLanguageChanged
            textStyle.base: SystemDefaults.TextStyles.BigText
            textStyle.color: Color.White
            textStyle.fontStyle: FontStyle.Default
            textStyle.fontSizeValue: 0.0
            textStyle.textAlign: TextAlign.Center
            textStyle.fontWeight: FontWeight.Bold
            multiline: true
            textStyle.fontSize: FontSize.Default
            topMargin: 0.0
        }
        
       
        Button {
            id: invokeEIM
            text: "Enterprise IM"
            objectName: "launchEIM"   
            horizontalAlignment: HorizontalAlignment.Center
            bottomMargin: 40.0            
            topMargin: 40.0
        }
        
        Button {
            id: invokeAdobe
            objectName: "invokeAdobe"           
            horizontalAlignment: HorizontalAlignment.Center
            text: "Adobe Reader"
            bottomMargin: 40.0            
        }
               
        
        Button {
            id: launchBrowser
            objectName: "launchBrowser"           
            horizontalAlignment: HorizontalAlignment.Center
            text: "Browser"
            bottomMargin: 40.0
        }
        
        Button {
            id: launchPhone
            objectName: "launchPhone"           
            horizontalAlignment: HorizontalAlignment.Center
            text: "Phone"
            bottomMargin: 40.0
        }
    }
}
