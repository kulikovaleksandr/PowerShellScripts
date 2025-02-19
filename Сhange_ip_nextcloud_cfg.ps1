# Скрипт смены IP-адреса сервера для клиента Nextcloud. После смены адреса, пользователю надо будет авторизоваться 

# Путь конфигурационного файла в профиле пользователя
$nextcloudCfgPath = "$env:APPDATA\Nextcloud\nextcloud.cfg"

$nexctcloudProccess = Get-Process nextcloud -ErrorAction SilentlyContinue

if ($nexctcloudProccess)
    {
        # Запись пути Nextcloud
        $nextcloudPath = ps -name nextcloud | % {$_.Path}
        # Остановить Nextcloud
        Stop-Process -Name nextcloud
        # Замена адреса сервера в конфигурационном файле Nextcloud
        (Get-Content -path $nextcloudCfgPath) -replace '^0\\url=.*$','0\url=http://nc.zvmet.ru:7102' | Set-Content -path $nextcloudCfgPath
        # Запустить Nextcloud
        Start-Process $nextcloudPath
    }   
    else 
    {
        # Замена адреса сервера в конфигурационном файле Nextcloud
        (Get-Content -path $nextcloudCfgPath) -replace '^0\\url=.*$','0\url=http://nc.zvmet.ru:7102' | Set-Content -path $nextcloudCfgPath
        
        # Проверка наличия и запуск Nextcloud
        if (Test-Path "C:\Program Files\Nextcloud\nextcloud.exe")
            {Start-Process "C:\Program Files\Nextcloud\nextcloud.exe"}
        if (Test-Path "C:\Program Files (x86)\Nextcloud\nextcloud.exe")
            {Start-Process "C:\Program Files (x86)\Nextcloud\nextcloud.exe"}
    }


