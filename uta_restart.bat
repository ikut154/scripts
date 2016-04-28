rem Перезапуск УТА
net stop UTAService
ping -n 10 127.0.0.1 > NUL
net start UTAService