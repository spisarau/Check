using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utils;
namespace UPNChecker
{
    public partial class User
    {
        public User(string json):this()
        {
            var userProperties = JsonUtils.DeserializeJSON(json);
            var user = Type.GetType(this.ToString());
            var properties = user.GetProperties();
            foreach (var property in properties)
            {
                var query = from p in userProperties
                            where p.Key.ToUpper() == property.Name.ToUpper()
                            select p;
                if (query.Count() > 0)
                {
                    property.SetValue(this, query.First().Value);
                }
            }

        }
    }
}
