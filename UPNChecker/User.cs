//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace UPNChecker
{
    using System;
    using System.Collections.Generic;
    
    public partial class User
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public User()
        {
            this.DistinguishedName = "";
            this.Enabled = "";
            this.GivenName = "";
            this.Name = "";
            this.ObjectClass = "";
            this.ObjectGUID = "";
            this.SamAccountName = "";
            this.Surname = "";
            this.UserPrincipalName = "";
            this.Alias = "";
            this.ServerName = "";
            this.ProhibitSendQuota = "";
            this.DisplayName = "";
            this.ItemCount = "";
            this.StorageLimitStatus = "";
            this.LastLogonTime = "";
            this.IsInAcceptedDomain = "";
        }
    
        public int Id { get; set; }
        public string DistinguishedName { get; set; }
        public string Enabled { get; set; }
        public string GivenName { get; set; }
        public string Name { get; set; }
        public string ObjectClass { get; set; }
        public string ObjectGUID { get; set; }
        public string SamAccountName { get; set; }
        public string SID { get; set; }
        public string Surname { get; set; }
        public string UserPrincipalName { get; set; }
        public string Alias { get; set; }
        public string ServerName { get; set; }
        public string ProhibitSendQuota { get; set; }
        public string DisplayName { get; set; }
        public string ItemCount { get; set; }
        public string StorageLimitStatus { get; set; }
        public string LastLogonTime { get; set; }
        public string IsInAcceptedDomain { get; set; }
    }
}
