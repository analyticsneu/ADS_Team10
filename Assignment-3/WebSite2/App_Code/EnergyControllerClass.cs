// This code requires the Nuget package Microsoft.AspNet.WebApi.Client to be installed.
// Instructions for doing this in Visual Studio:
// Tools -> Nuget Package Manager -> Package Manager Console
// Install-Package Microsoft.AspNet.WebApi.Client

using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;


    public class StringTable
    {
        public string[] ColumnNames { get; set; }
        public string[,] Values { get; set; }
    }

   public  class EnergyAnalyticsClass
    {

        public static string PredictPowerGeneration(EnergyDataInput dataset)
        {
            using (var client = new HttpClient())
            {
                var scoreRequest = new
                {

                    Inputs = new Dictionary<string, StringTable>() {
                        {
                            "input1",
                             new StringTable() 
                            {
                                ColumnNames = new string[] {"Plant Id", "Combined Heat And Power Plant", "Plant State", "Sector Name", "Reported Fuel Type Code", "AER Fuel Type Code", "Netgen_January", "Netgen_February", "Netgen_March", "Netgen_April", "Netgen_May", "Netgen_June", "Netgen_July", "Netgen_August", "Netgen_September", "Netgen_October", "Netgen_November", "Netgen_December", "Total Fuel Consumption Quantity", "Total Fuel Consumption MMBtu"},
                                Values = new string[,] {  { Convert.ToString(dataset.plantID),Convert.ToString(dataset.plantName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.netGenJan), Convert.ToString(dataset.netGenFeb), Convert.ToString(dataset.netGenMar), Convert.ToString(dataset.netGenApr), Convert.ToString(dataset.netGenMay), Convert.ToString(dataset.netGenJun), Convert.ToString(dataset.netGenJul), Convert.ToString(dataset.netGenAug), Convert.ToString(dataset.netGenSep), Convert.ToString(dataset.netGenOct), Convert.ToString(dataset.netGenNov), Convert.ToString(dataset.netGenDec), Convert.ToString(dataset.totalfuelConsump), Convert.ToString(dataset.totalfuelConsumpMMBtu) }, { Convert.ToString(dataset.plantID),Convert.ToString(dataset.plantName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.plantName), Convert.ToString(dataset.netGenJan), Convert.ToString(dataset.netGenFeb), Convert.ToString(dataset.netGenMar), Convert.ToString(dataset.netGenApr), Convert.ToString(dataset.netGenMay), Convert.ToString(dataset.netGenJun), Convert.ToString(dataset.netGenJul), Convert.ToString(dataset.netGenAug), Convert.ToString(dataset.netGenSep), Convert.ToString(dataset.netGenOct), Convert.ToString(dataset.netGenNov), Convert.ToString(dataset.netGenDec), Convert.ToString(dataset.totalfuelConsump), Convert.ToString(dataset.totalfuelConsumpMMBtu) }  }
                            }

                        },
                    },
                    GlobalParameters = new Dictionary<string, string>()
                    {
                    }
                };
                const string apiKey = "KpmS4wCVpCK4Xucp5ArGoUPGuJSgGxb9c1+9eVU6EOmSXUjDlSUC9gdF0ES5noQ1pjLRbwDeGBKH3i1olOwwHA=="; 
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

                client.BaseAddress = new Uri("https://ussouthcentral.services.azureml.net/workspaces/65817a10f4a4452db8059313c8182a68/services/9b3023fe58114cdf888c4389e3edeec1/execute?api-version=2.0&details=true");

                //CALL WEB SERVICE
                HttpResponseMessage response = client.PostAsJsonAsync("", scoreRequest).Result;

                //Work with response
                if (response.IsSuccessStatusCode)
                {
                    string jsondocument = response.Content.ReadAsStringAsync().Result;


                    var responseBody = JsonConvert.DeserializeObject<RRSResponseObject>(jsondocument);
                    return responseBody.Results.output1.value.Values[0][0];

                }
                else
                {
                    return "Error";
                }
            }

        }
        public static string ClassifyPowerGeneration(EnergyDataInput dataset)
        {
            using (var client1 = new HttpClient())
            {
                var scoreRequest1 = new
                {

                    Inputs = new Dictionary<string, StringTable>() {
                        {
                            "input1",
                             new StringTable() 
                            {
                                ColumnNames = new string[] {"Plant Id", "Plant State", "Sector Name", "Reported Fuel Type Code", "AER Fuel Type Code", "Netgen_January", "Netgen_February", "Netgen_March", "Netgen_April", "Netgen_May", "Netgen_June", "Netgen_July", "Netgen_August", "Netgen_September", "Netgen_October", "Netgen_November", "Netgen_December", "Total Fuel Consumption Quantity", "Total Fuel Consumption MMBtu","Net_Generation"},
                                Values = new string[,] {  { Convert.ToString(dataset.plantID), Convert.ToString(dataset.plantState), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.netGenJan), Convert.ToString(dataset.netGenFeb), Convert.ToString(dataset.netGenMar), Convert.ToString(dataset.netGenApr), Convert.ToString(dataset.netGenMay), Convert.ToString(dataset.netGenJun), Convert.ToString(dataset.netGenJul), Convert.ToString(dataset.netGenAug), Convert.ToString(dataset.netGenSep), Convert.ToString(dataset.netGenOct), Convert.ToString(dataset.netGenNov), Convert.ToString(dataset.netGenDec), Convert.ToString(dataset.totalfuelConsump), Convert.ToString(dataset.totalfuelConsumpMMBtu), Convert.ToString(dataset.totalNetGeneration) }, { Convert.ToString(dataset.plantID), Convert.ToString(dataset.plantState), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.sectorName), Convert.ToString(dataset.netGenJan), Convert.ToString(dataset.netGenFeb), Convert.ToString(dataset.netGenMar), Convert.ToString(dataset.netGenApr), Convert.ToString(dataset.netGenMay), Convert.ToString(dataset.netGenJun), Convert.ToString(dataset.netGenJul), Convert.ToString(dataset.netGenAug), Convert.ToString(dataset.netGenSep), Convert.ToString(dataset.netGenOct), Convert.ToString(dataset.netGenNov), Convert.ToString(dataset.netGenDec), Convert.ToString(dataset.totalfuelConsump), Convert.ToString(dataset.totalfuelConsumpMMBtu), Convert.ToString(dataset.totalNetGeneration) }  }
                            }

                        },
                    },
                    GlobalParameters = new Dictionary<string, string>()
                    {
                    }
                };
                const string apiKey = "IiImNOCZh2bhjmYtDW11Ffua5baRKHJ8LbQWxpdRf3JWoI34n4UMjQpq5WHRWI29ZQZOpDjxyV2ibQ7IQh+AXQ==";
                client1.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

                client1.BaseAddress = new Uri("https://ussouthcentral.services.azureml.net/workspaces/65817a10f4a4452db8059313c8182a68/services/4888e2d620114e8786b2d2e788706ff8/execute?api-version=2.0&details=true");

                //CALL WEB SERVICE
                HttpResponseMessage response = client1.PostAsJsonAsync("", scoreRequest1).Result;

                //Work with response
                if (response.IsSuccessStatusCode)
                {
                    string jsondocument = response.Content.ReadAsStringAsync().Result;
                    var responseBody = JsonConvert.DeserializeObject<RRSResponseObject>(jsondocument);
                    return responseBody.Results.output1.value.Values[0][0];

                }
                else
                {
                    return "Error";
                }
            }

        }
    }


   #region Helper Classes
   public class RRSResponseObject
   {
       public Results Results { get; set; }
   }

   public class Results
   {
       public Output1 output1 { get; set; }
   }

   public class Output1
   {
       public string type { get; set; }
       public Value value { get; set; }
   }

   public class Value
   {
       public string[] ColumnNames { get; set; }
       public string[] ColumnTypes { get; set; }
       public string[][] Values { get; set; }
   } 
   #endregion





