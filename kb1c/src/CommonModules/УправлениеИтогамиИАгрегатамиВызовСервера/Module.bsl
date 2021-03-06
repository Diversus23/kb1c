////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление итогами и агрегатами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Сдвиг границы рассчитанных итогов.
//
Процедура УстановкаПериодаРассчитанныхИтогов() Экспорт
	
	Если НЕ УправлениеИтогамиИАгрегатамиСлужебный.НадоСдвинутьГраницуИтогов() Тогда
		Возврат; // Период уже был установлен в сеансе другого пользователя.
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	УправлениеИтогамиИАгрегатамиСлужебный.УстановкаПериодаРассчитанныхИтогов();
	
КонецПроцедуры

