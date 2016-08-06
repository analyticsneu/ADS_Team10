using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for EnergyDataInput
/// </summary>

    public class EnergyDataInput
    {
        public EnergyDataInput()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public double plantID { get; set; }
        public string plantName { get; set; }
        public string sectorName { get; set; }
        public double netGenJan { get; set; }
        public double netGenFeb { get; set; }
        public double netGenMar { get; set; }
        public double netGenApr { get; set; }
        public double netGenMay { get; set; }
        public double netGenJun { get; set; }
        public double netGenJul { get; set; }
        public double netGenAug { get; set; }
        public double netGenSep { get; set; }
        public double netGenOct { get; set; }
        public double netGenNov { get; set; }
        public double netGenDec { get; set; }
        public double totalfuelConsump { get; set; }
        public double totalfuelConsumpMMBtu { get; set; }
        
    }
