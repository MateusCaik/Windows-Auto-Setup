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
    @{ Nome = "Microsoft Office"; Id = "Microsoft.Office" }
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

        winget install $item.Tag --source winget --silent --accept-package-agreements --accept-source-agreements
    }

    $status.Text = "Instalação finalizada!"
    [System.Windows.Forms.MessageBox]::Show("Programas instalados com sucesso!")

$form.Close()

Stop-Process -Id $PID

})

$form.ShowDialog()
