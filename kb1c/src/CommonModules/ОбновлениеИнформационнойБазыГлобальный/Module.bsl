////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Проверяет статус отложенного обновления. Если обновление завершилось
// с ошибками - информирует об этом пользователя и администратора.
//
Процедура ПроверитьСтатусОтложенногоОбновления() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если ПараметрыРаботыКлиента.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбновлениеИнформационнойБазыВызовСервера.ЕстьНеВыполненныеОбработчики() <> "" Тогда
		
		Если ПараметрыРаботыКлиента.ЭтоПолноправныйПользователь Тогда
			
			Если ОбновлениеИнформационнойБазыВызовСервера.ЕстьНеВыполненныеОбработчики() = "СтатусОшибка" Тогда
				ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
			Иначе
				ОбновлениеИнформационнойБазыКлиент.ОповеститьОтложенныеОбработчикиНеВыполнены();
			КонецЕсли;
			
		Иначе
			ОбновлениеИнформационнойБазыКлиент.ОповеститьОтложенныеОбработчикиНеВыполнены();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
