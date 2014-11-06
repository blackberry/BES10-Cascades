// Default empty project template
import bb.cascades 1.0
import bb.besutil 1.0

// creates one page with a label
Page {
    content:
    Container {
        layout: DockLayout {}
        Label {
            text: qsTr("Hello BESSafeTcp")
            textStyle.base: SystemDefaults.TextStyles.BigText
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
	    Container {
            verticalAlignment: VerticalAlignment.Top
	        horizontalAlignment: HorizontalAlignment.Fill
	        leftPadding: 50
	        rightPadding: 50
	        topPadding: 20
	        bottomPadding: 50
	        
	        layout: StackLayout {
	            orientation: LayoutOrientation.TopToBottom
	        }
	    
	        // test Qt ssl button.
	        Button {
	            id: qtSslButton
	            text: "Test Qt SSL Sockets"
	            topMargin: 20
	            rightMargin: 200
	            preferredWidth: 250
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	
	            // Change the button text on click and hide the fruit button.
	            onClicked: {
					besConnect.testQtSslSockets();
	            }
	        }
	
	        // test Qt TCP button.
	        Button {
	            id: qtTcpButton
	            text: "Test Qt Tcp Sockets"
	            topMargin: 20
	            preferredWidth: 250
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	
	            // Change the button text on click and hide the fruit button.
	            onClicked: {
					besConnect.testQtTcpSockets();
	            }
	        }
            
            // test OpenSSL SSL button.
            Button {
                id: opensslSslButton
                text: "Test SSL Sockets"
                topMargin: 20
                rightMargin: 200
                preferredWidth: 250
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                // Change the button text on click and hide the fruit button.
                onClicked: {
                    besConnect.testOpenSSLSslSockets();
                }
            }
            
            // test BSD Tcp button.
            Button {
                id: bsdTcpButton
                text: "Test Tcp Sockets"
                topMargin: 20
                preferredWidth: 250
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                // Change the button text on click and hide the fruit button.
                onClicked: {
                    besConnect.testBSDTcpSockets();
                }
            }
/*            
            // test Curl OpenSSL button.
            Button {
                id: curlOpensslButton
                text: "Test SSL Sockets with CURL HTTP tunnel"
                topMargin: 20
                rightMargin: 200
                preferredWidth: 250
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                // Change the button text on click and hide the fruit button.
                onClicked: {
                    besConnect.testCurlProxyOpenSSLSockets();
                }
            }
*/            
            // test BSD Tcp button.
            Button {
                id: curlButton
                text: "Test CURL Connectons"
                topMargin: 20
                preferredWidth: 250
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                // Change the button text on click and hide the fruit button.
                onClicked: {
                    besConnect.testCurlConnections();
                }
            }
	    }
        TextArea {
            objectName: "console"
            text: qsTr("")
            textStyle.base: SystemDefaults.TextStyles.SmallText
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Fill
        }
    }
	
    attachedObjects: [
        BESConnect {
            id: besConnect
        }
    ]
}
