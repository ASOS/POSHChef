<#
Copyright 2014 ASOS.com Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>


function databag_create {


	<#

	.SYNOPSIS
		Create a new database on the server

	.DESCRIPTION
		Databags are useful to hold central bits of information that the system may require, such as the name of any
		users to create for example.

		This function attempts to create a new databag on the server

	.EXAMPLE

		Invoke-POSHKnife databag create -name example

		Creates new datag called 'example'

	#>

	[CmdletBinding()]
	param (

		[string[]]
		# List of names of database to create
		$name
	)

	# Setup the mandatory parameters
	$mandatory = @{
		name = "String array of databags to create (-name)"
	}

	Confirm-Parameters -Parameters $PSBoundParameters -mandatory $mandatory

	# Determine the name of the chef type from the function name
	$chef_type, $action = $MyInvocation.MyCommand -split "_"

	# determine the mapping for the chef query
	$mapping = "{0}s" -f $chef_type

	Write-Log -Message " "
	Write-Log -EVentId PC_INFO_0031 -extra ("Creating", (Get-Culture).TextInfo.ToTitleCase($mapping))

	# Get a list of the existing databags on the server
	$databags = Get-Databag

	# iterate around each of the items in the name
	foreach ($item in $name) {

		# Build up the hashtable for the arguments to create the databag on the server
		$splat = @{
			InputObject = @{
				name = $item
			}
			list = $databags.keys
			chef_type = "data"
		}

		Upload-ChefItem @splat

	}
}
