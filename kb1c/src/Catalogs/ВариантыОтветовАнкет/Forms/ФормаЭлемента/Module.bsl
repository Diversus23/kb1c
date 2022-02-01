
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Владелец")
		И ТипЗнч(Параметры.Владелец) = Тип("ПланВидовХарактеристикСсылка.ВопросыДляАнкетирования")
		И НЕ Параметры.Владелец.Пустая() Тогда
				
				Объект.Владелец = Параметры.Владелец;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Данная форма предназначена для открытия только из формы элемента плана вида характеристик ""Вопросы для анкетирования""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ТипОтвета") Тогда
		Элементы.ТребуетОткрытогоОтвета.Видимость = (Параметры.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.НесколькоВариантовИз);
	Иначе
		Элементы.ТребуетОткрытогоОтвета.Видимость = (Объект.Владелец.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.НесколькоВариантовИз);
	КонецЕсли;
	
КонецПроцедуры
