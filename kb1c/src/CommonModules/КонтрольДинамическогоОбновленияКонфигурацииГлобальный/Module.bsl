////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контроль динамического обновления конфигурации"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработчик ожидания проверяет, что информационная база была обновлена динамически, и 
// сообщает об этом пользователю.
//
Процедура ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ() Экспорт
	
	Если КонтрольДинамическогоОбновленияКонфигурации.КонфигурацияБДБылаИзмененаДинамически() Тогда
		
		ОтключитьОбработчикОжидания("ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ");
		
		ТекстСообщения = НСтр("ru = 'В конфигурацию информационной базы внесены изменения.
									|Для дальнейшей работы рекомендуется перезапустить программу.
									|Перезапустить?'");
		Ответ = Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
			ЗавершитьРаботуСистемы(Истина, Истина);
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ", 20 * 60); // раз в 20 минут
		
	КонецЕсли;
	
КонецПроцедуры
