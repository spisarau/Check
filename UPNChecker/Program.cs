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
        static string cmdltName = "Check-UPN";
        static void Main(string[] args)
        {
            try
            {
                var upns = File.ReadAllLines(dataFile);
                if (upns.Length == 0) { WriteLine($"File is empty, can't load information"); return; }
                WriteLine($"Information from {dataFile} was loaded.");
                var users = GetUsers(upns);
                ADContainer aDContainer = new ADContainer();
                foreach (var user in users)
                {
                    var fuser = aDContainer.UserSet.Find(user.SID);
                    if (fuser == null)
                    {
                        aDContainer.UserSet.Add(user);
                        Console.WriteLine($"Information for {user.UserPrincipalName} is succesfully added. ");
                    }
                    else WriteLine($"Information for {fuser.UserPrincipalName} already exists.");

                }

                aDContainer.SaveChanges();
            }
           
            catch (Exception e) { WriteLine(e.Message); }
            finally
            {
                WriteLine($"Press any key to exit...");
                ReadKey();
            }
           
        }
        
        static IEnumerable<User> GetUsers(string [] upns, string checkexchattr= "$true") {
            
            PowerShell powerShell = PowerShell.Create();
            HashSet<User> users = new HashSet<User>();
            powerShell.AddScript(importModule);
            powerShell.Invoke();
           
            foreach (var upn in upns)
            {
                User usr;
                powerShell.AddScript($"{cmdltName} {upn} {checkexchattr}");
                var result = powerShell.Invoke();
                if (result[0].ToString().Contains("exception"))
                {
                    Console.WriteLine($"Couldn't add information for {upn} : {result.First()}");continue;
                };          
                usr = new User(result[0].ToString());
                users.Add(usr);
            }
           

            return users; }
    }
}
