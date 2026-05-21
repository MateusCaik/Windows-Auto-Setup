Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Auto Setup"
$form.Size = New-Object System.Drawing.Size(520, 430)
$form.StartPosition = "CenterScreen"

$title = New-Object System.Windows.Forms.Label
$title.Text = "Selecione o que deseja instalar"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($title)

$apps = @(
    @{ Nome = "Google Chrome"; Id = "Google.Chrome" },
    @{ Nome = "Mozilla Firefox"; Id = "Mozilla.Firefox" },
    @{ Nome = "WinRAR"; Id = "RARLab.WinRAR" },
    @{ Nome = "Java Runtime"; Id = "Oracle.JavaRuntimeEnvironment" },

    # Microsoft 365
    @{ Nome = "Microsoft Office 365"; Id = "Microsoft.Office" },

    # Office 2016
    @{ Nome = "Microsoft Office 2016"; Id = "Office2016" }
)

$checkboxes = @()
$y = 70

foreach ($app in $apps) {

    $check = New-Object System.Windows.Forms.CheckBox
    $check.Text = $app.Nome
    $check.Tag = $app.Id
    $check.AutoSize = $true
    $check.Location = New-Object System.Drawing.Point(30, $y)
    $check.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    $form.Controls.Add($check)

    $checkboxes += $check
    $y += 35
}

$button = New-Object System.Windows.Forms.Button
$button.Text = "Instalar Selecionados"
$button.Size = New-Object System.Drawing.Size(200, 40)
$button.Location = New-Object System.Drawing.Point(30, 330)
$button.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$form.Controls.Add($button)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Aguardando Escolha..."
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(250, 340)
$status.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$form.Controls.Add($status)

$button.Add_Click({

    $selecionados = $checkboxes | Where-Object { $_.Checked }

    if ($selecionados.Count -eq 0) {

        [System.Windows.Forms.MessageBox]::Show("Selecione pelo menos um programa.")
        return
    }

    foreach ($item in $selecionados) {

        $status.Text = "Instalando: $($item.Text)"
        $form.Refresh()
        
       # OFFICE 2016
if ($item.Tag -eq "Office2016") {

    $officePath = "$env:TEMP\Office2016Deploy"

    if (!(Test-Path $officePath)) {
        New-Item -ItemType Directory -Path $officePath | Out-Null
    }

    $odtExe = "$officePath\officedeploymenttool.exe"
    $setupPath = "$officePath\setup.exe"
    $xmlPath = "$officePath\configuration.xml"

    Invoke-WebRequest `
        -Uri "https://download.microsoft.com/download/2/7/7/2771D5A5-68A0-4A2B-BD3F-9B6B0E6D5B8A/officedeploymenttool.exe" `
        -OutFile $odtExe

    Start-Process `
        -FilePath $odtExe `
        -ArgumentList "/extract:$officePath /quiet" `
        -Wait

  $xml = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="ProPlus2016Volume">
      <Language ID="pt-br" />
    </Product>
  </Add>

  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@

    $xml | Out-File -Encoding UTF8 $xmlPath

    Start-Process `
        -FilePath $setupPath `
        -ArgumentList "/download `"$xmlPath`"" `
        -Wait

    Start-Process `
        -FilePath $setupPath `
        -ArgumentList "/configure `"$xmlPath`"" `
        -Wait
}
        # DEMAIS PROGRAMAS
        else {

            winget install $item.Tag `
                --source winget `
                --silent `
                --accept-package-agreements `
                --accept-source-agreements
        }
    }

    $status.Text = "Instalação finalizada!"

    [System.Windows.Forms.MessageBox]::Show("Programas instalados com sucesso!")

    $form.Close()

    Stop-Process -Id $PID
})

$form.ShowDialog()
