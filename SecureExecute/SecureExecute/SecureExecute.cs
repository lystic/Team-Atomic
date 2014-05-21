/*            Secure Excecute Version 1             *\

    By: Lystic
    Other Credits: Pwnoz0r
    Notes: this protects scripts from being stolen
           by only allowing a single execution.

\*                                                  */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Arma2Net.AddInProxy;
using System.Reflection;
using System.IO;

namespace SecureExecute
{
    [AddIn("SecureExecute")]
    public class SecureExecute : MethodAddIn
    {
        private List<int> used;
        private List<string> config;
        private string getDir()
        {
            string dir = Path.GetDirectoryName(new Uri(Assembly.GetExecutingAssembly().CodeBase).LocalPath) + "\\SecureExecute";
            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }
            return dir;
        }
        private void readConfig()
        {
            string configPath = getDir() + "\\Config.sqf";
            if (!File.Exists(configPath))
            {
                File.Create(configPath).Close();
                File.WriteAllText(configPath, "//Config should contain one file path per line");
            }
            StreamReader reader = new StreamReader(configPath);
            string line = "";
            while((line = reader.ReadLine()) != null) 
            {
                if (!line.StartsWith("//"))
                {
                    config.Add(line.Replace("//", "`").Split('`')[0].Trim()); //if there is a line with a comment at the end then it takes away the comment.
                }
            }
        }
        public string execute(int config_lineNumber)
        {
            if (config.Count == 0)
                readConfig();   //Read config if it hasnt been loaded yet

            string script = "call compile preprocesslinenumbers \"";
            
            if (used.Contains(config_lineNumber) || config.Count <= config_lineNumber)
                return ""; //return nothing if the file has already been run.
    
            used.Add(config_lineNumber);

            
            string line = config[config_lineNumber];
            script = script + line + "\";";

            return script;
        }
    }
}
