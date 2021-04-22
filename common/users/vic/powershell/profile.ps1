if (Get-InstalledModule -Name posh-git) {
    Import-Module posh-git
} 
else {
    Install-Module posh-git -Scope CurrentUser -Force -Repository PSGallery
    Import-Module posh-git
}

$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Orange
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'

function global:PromptWriteErrorInfo() {
    if ($global:GitPromptValues.DollarQuestion) { return }

    if ($global:GitPromptValues.LastExitCode) {
        "`e[31m(" + $global:GitPromptValues.LastExitCode + ") `e[0m"
    }
    else {
        "`e[31m! `e[0m"
    }
}

$global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$(PromptWriteErrorInfo)'
