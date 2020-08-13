#
# Cookbook:: cb-sqlserver2019-benchmark
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# Copy template from cookbook to c:\windows\temp directory
template 'C:\Windows\temp\sqlserver2019_benchmark.sql' do
    source 'sqlserver2019_benchmark.sql.erb'
end

# Load SQL PowerShell modules to apply the hardening file
powershell_script 'sqlps module' do
    code 'Import-Module "sqlps" -DisableNameChecking'
end

# apply the sql 2019 cis benchmark hardening using the sql file
execute 'apply sqlserver2019 benchmark' do
    command "sqlcmd -S localhost -i \"C:\\Windows\\temp\\sqlserver2019_benchmark.sql\""
end
