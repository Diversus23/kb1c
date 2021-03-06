///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ТРАНСЛЯЦИИ СООБЩЕНИЙ КОНТРОЛЯ ДОПОЛНИТЕЛЬНЫХ ОТЧЕТОВ И ОБРАБОТОК
//  ИЗ ВЕРСИИ 1.0.1.1 В ВЕРСИЮ 1.0.2.4 СООБЩЕНИЙ КОНТРОЛЯ УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает номер версии, для трансляции с которой предназначен обработчик
Функция ИсходнаяВерсия() Экспорт
	
	Возврат "1.0.1.1";
	
КонецФункции

// Возвращает пространство имен версии, для трансляции с которой предназначен обработчик
Функция ПакетИсходнойВерсии() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Control/" + ИсходнаяВерсия();
	
КонецФункции

// Возвращает номер версии, для трансляции в которую предназначен обработчик
Функция РезультирующаяВерсия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает пространство имен версии, для трансляции в которую предназначен обработчик
Функция ПакетРезультирующейВерсии() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/RemoteAdministration/Control/1.0.2.4";
	
КонецФункции

// Обработчик проверки выполнения стандартной обработки трансляции
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO, транслируемое сообщение,
//  СтандартнаяОбработка - Булево, для отмены выполнения стандартной обработки трансляции
//    этому параметру внутри данной процедуры необходимо установить значение Ложь.
//    При этом вместо выполнения стандартной обработки трансляции будет вызвана функция
//    ТрансляцияСообщения() обработчика трансляции.
//
Процедура ПередТрансляцией(Знач ИсходноеСообщение, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Обработчик выполнения произвольной трансляции сообщения. Вызывается только в том случае,
//  если при выполнении процедуры ПередТрансляцией значению параметра СтандартнаяОбработка
//  было установлено значение Ложь.
//
// Параметры:
//  ИсходноеСообщение - ОбъектXDTO, транслируемое сообщение.
//
// Возвращаемое значение:
//  ОбъектXDTO, результат произвольной трансляции сообщения.
//
Функция ТрансляцияСообщения(Знач ИсходноеСообщение) Экспорт
	
	
	
КонецФункции






