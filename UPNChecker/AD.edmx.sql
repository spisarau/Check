
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server Compact Edition
-- --------------------------------------------------
-- Date Created: 05/12/2018 12:20:25
-- Generated from EDMX file: d:\CHECKUPN\CheckUPN\UPNChecker\AD.edmx
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- NOTE: if the constraint does not exist, an ignorable error will be reported.
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- NOTE: if the table does not exist, an ignorable error will be reported.
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'UserSet'
CREATE TABLE [UserSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [DistinguishedName] nvarchar(4000)  NOT NULL,
    [Enabled] nvarchar(4000)  NOT NULL,
    [GivenName] nvarchar(4000)  NOT NULL,
    [Name] nvarchar(4000)  NOT NULL,
    [ObjectClass] nvarchar(4000)  NOT NULL,
    [ObjectGUID] nvarchar(4000)  NOT NULL,
    [SamAccountName] nvarchar(4000)  NOT NULL,
    [SID] nvarchar(4000)  NOT NULL,
    [Surname] nvarchar(4000)  NOT NULL,
    [UserPrincipalName] nvarchar(4000)  NOT NULL,
    [Alias] nvarchar(4000)  NOT NULL,
    [ServerName] nvarchar(4000)  NOT NULL,
    [ProhibitSendQuota] nvarchar(4000)  NOT NULL,
    [DisplayName] nvarchar(4000)  NOT NULL,
    [ItemCount] nvarchar(4000)  NOT NULL,
    [StorageLimitStatus] nvarchar(4000)  NOT NULL,
    [LastLogonTime] nvarchar(4000)  NOT NULL,
    [IsInAcceptedDomain] nvarchar(4000)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'UserSet'
ALTER TABLE [UserSet]
ADD CONSTRAINT [PK_UserSet]
    PRIMARY KEY ([Id] );
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------