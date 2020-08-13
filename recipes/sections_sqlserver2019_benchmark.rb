#
# Cookbook:: cb-sqlserver2019-benchmark
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# 1_Installation_Updates_and_Patches
# https://docs.microsoft.com/en-us/sql/database-engine/install-windows/latest-updates-for-microsoft-sql-server?view=sql-server-ver15

# Load SQL PS Modules
powershell_script 'sqlps module' do
  code 'Import-Module "sqlps" -DisableNameChecking'
end

# 2.1 Ensure 'Ad Hoc Distributed Queries' Server Configuration Option is set to '0'
powershell_script 'Ad Hoc Distributed Queries' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE; EXECUTE sp_configure 'Ad Hoc Distributed Queries', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$AdHoc = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use  FROM sys.configurations  WHERE name = 'Ad Hoc Distributed Queries'\");(((($AdHoc).name -eq 'Ad Hoc Distributed Queries') -and ($AdHoc).value_configured -eq '1') -and ($AdHoc).value_in_use -eq '1')"
end

# 2.2 Ensure 'CLR Enabled' Server Configuration Option is set to '0'
powershell_script 'CLR Enabled' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'clr enabled', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$clr = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT CAST(value as int) as value_configured,\n  CAST(value_in_use as int) as value_in_use\n  FROM sys.configurations\n  WHERE name = 'clr enabled'\");(((($clr).name -eq 'clr enabled') -and ($clr).value_configured -eq '1') -and ($clr).value_in_use -eq '1')"
end

# 2.3 Ensure 'Cross DB Ownership Chaining' Server Configuration Option is set to '0' 
powershell_script 'Cross DB Ownership Chaining' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'cross db ownership chaining', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$dbown = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'cross db ownership chaining'\");(((($dbown).name -eq 'clr enabled') -and ($dbown).value_configured -eq '1') -and ($dbown).value_in_use -eq '1')"
end

# 2.4 Ensure 'Database Mail XPs' Server Configuration Option is set to '0'
powershell_script 'Database Mail XPs' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE; EXECUTE sp_configure 'Database Mail XPs', 0; RECONFIGURE; EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$dbmailxp = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT CAST(value as int) as value_configured,\n  CAST(value_in_use as int) as value_in_use\n  FROM sys.configurations\n  WHERE name = 'Database Mail XPs'\");(((($dbmailxp).name -eq 'Database Mail XPs') -and ($dbmailxp).value_configured -eq '1') -and ($dbmailxp).value_in_use -eq '1')"
end

# 2.5 Ensure 'Ole Automation Procedures' Server Configuration Option is set to '0'
powershell_script 'Ole Automation Procedures' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE; EXECUTE sp_configure 'Ole Automation Procedures', 0; RECONFIGURE; EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$OleAuto = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT CAST(value as int) as value_configured,\n  CAST(value_in_use as int) as value_in_use\n  FROM sys.configurations\n  WHERE name = 'Ole Automation Procedures'\");(((($OleAuto).name -eq 'Ole Automation Procedures') -and ($OleAuto).value_configured -eq '1') -and ($OleAuto).value_in_use -eq '1')"
end

# 2.6_Set_the_Remote_Access_Server_Configuration_Option_to_0
powershell_script 'Remote_Access_Server' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE; EXECUTE sp_configure 'remote access', 0; RECONFIGURE; EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$remoteaccess = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name, CAST(value as int) as value_configured, CAST(value_in_use as int) as value_in_use FROM sys.configurations WHERE name = 'remote access'\");(((($remoteaccess).name -eq 'remote access') -and ($remoteaccess).value_configured -eq '1') -and ($remoteaccess).value_in_use -eq '1')"
end

# 2.7_Set_the_Remote_Admin_Connections_Server_Configuration_Option_to_0
powershell_script 'Remote_Admin_Connections' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'remote admin connections', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$remoteadmin = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT CAST(value as int) as value_configured,\n  CAST(value_in_use as int) as value_in_use\n  FROM sys.configurations\n  WHERE name = 'Remote admin connections'\");(((($remoteadmin).name -eq 'Remote admin connections') -and ($remoteadmin).value_configured -eq '1') -and ($remoteadmin).value_in_use -eq '1')"
end

