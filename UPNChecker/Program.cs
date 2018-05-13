using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Management.Automation;
using System.Management;
using System.IO;
using static System.Console;
namespace UPNChecker
{
    class Program
    {
        static string dataFile = ConfigurationManager.AppSettings["Upncsv"];
        static string psModule = ConfigurationManager.AppSettings["Module"];
        static string importModule = $"Import-Module -Name {psModule}";
        static string checkexchattr = "$true";
        static string cmdltName = "Check-UPN";
        static string addSnapin = "Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn";
        static void Main(string[] args)
        {
           
            var upns = File.ReadAllLines(dataFile);
            WriteLine($"Information  from {dataFile} was loaded.");
            var users = GetUsers(upns, checkexchattr);
            ADContainer aDContainer = new ADContainer();
            foreach (var user in users)
            {
                var fuser=aDContainer.UserSet.Find(user.SID);
                if (fuser == null) {
                    aDContainer.UserSet.Add(user);
                    Console.WriteLine($"Information for {user.UserPrincipalName} is succesfully added. ");

                }
                else WriteLine($"Information for {fuser.UserPrincipalName} already exists.");

            }
            
            aDContainer.SaveChanges();
            WriteLine($"Press any key to exit...");
            ReadKey();
        }
        
        static IEnumerable<User> GetUsers(string [] upns, string checkexchattr= "$true") {
            
            if (upns.Length == 0) return null;
            PowerShell powerShell = PowerShell.Create();
            HashSet<User> users = new HashSet<User>();
            powerShell.AddScript(importModule);
            powerShell.Invoke();
           
            foreach (var upn in upns)
            {
                User usr;
                powerShell.AddScript($"{cmdltName} {upn} {checkexchattr}");
                var result = powerShell.Invoke();
                if (result.Count == 0) continue;
                if (result[0].ToString().Contains("exception")) { Console.WriteLine($"Couldn't add information for {upn} : {result.First()}");continue; };          
                usr = new User();
                usr.addUserPropertiesFromJSON(result[0].ToString());
                users.Add(usr);
                

            }
           

            return users; }
    }
}
