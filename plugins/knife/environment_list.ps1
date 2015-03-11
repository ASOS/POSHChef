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


function environment_list {


	<#

	.SYNOPSIS
		Display a list of environments on the Chef server

	.DESCRIPTION
		Display a list of all the environments that have been registered with the chef server

		No additional parameters are required for this operation

		If the plugin detects that the list of environments should be returned to a variable
		then the object is passed back and nothing is outputted to tje screen.

	.EXAMPLE

		PS C:\> Invoke-POSHKnife environment list

		List all the environments

	#>

	# Determine the name of the chef type from the function name
	$chef_type, $action = $MyInvocation.MyCommand -split "_"

	# determine the mapping for the chef query
	$mapping = "{0}s" -f $chef_type

	Write-Log -Message " "
	Write-Log -EVentId PC_INFO_0031 -extra ("Listing", (Get-Culture).TextInfo.ToTitleCase($mapping))

	# Get a list of the roles currently on the server
	# This so it can be determined if the role already exists or needs to be created
	# $items_on_server = Invoke-ChefQuery -Path ("/{0}" -f $mapping)
	$items_on_server = Get-Environment

	if ($PSCmdlet.MyInvocation.Line.Trim().startswith('$')) {
		$items_on_server
	} else {
		# Iterate around the items of the server and show list them
		foreach ($item in ($items_on_server.keys | sort)) {

			Write-Log -EventId PC_MISC_0000 -extra ($item)

		}
	}

}
