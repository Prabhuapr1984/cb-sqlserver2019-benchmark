#
# Cookbook:: cb-sqlserver2019-benchmark
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'cb-sqlserver2019-benchmark::sqlserver2019_cis_harden'
# include_recipe 'cb-sqlserver2019-benchmark::sections_sqlserver2019_benchmark' # applicable if use sections