# Путь логов
$LogFilePath = "C:\Logs\Delete_noactive_users\$(Get-Date -Format "dd_MM_yyyy").txt"

# Создание каталога для логов
if (!(Test-Path C:\Logs\Delete_noactive_users\))
    {mkdir C:\Logs\Delete_noactive_users\}

# Переменная указания количества дней неактивности учетной записи 
$LastLogonDate = (Get-Date).AddDays(-90)

# Запись в лог
Write-Output "$(Get-Date -Format HH:mm) Start script execution`n" >> $LogFilePath

# Получение списка неактивных пользователей, с получением поля EmailAddress, Department
$OldUsers = Get-ADUser -Properties EmailAddress, Department,  LastLogonTimeStamp -Filter {LastLogonTimeStamp -lt $LastLogonDate }  -SearchBase ‘OU=Domain Users,DC=corp,DC=ruspolymet,DC=ru’| ?{$_.Enabled –eq $True} | Sort-Object LastLogonTimeStamp

# Запись в лог
Write-Output "Users to be deleted: " >> $LogFilePath 

# Проверка каждого объекта в переменной $OldUsers, что поля EmailAddress и Department не пустые, т. е. учетная запись не сервисная
# При обоих условиях с -ne найдется сервисная учетная запись 'idecosvc'
foreach ($OldUsers in $OldUsers) {
    if ( ($OldUsers.Department -eq 'True') -and ($OldUsers.EmailAddress -eq 'True') )
    {
        $OldUsers >> $LogFilePath 
        # Добавить удаление пользователя
        
    }
} 

# Запись в лог
Write-Output "$(Get-Date -Format HH:mm) End script execution" >> $LogFilePath 