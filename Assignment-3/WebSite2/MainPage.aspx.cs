using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


    public partial class MainPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Submit_Click(object sender, EventArgs e)
        {
            EnergyDataInput energydataInput = new EnergyDataInput();
            energydataInput.plantID = double.Parse(plantID.Text);
            energydataInput.plantName = plantName.Text;
            energydataInput.sectorName = SectorName.Text;
            energydataInput.netGenJan = double.Parse(NetGenJan.Text);
            energydataInput.netGenFeb = double.Parse(NetGenFeb.Text);
            energydataInput.netGenMar = double.Parse(NetGenMar.Text);
            energydataInput.netGenApr = double.Parse(NetGenApr.Text);
            energydataInput.netGenMay = double.Parse(NetGenMay.Text);
            energydataInput.netGenJun = double.Parse(NetGenJun.Text);
            energydataInput.netGenJul = double.Parse(NetGenJul.Text);
            energydataInput.netGenAug = double.Parse(NetGenAug.Text);
            energydataInput.netGenSep = double.Parse(NetGenSep.Text);
            energydataInput.netGenOct = double.Parse(NetGenOct.Text);
            energydataInput.netGenNov = double.Parse(NetGenNov.Text);
            energydataInput.netGenDec = double.Parse(NetGenDec.Text);
            energydataInput.totalfuelConsump = double.Parse(totalFuelConsump.Text);
            energydataInput.totalfuelConsumpMMBtu = double.Parse(totalfuelConsumpMMBtu.Text);

            string predictPowerGenerationClass = EnergyAnalyticsClass.PredictPowerGeneration(energydataInput);

            if (predictPowerGenerationClass!="Error")
            {
                label.Visible = true;
                predictedLabel.Text = predictPowerGenerationClass;
                predictedLabel.Visible = true;
            }





        }
    }
