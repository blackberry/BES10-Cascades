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

/**
 * Main navigation pane
 */
NavigationPane {
    id: navigationPane

    function loadMainPage() {
        var mainPage = mainPageDefinition.createObject();
        loginSheet.close()

        navigationPane.insert(0, mainPage);
        
        while ( navigationPane.count() > 1 ) {
            var pane = navigationPane.at(navigationPane.count() - 1);
            navigationPane.remove(pane);
        }
    }
    
    onCreationCompleted: {
        loginSheet.open();        
        Qt.app = app
    }
    onPopTransitionEnded: {
        page.destroy();
    }

    attachedObjects: [
        ComponentDefinition {
            id: mainPageDefinition
            MainPage {
            }
        },
        Sheet {
            id: loginSheet
            LoginPage {
                id: loginPage
                onLogin: {
                    loginPage.indicator.visible = false
                    loginPage.indicator.running = false
                    if(loginSheet.opened){
	                    app.loggedIn.disconnect(login)
	                    loadMainPage();
                    }
                }
            }
            onClosed: {
                loginPage.indicator.visible = false
                loginPage.indicator.running = false
                loginPage.myWebView.storage.clear();
            }
            function clearWebView(){
                console.log("Clear web view")
                loginPage.myWebView.storage.clearCookies()
            }
            function showLoginPage() {
                console.log("showLoginPage")
                loginSheet.open()
                loginPage.myWebView.storage.clearCookies()
                loginPage.myWebView.url = "https://login.salesforce.com/services/oauth2/authorize?response_type=token&display=touch&client_id=3MVG9A2kN3Bn17hsPYpFs3rM41gU2sM1ECpdJ.gaLZA8ti9nJ4980zNiDpAfrx63c5t_9H_icxsLKKwCx_gQZ&redirect_uri=sfdc://success"
            }
        },
        Sheet {
            id: helpSheet            
            Page {
                titleBar: TitleBar {
                    title: qsTr("Help")
                    dismissAction: ActionItem {
                        title: qsTr("Close")
                        onTriggered: {
                            helpSheet.close()
                        }
                    }
                }
                content: Container{
                    Label{
                        text: qsTr("TBD")
                    }
                }                
            }
            
        }
    ]

    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                helpSheet.open()
            }
        }
        // Specify the actions that should be included in the menu
        actions: [
            ActionItem {
                title: "Logout"
                imageSource: "asset:///images/ActionBar_Logout.png"
                onTriggered: {
                    //Clear the webview cookies
                    loginSheet.clearWebView()
                    
                    //Connect signal to update UI after logging out
                    app.finishLoggingOut.connect(loginSheet.showLoginPage)
                    
                    //Send logout request
                    app.clearAuth();
                    
                    //Pop all screens
                    for (var i = navigationPane.count(); i >= 0; i --) {
                        navigationPane.pop();
                    }
                }
            }
        ]
    }
}
