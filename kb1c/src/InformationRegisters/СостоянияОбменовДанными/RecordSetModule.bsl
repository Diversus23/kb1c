#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Запрещаем изменять набор записей для неразделенных узлов из разделенного режима
	ОбменДаннымиСервер.ВыполнитьКонтрольЗаписиНеразделенныхДанных(Отбор.УзелИнформационнойБазы.Значение);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
