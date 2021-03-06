////////////////////////////////////////////////////////////////////////////////
// Подсистема "Валюты"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Вызывается при запуске конфигурации, подключает обработчик ожидания.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	Параметры = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если Параметры.Свойство("Валюты") И Параметры.Валюты.КурсыОбновляютсяОтветственными Тогда
		ПодключитьОбработчикОжидания("РаботаСКурсамиВалютВывестиОповещениеОНеактуальности", 15, Истина);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обновление курсов валют

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыУстарели() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют устарели'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Обновить курсы валют'"),
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыУспешноОбновлены() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют успешно обновлены'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Курсы валют обновлены'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыАктуальны() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют уже обновлены'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Курсы валют актуальны'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Возвращает навигационную ссылку для оповещений.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.ЗагрузкаКурсовВалют";
КонецФункции
