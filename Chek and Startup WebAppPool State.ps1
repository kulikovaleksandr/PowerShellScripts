#Присвоение переменной $poolstate значение состояние пула DirectumRxAppPool (остановлен или запущен)
$poolstate = (Get-WebAppPoolState -name DirectumRxAppPool | Format-Wide -Property Value | Out-String).Trim()

#Если пул DirectumRxAppPool остановлен или в состоянии Undefined
if (($poolstate -eq "Stopped") -or ($poolstate -eq "Undefined"))
    {
        #Запустить пул DirectumRxAppPool
        Start-WebAppPool -Name "DirectumRxAppPool"

        #Присвоение переменной $poolstate значение состояние пула DirectumRxAppPool (остановлен или запущен)
        $poolstate = (Get-WebAppPoolState -name DirectumRxAppPool | Format-Wide -Property Value | Out-String).Trim()

       #Если пул DirectumRxAppPool запустился
        if ($poolstate -eq "Started")
            {       
        #Запись в файл о выполнении скрипта, времени и состоянии пула
        $(Get-Date -uformat ‘%D %T’) +  " Скрипт выполнен, пул запущен. Состояние пула DirectumRxAppPool: " + $poolstate | Out-File "C:\Log_tasks_Проверка_состояние_пула_DirectumRxAppPool.txt" -append
            }
            else
            {
        $(Get-Date -uformat ‘%D %T’) +  " Скрипт выполнен, пул не запущен. Состояние пула DirectumRxAppPool: " + $poolstate | Out-File "C:\Log_tasks_Проверка_состояние_пула_DirectumRxAppPool.txt" -append
            }
        
    }
    # Если пул запущен
    else
    {
            $(Get-Date -uformat ‘%D %T’) +  " Скрипт запуска не выполнен. Состояние пула DirectumRxAppPool: " + $poolstate | Out-File "C:\Log_tasks_Проверка_состояние_пула_DirectumRxAppPool.txt" -append
    }
