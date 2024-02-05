# 1. Скрипт проверки в каталоге Рабочего стола пользователя наличия ярлыков на \\fs.kms

# Путь, где находятся рабочие столы пользователей
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)


# Адрес, который мы ищем в ярлыках
$targetAddress = "\\fs"

# Получаем список ярлыков на рабочих столах
$shortcuts = Get-ChildItem -Path $DesktopPath -Filter "*.lnk" -Recurse

# Перебираем каждый ярлык и удаляем те, которые содержат целевой адрес. Проверка с помощью двух условий: через параметр TargetPath объекта WScript и выводом содержимого ярлыка через cat
foreach ($shortcut in $shortcuts) {
    $shell = New-Object -ComObject WScript.Shell
    $link = $shell.CreateShortcut($shortcut.FullName)	
    if ( ($link.TargetPath -like "*$targetAddress*") -or
			(cat $link.FullName | Select-String '\\fs') )
	{
        Remove-Item -Path $shortcut.FullName -Force
    }
}