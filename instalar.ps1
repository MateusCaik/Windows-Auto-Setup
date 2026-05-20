# Atualizar winget
winget source reset --force
winget source update

# Atualizar App Installer
winget upgrade Microsoft.AppInstaller --source winget --silent --accept-package-agreements --accept-source-agreements

# Instalar programas
winget install Google.Chrome --source winget --silent --accept-package-agreements --accept-source-agreements

winget install Mozilla.Firefox --source winget --silent --accept-package-agreements --accept-source-agreements

winget install Oracle.JavaRuntimeEnvironment --source winget --silent --accept-package-agreements --accept-source-agreements

winget install RARLab.WinRAR --source winget --silent --accept-package-agreements --accept-source-agreements

winget install Microsoft.Office --source winget --silent --accept-package-agreements --accept-source-agreements