# 2.8_Set_the_Scan_For_Startup_Procs_Server_Configuration_Option_to_0
powershell_script 'Scan_For_Startup_Procs' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE; EXECUTE sp_configure 'scan for startup procs', 0; RECONFIGURE; EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$procscan = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT CAST(value as int) as value_configured,\n  CAST(value_in_use as int) as value_in_use\n  FROM sys.configurations\n  WHERE name = 'Scan for startup procs'\");(((($procscan).name -eq 'Scan for startup procs') -and ($procscan).value_configured -eq '1') -and ($procscan).value_in_use -eq '1')"
end

# 2.9_Set_the_Trustworthy_Database_Property_to_Off
powershell_script 'Trustworthy_Database' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"ALTER DATABASE msdb SET TRUSTWORTHY OFF;\"
  EOH
  guard_interpreter :powershell_script
  only_if "$trust = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name\n  FROM sys.databases\n  WHERE is_trustworthy_on = 1\n  AND name != 'msdb'\n  AND state = '0'\");(($trust).name -ne $null)"
end

# 2.12 Ensure 'Hide Instance' option is set to 'Yes' for Production SQL Server instances
powershell_script 'Hide Instance' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"EXEC master.sys.xp_instance_regwrite @rootkey = N'HKEY_LOCAL_MACHINE', @key = N'SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQLServer\\SuperSocketNetLib', @value_name = N'HideInstance', @type = N'REG_DWORD', @value = 1;\"
  EOH
  guard_interpreter :powershell_script
  only_if "(Invoke-SqlCmd -serverinstance \"localhost\" -Query \"DECLARE @getValue INT; EXEC master.sys.xp_instance_regread @rootkey = N'HKEY_LOCAL_MACHINE', @key = N'SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQLServer\\SuperSocketNetLib', @value_name = N'HideInstance', @value = @getValue OUTPUT; SELECT @getValue).Column1 -eq '1')"
end

# 2.13 Ensure the 'sa' Login Account is set to 'Disabled'
powershell_script 'sa login account disabled' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"USE [master] DECLARE @tsql nvarchar(max) SET @tsql = 'ALTER LOGIN ' + SUSER_NAME(0x01) + ' DISABLE' EXEC (@tsql);\"
  EOH
  guard_interpreter :powershell_script
  only_if "$sa = (Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name FROM sys.server_principals WHERE sid = 0x01 and is_disabled = 0'\");(($sa).name -eq $null) -and ($sa).is_disabled -eq $null)"
end

# 2.14 Ensure the 'sa' Login Account has been renamed
powershell_script 'sa Login Account change' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"ALTER LOGIN sa WITH NAME = [sa_renamed];\"
  EOH
  guard_interpreter :powershell_script
  only_if "(Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name FROM sys.server_principals WHERE sid = 0x01;\").name -eq 'sa')"
end

=begin
# 2.15 Ensure 'AUTO_CLOSE' is set to 'OFF' on contained databases
powershell_script 'AUTO_CLOSE set to OFF' do
  code <<-EOH
  # write-host ''
  EOH
  guard_interpreter :powershell_script
  only_if "(Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT name, containment, containment_desc, is_auto_close_on FROM sys.databases WHERE containment <> 0 and is_auto_close_on = 1;\") -ne $null)"
end
=end

# 2.16 Ensure no login exists with the name 'sa'
powershell_script 'no sa login exists' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"USE [master] ALTER LOGIN [sa] WITH NAME = sa_renamed;\"
  EOH
  guard_interpreter :powershell_script
  only_if "(Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT principal_id, name FROM sys.server_principals WHERE name = 'sa';\") -ne $null)"
end

# 3.1 Ensure 'Server Authentication' Property is set to 'Windows Authentication Mode'
powershell_script 'Server Authentication' do
  code <<-EOH
  invoke-sqlcmd -ServerInstance \"localhost\" -Query \"USE [master] EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\\Microsoft\\MSSQLServer\\MSSQLServer', N'LoginMode', REG_DWORD, 1\"
  EOH
  guard_interpreter :powershell_script
  only_if "(Invoke-SqlCmd -serverinstance \"localhost\" -Query \"SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') as login_mode;\").login_mode -ne '1'"
end

### <update other sections> ###