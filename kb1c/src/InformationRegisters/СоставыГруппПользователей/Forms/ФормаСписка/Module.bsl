////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеРегистра(Команда)
	
	ЕстьИзменения = Ложь;
	
	ОбновитьДанныеРегистраНаСервере(ЕстьИзменения);
	
	Если ЕстьИзменения Тогда
		Текст = НСтр("ru = 'Обновление выполнено успешно.'");
	Иначе
		Текст = НСтр("ru = 'Обновление не требуется.'");
	КонецЕсли;
	
	Предупреждение(Текст);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьДанныеРегистраНаСервере(ЕстьИзменения)
	
	РегистрыСведений.СоставыГруппПользователей.ОбновитьДанныеРегистра(ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
