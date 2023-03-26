Function Get-DockerImage {
    [CmdletBinding(DefaultParameterSetName='ByRepository')]
    param(
        [Parameter(ParameterSetName='ById', Mandatory=$True)]
        [String[]]
        $Id,
        [Parameter(Position=0, ParameterSetName='ByRepository')]
        [String]
        $Repository = '*'
    )
    if($PSCmdlet.ParameterSetName -eq 'ById'){
        Get-DockerImage | Where-Object -Property Id -Value $Id
    }
    elseif($PSCmdlet.ParameterSetName -eq 'ByRepository') {
        docker image ls --digests --format "{{json . }}" | ConvertFrom-JSON | Where-Object {$_.Repository -like $Repository}
    }
}

Function Run-DockerImage {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id
    )
    if($PSCmdlet.ShouldProcess($Id, 'run image')){
        docker run $($Id -join ' ')
    }
}

Function Get-DockerContainer {
    [CmdletBinding(DefaultParameterSetName='ByName')]
    param(
        [Parameter(ParameterSetName='ByName')]
        [String[]]
        $Name,
        [Parameter(ParameterSetName='ById')]
        [String[]]
        $Id
    )
    if($PSBoundParameters.ContainsKey('Name')){
        docker ps -a --format "{{json . }}" | ConvertFrom-JSON | Where-Object {$_.Names -in $Name}
    }
    elseif($PSBoundParameters.ContainsKey('Id')){
        docker ps -a --format "{{json . }}" | ConvertFrom-JSON | Where-Object {$_.Id -in $Id}
    }
    else {
        docker ps -a --format "{{json . }}" | ConvertFrom-JSON
    }
}

Function Remove-DockerImage {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id,
        [Parameter()]
        [Switch]
        $Force
    )
    if($PSCmdlet.ShouldProcess($Id, 'remove image')){
        docker rmi $($Id -join ' ') $(if($Force.IsPresent -and $Force -eq $True){'-force'})
    }
}

Function Remove-DockerContainer {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id,
        [Parameter()]
        [Switch]
        $Force
    )
    Process {
        if($PSCmdlet.ShouldProcess($Id, 'remove container')){
            docker container rm $($Id -join ' ') $(if($Force.IsPresent -and $Force -eq $True){'-force'})
        }
    }
}

Function Start-DockerContainer {
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id
    )
    Process {
        if($PSCmdlet.ShouldProcess($Id, 'start container')){
            docker start $($Id -join ' ') 
        }
    }
}

Function Stop-DockerContainer {
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id
    )
    Process {
        if($PSCmdlet.ShouldProcess($Id, 'start container')){
            docker stop $($Id -join ' ') 
        }
    }
}

Function Kill-DockerContainer {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Id,
        [Parameter()]
        [Switch]
        $Force
    )
    Process {
        if($PSCmdlet.ShouldProcess($Id, 'kill container')){
            docker container kill $($Id -join ' ') $(if($Force.IsPresent -and $Force -eq $True){'-force'})
        }
    }
}
