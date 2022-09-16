# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment

# Install the module required
Install-Module -Name Posh-SSH

# Get the IPAddress for kubmas2
$IPAddress = "192.168.0.96"

# Create credentials to login into the Kubernetes node
$password = ConvertTo-SecureString "Netapp1!" -AsPlainText -Force
$credential= New-Object System.Management.Automation.PSCredential ("root", $password)

# Variables and commands to execute on each Kubernetes nodes
$file = "C:\Users\Administrator.DEMO\Desktop\CourseFiles\astra-control-center-22.08.1-26.tar.gz"
$destination = "/root"
$command1 = "tar -vxzf astra-control-center-22.08.1-26.tar.gz"
$command2 = "cp kubectl-astra/astra_linux_amd64 /usr/bin/kubectl-astra"
$command3 = "cd acc"
$command4 = "kubectl astra packages push-images -m acc.manifest.yaml -r docker-registry:30001 -u admin -p Netapp1!"
$validation = "curl https://'$IPAddress':30001/v2/_catalog"

# Executing commands and reporting back

    $ssh=New-SSHSession -ComputerName $IPAddress -Credential $credential -AcceptKey 
    Set-SCPItem -ComputerName $IPAddress -Credential $credential -Path $file -Destination $destination -AcceptKey | Out-Null
    $commandResult1 = Invoke-SSHCommand -SSHSession $ssh -Command $command1 | Out-Null
    $commandResult2 = Invoke-SSHCommand -SSHSession $ssh -Command $command2 | Out-Null
    $commandResult3 = Invoke-SSHCommand -SSHSession $ssh -Command $command3 | Out-Null
    $commandResult4 = Invoke-SSHCommand -SSHSession $ssh -Command $command4 | Out-Null
    $validationResult = Invoke-SSHCommand -SSHSession $ssh -Command $validation
    Write-Output($IPAddress + " result:")
    Write-Output($validationResult.Output)
    Write-Output('')
    $removeResult = Remove-SSHSession -SSHSession $ssh


# End
Write-Output('end')