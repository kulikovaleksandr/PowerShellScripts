<# Скрипт написан для удобного подключения к консольному порту устройств, используя адаптер USB-COM (RS232)

Скрипт после запуска в течение 5 секунд ожидает подключение кабеля COM-USB, находит новое подключенное устройство сравнением списка COM-портов до подключения кабеля и после. С номером нового COM-порта запускает программу plink.exe с параметрами #>

# Путь до программы plink.exe
$plinkPath = "D:\Program Files\PuTTY\plink.exe"

Write-Host "Скрипт запущен. В течение 5 секунд подключите COM-порт"

# Запись в массив COM-устройств до подключения кабеля
$listOfSerialDevices1 = [System.IO.Ports.SerialPort]::getportnames()

# Пауза в 5 секунд на подключение COM-кабеля
Start-Sleep 5

# Запись во второй массив COM-устройств после подключения кабеля
$listOfSerialDevices2 = [System.IO.Ports.SerialPort]::getportnames()

# Проверка разницы массивов. Если есть новое устройств - подключение, если нет - вывод информации об этом
if (diff $listOfSerialDevices1 $listOfSerialDevices2)
	{

		# Сравнение двух массивов и запись значения строки в переменную, которой нет в одном из них
		$comPort = (Compare-Object -ReferenceObject $listOfSerialDevices1 -DifferenceObject $listOfSerialDevices2 | Select-Object InputObject | Format-Wide -Property InputObject | Out-String).Trim()
		
		Write-Host "COM-порт найден, устройство успешно подключено"
		Write-Host "Нажмите Enter"

		# Вывод строки для подключения в консоль, для пользователя
		Write-Host "&`"$plinkPath`" -serial $comPort -sercfg 9600,8,N,1,N"
		
		# Подключение к устройству
		&$plinkPath -serial $comPort -sercfg 9600,8,N,1,N

	} else
	{
		Write-Host "Новые COM-порты не обнаружены"
	}
