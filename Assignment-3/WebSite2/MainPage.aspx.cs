using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

 namespace WebSite2
{
    public partial class MainPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Submit_Click(object sender, EventArgs e)
    {
        EnergyDataInput energydataInput = new EnergyDataInput();
        string n= string.Format("{0}",Request.Form["plantID"]);
            


    }
    }
}