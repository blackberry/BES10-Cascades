<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%-- 

 Copyright (c) 2012 Research In Motion Limited.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
--%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>#WAAwesome 626+</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            font-size: xx-large;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>

        <table class="style1">
            <tr>
                <td width="102">
                    <asp:Image ID="Image1" runat="server" Height="100px" 
                        ImageUrl="~/Img/waawesome2.png" Width="100px" />
                </td>
                <td class="style2" width="100%">
                    #WAAwesome 626+ ServerNotify App</td>
            </tr>
            <tr>
                <td colspan="2" width="5%">
                    <fieldset><legend>Add A Server</legend>
                            <table class="style1">
                                <tr>
                                    <td align="left" width="40%">
                        Name:
                                    <asp:TextBox ID="tbServerName" runat="server" Width="75%"></asp:TextBox>
                                </td>
                                <td width="40%">
                                    IP:&nbsp;
                                    <asp:TextBox ID="tbServerIP" runat="server" Width="75%"></asp:TextBox>
                                        </td>
                                <td align="center" width="20%">
                                    <asp:Button ID="btnAddServer" runat="server" Text="Add Server" Width="99%" 
                                        onclick="btnAddServer_Click" />
                                </td>
                            </tr>
                        </table>
                    </fieldset></td>
            </tr>
            <tr>
                <td colspan="2">
                    <fieldset><legend>Servers Monitored</legend>
                            <asp:Label ID="lblServerMonitor" runat="server"></asp:Label>
                    </fieldset></td>
            </tr>
            
            <tr>
            <td colspan="2" align="center" width="98%">
                <table class="style1">
                    <tr>
                        <td align="left" width="25%">
                            <asp:Label ID="Label2" runat="server" style="text-align: right" Text="Notify: " 
                                Width="20%"></asp:Label>
                            <asp:TextBox ID="tbRecipient" runat="server" Width="78%"></asp:TextBox>
                        </td>
                        <td width="25%" align="left">
                            <asp:Label ID="Label3" runat="server" style="text-align: right" Text="BES: " 
                                Width="15%"></asp:Label>
                            <asp:TextBox ID="tbBesName" runat="server" Width="83%"></asp:TextBox>
                        </td>
                        <td width="25%" align="left">
                            <asp:Label ID="Label4" runat="server" style="text-align: right" 
                                Text="BES Push Port: " Width="35%"></asp:Label>
                            <asp:TextBox ID="tbPushPort" runat="server" Width="63%"></asp:TextBox>
                        </td>
                        <td width="25%" align="left">
                            <asp:Label ID="Label1" runat="server" Text="Interval (s): " 
                                style="text-align: right" Width="30%"></asp:Label>
                            <asp:TextBox ID="tbTimerInterval" runat="server" Width="68%">10</asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="25%" colspan="2" style="width: 50%">
                            <asp:Button ID="Button1" runat="server" Text="Start Monitoring" Width="95%" 
                                onclick="Button1_Click" />
                        </td>
                        <td width="25%">
                            <asp:Button ID="Button2" runat="server" Text="Stop Monitoring" Width="95%" 
                                onclick="Button2_Click" Enabled="False" />
                        </td>
                        <td width="25%">
                            <asp:Button ID="Button3" runat="server" onclick="Button3_Click" 
                                Text="Clear Monitor List" Width="95%" />
                        </td>
                    </tr>
                </table>
                </td>
                
            </tr>
        </table>

    </div>
        <asp:Label ID="lblResults" runat="server" Text="Results:"></asp:Label>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:TextBox ID="tbResults" runat="server" Width="99%" Rows="5" 
                    TextMode="MultiLine"></asp:TextBox>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Timer ID="Timer1" runat="server" Interval="2000" ontick="Timer1_Tick" 
            Enabled="False">
        </asp:Timer>
    </form>
</body>
</html>
