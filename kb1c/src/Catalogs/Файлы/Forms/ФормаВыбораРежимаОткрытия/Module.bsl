////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БольшеНеСпрашивать = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеСпрашивать", БольшеНеСпрашивать);
	РезультатВыбора.Вставить("КакОткрывать", КакОткрывать);
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ОповеститьОВыборе(КодВозвратаДиалога.Отмена);
КонецПроцедуры
