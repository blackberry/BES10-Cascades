/* Copyright (c) 2013 BlackBerry Limited.
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
import ".."

Sheet {
    id: root
    
    property variant claimData;
    signal updateClaim(variant d);
    
	Page {
	    titleBar: TitleBar {
	        title: qsTr("Edit Claim")
	         dismissAction: ActionItem {
	             title: "Cancel"
	             onTriggered: {
	                 root.close();
	             }
	         }
	         acceptAction: ActionItem {
              title: "Save"
              onTriggered: {
                  console.log("Updating..")
                  var data = root.claimData;
                  data.ClaimDate = Qt.formatDate(claimDate.value,'yyyy-MM-dd');
                  data.PolicyNo = policyNo.text;
                  data.Insurer = insurer.text;
                  data.InsuredUntil = Qt.formatDate(insureUntil.value, 'yyyy-MM-dd');
                  data.Vehicle = autoYear.selectedOption.text + ", " + autoMake.selectedOption.text + ", " + autoModel.selectedOption.text
                  data.SerialNo = serialNo.text;
                  data.LicensePlateNo = licensePlate.text;
                  data.LossDamageDate = Qt.formatDate(lossDate.value, 'yyyy-MM-dd');
                  data.Location = location.text;
                  data.PoliceUnit = policeUnit.text;
                  data.UnitNotifyDate = Qt.formatDate(unitNotifyDate.value, 'yyyy-MM-dd');
                  root.claimData = data;
                  updateClaim(data);
                  root.close();
              }
          }
         }
	    ScrollView {
	        scrollViewProperties {
	            scrollMode: ScrollMode.Vertical
	        }
            Container {
                topPadding: 20
                bottomPadding: 20
                leftPadding: 20
                rightPadding: 20
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    DateTimePicker {
                        id: claimDate 
                        title: qsTr("Claim Date: ")
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Label {
                        text: qsTr("Insurer: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: insurer  
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Policy #: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: policyNo   
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    DateTimePicker {
                        id: insureUntil 
                        title: qsTr("Insured Until: ")
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        //orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Auto Year/Make/Model: ")
                    }
                    Container {
                        topPadding: 10
                        layout: StackLayout {
                            //orientation: LayoutOrientation.LeftToRight
                        }
                        DropDown {
                            id: autoYear
                            title: "Year"
                            
                            options: [
                                Option {
                                    text: "1984"
                                },
                                Option {
                                    text: "1985"
                                },
                                Option {
                                    text: "1986"
                                },
                                Option {
                                    text: "1987"
                                },
                                Option {
                                    text: "1988"
                                },
                                Option {
                                    text: "1989"
                                },
                                Option {
                                    text: "1990"
                                },
                                Option {
                                    text: "1991"
                                },
                                Option {
                                    text: "1992"
                                },
                                Option {
                                    text: "1993"
                                },
                                Option {
                                    text: "1994"
                                },
                                Option {
                                    text: "1995"
                                },
                                Option {
                                    text: "1996"
                                },
                                Option {
                                    text: "1997"
                                },
                                Option {
                                    text: "1998"
                                },
                                Option {
                                    text: "1999"
                                },
                                Option {
                                    text: "2000"
                                },
                                Option {
                                    text: "2001"
                                },
                                Option {
                                    text: "2002"
                                },
                                Option {
                                    text: "2003"
                                },
                                Option {
                                    text: "2004"
                                },
                                Option {
                                    text: "2005"
                                },
                                Option {
                                    text: "2006"
                                },
                                Option {
                                    text: "2007"
                                },
                                Option {
                                    text: "2008"
                                },
                                Option {
                                    text: "2009"
                                },
                                Option {
                                    text: "2010"
                                },
                                Option {
                                    text: "2011"
                                },
                                Option {
                                    text: "2012"
                                },
                                Option {
                                    text: "2013"
                                }
                            ]
                        } 
                        DropDown {
                            id: autoMake
                            title: "Make"
                            
                            options: [
                                Option {
                                    text: "BMW"
                                    value: text
                                },
                                Option {
                                    text: "Chevrolet"
                                    value: text
                                },
                                Option {
                                    text: "Dodge"
                                    value: text
                                },
                                Option {
                                    text: "Ford"
                                    value: text
                                },
                                Option {
                                    text: "GMC"
                                    value: text
                                },
                                Option {
                                    text: "Honda"
                                    value: text
                                },
                                Option {
                                    text: "Lexus"
                                    value: text
                                },
                                Option {
                                    text: "Mazda"
                                    value: text
                                },
                                Option {
                                    text: "Nissan"
                                    value: text
                                },
                                Option {
                                    text: "Peugeot"
                                    value: text
                                },
                                Option {
                                    text: "Subaru"
                                    value: text
                                },
                                Option {
                                    text: "Toyota"
                                    value: text
                                }
                            ]
                        }   
                        DropDown {
                            id: autoModel
                            title: "Model"
                            
                            options: [
                                Option {
                                    text: "3"
                                },
                                Option {
                                    text: "405"
                                },
                                Option {
                                    text: "Altima" 
                                },
                                Option {
                                    text: "Brat GL"  
                                },
                            	Option {
                                    text: "Civic Coupe"
                                },
                            	Option {
                                    text: "Civic ES"
                                 },
                                Option {
                                    text: "Escape"
                                },
                                Option {
                                    text: "E92"
                                },
                                Option {
                                    text: "EOS"
                                },
                                Option {
                                    text: "Fusion"
                                },
                                Option {
                                    text: "Impala"
                                },
                                Option {
                                    text: "Impreza"
                                },
                                Option {
                                    text: "LS"
                                },
                                Option {
                                    text: "Malibu"
                                },
                                Option {
                                    text: "Miata"
                                },
                                Option {
                                    text: "Rav-4"
                                },
                                Option {
                                    text: "Sonoma"
                                },
                                Option {
                                    text: "Stratus"
                                },
                                Option {
                                    text: "Taurus"
                                }
                            ]
                        }     
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("VIN: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: serialNo 
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("License Plate: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: licensePlate 
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    DateTimePicker {
                        id: lossDate 
                        title: qsTr("Loss/Damage Date: ")
                        mode: DateTimePickerMode.DateTime
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Location: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: location 
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Cause: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: cause 
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    Label {
                        text: qsTr("Police Unit Notified: ")
                        verticalAlignment: VerticalAlignment.Center
                    }
                    TextField {
                        id: policeUnit
                    }
                }
                
                Container {
                    topPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    
                    DateTimePicker {
                        id: unitNotifyDate 
                        title: qsTr("Notify Date: ")
                        mode: DateTimePickerMode.DateTime
                    }
                }
            }
         }
	}
	
	function setYears() {}
	
	function setMakes() {}
	
	function setModels() {}
	
    onClaimDataChanged: {
        var auto = claimData.Vehicle.split(",")
        
        for (var i=autoYear.options.length-1; i >=0; --i) {
            if (auto[0].trim() == autoYear.at(i).text) {
                autoYear.setSelectedIndex(i)
                break;
            }
        }
        
        for (var i=autoMake.options.length-1; i >=0; --i) {
            if (auto[1].trim() == autoMake.at(i).text) {
                autoMake.setSelectedIndex(i)
                break;
            }
        }
        
        for (var i=autoModel.options.length-1; i >=0; --i) {
            if (auto[2].trim() == autoModel.at(i).text) {
                autoModel.setSelectedIndex(i)
                break;
            }
        }
        
        claimantName.text = claimData.Name
        header.title = qsTr("Status:") + " " + claimData.StatusName
        claimNo.text = qsTr("Claim #: ") + claimData.ClaimNo
        claimDate.value = _app.strToDate(claimData.ClaimDate)
        policyNo.text = claimData.PolicyNo
        serialNo.text = claimData.SerialNo
        insureUntil.value = _app.strToDate(claimData.InsuredUntil)
        insurer.text = claimData.Insurer
        licensePlate.text = claimData.LicensePlateNo
        lossDate.value = _app.strToDate(claimData.LossDamageDate)
        location.text = claimData.Location
        cause.text = claimData.DamageLossCause
        policeUnit.text = claimData.PoliceUnit
        unitNotifyDate.value = _app.strToDate(claimData.UnitNotifyDate)
    }
}
