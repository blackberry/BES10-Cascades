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
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class _Default : System.Web.UI.Page
{
    private static ArrayList textData = new ArrayList();

    protected void Page_Init(object sender, EventArgs e)
    {

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            readTxtFile();
            displayArray();
        }
    }
    protected void btnAddServer_Click(object sender, EventArgs e)
    {
        String serverName = tbServerName.Text;
        String serverIP = tbServerIP.Text;
        String serverListPath = @"c:\\test\\";
        String serverListFile = "Servers.txt";
        try
        {
            if (!System.IO.Directory.Exists(serverListPath))
            {
                System.IO.Directory.CreateDirectory(serverListPath);
            }
            StreamWriter tw = new StreamWriter(serverListPath + serverListFile, true);
            String strVar = serverName + "^" + serverIP;
            tw.WriteLine(strVar);
            tw.Close();
            readTxtFile();
            displayArray();
        }
        catch (Exception err)
        {
            //Display Error in textbox
            tbResults.Text += "ERROR: In btnAddServer_Click() " + err.ToString() + Environment.NewLine;
        }
    }

    public bool CheckInternetConnection(String ipAddress)
    {
        bool result = false;
        Ping p = new Ping();
        try
        {
            PingReply reply = p.Send(ipAddress, 1000);
            if (reply.Status == IPStatus.Success)
            {
                result = true;
            }
        }
        catch (PingException)
        {
            result = false;
        }
        return result;
    }

    public void readTxtFile()
    {
        textData.Clear();
        String filePath = @"c:\\test\\Servers.txt";
        String line;
        if (File.Exists(filePath))
        {
            StreamReader file = null;
            try
            {
                file = new StreamReader(filePath);
                while ((line = file.ReadLine()) != null)
                {
                    textData.Add(line + "^2");
                }
            }
            finally
            {
                if (file != null)
                    file.Close();
            }
        }
    }

    public void displayArray()
    {
        int counter = 1;
        String monitorResults = "<table width='100%'><tr><td width='10%'>Number </td><td width='60%'>Server Name </td><td width='20%'>Status </td></tr>";
        String statusImage = "<img src='img/unknown.png' width='10%' />";
        for (int i = 0; i < textData.Count; i++)
        {
            String[] thisLine = textData[i].ToString().Split('^');
            if (thisLine[2].ToString().Equals("0"))
            {
                statusImage = "<img src='img/down.png' width='10%' />";
            }
            if (thisLine[2].ToString().Equals("1"))
            {
                statusImage = "<img src='img/up.png' width='10%' />";
            }
            monitorResults = monitorResults.ToString() + "<tr><td>" + counter + "</td><td>" + thisLine[0].ToString() + "</td><td><div id='status_" + counter + "'>" + statusImage + "</div></td></tr>";
            counter++;
        }
        monitorResults += "</table>";
        lblServerMonitor.Text = monitorResults;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Button2.Enabled = true;
        Button1.Enabled = false;
        btnAddServer.Enabled = false;
        int timeInterval = Convert.ToInt32(tbTimerInterval.Text) * 1000;
        Timer1.Interval = timeInterval;
        Timer1.Enabled = true;

    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Button1.Enabled = true;
        Button2.Enabled = false;
        btnAddServer.Enabled = true;
        Timer1.Enabled = false;
        readTxtFile();
        displayArray();
    }
    protected void Timer1_Tick(object sender, EventArgs e)
    {
        Timer1.Enabled = false;

        //Perform scheduled Action
        for (int i = 0; i < textData.Count; i++)
        {

            String[] lineData = textData[i].ToString().Split('^');
            bool pinger = CheckInternetConnection(lineData[1]);
            if (pinger == false)
            {
                lineData[2] = "0";
                textData[i] = lineData[0] + "^" + lineData[1] + "^" + lineData[2];
                sendAlert(lineData[0], lineData[1]);
            }
            else
            {
                lineData[2] = "1";
                textData[i] = lineData[0] + "^" + lineData[1] + "^" + lineData[2];
            }
            tbResults.Text += " PING: " + lineData[0].ToString() + " at: " + lineData[1].ToString() + " Result: " + pinger + Environment.NewLine;

        }
        displayArray();
        Timer1.Enabled = true;

    }

    public void sendAlert(String serverName, String serverIP)
    {
        String transmitData = "2|" + serverName + " DOWN!|ALERT!!! " + serverName + " at " + serverIP + " appears to be DOWN!!!!|http://www.woot.com";
        String besServer = tbBesName.Text;
        String besPushPort = tbPushPort.Text;
        String alertRecipient = tbRecipient.Text;
        String pushAppID = "bb_server_notify";
        String httpURL = "http://" + besServer
                            + ":" + besPushPort
                            + "/push?DESTINATION=" + alertRecipient
                            + "&PORT=" + pushAppID
                            + "&REQUESTURI=/";
        try
        {
            HttpWebRequest HttpWReq = (HttpWebRequest)WebRequest.Create(httpURL);
            HttpWReq.Method = ("POST");
            HttpWReq.ContentType = "text/plain";
            byte[] data = System.Text.ASCIIEncoding.UTF8.GetBytes(transmitData);
            if (data.Length <= 8192)
            {
                HttpWReq.ContentLength = data.Length;
                Stream requestStream = HttpWReq.GetRequestStream();
                requestStream.Write(data, 0, data.Length);
                HttpWebResponse HttpWRes = (HttpWebResponse)HttpWReq.GetResponse();
                if (HttpWRes.StatusCode == HttpStatusCode.OK)
                {
                    //write success push
                    tbResults.Text += "Notified " + alertRecipient + " via PUSH, Status: SUCCESS" + Environment.NewLine;
                }
                else
                {
                    //write fail push
                    tbResults.Text += "Notified " + alertRecipient + " via PUSH, Status: FAILED" + Environment.NewLine;
                }
                requestStream.Close();
                HttpWRes.Close();
            }
        }
        catch (Exception err)
        {
            //deal later
            tbResults.Text += "Error: " + err.ToString() + Environment.NewLine;
        }
    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        File.Create("C:\\test\\Servers.txt").Close();
        readTxtFile();
        displayArray();
    }

}
