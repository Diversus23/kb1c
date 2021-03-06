
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ВзаимодействияКлиентСервер.ЯвляетсяПредметом(ПараметрКоманды) Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Предмет", ПараметрКоманды);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТипВзаимодействия", "Предмет");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
		ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
		
	ИначеЕсли ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ПараметрКоманды) Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Предмет", ПараметрКоманды);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТипВзаимодействия", "Взаимодействие");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
		ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
		
	Иначе
		Возврат;
	КонецЕсли;

	ОткрытьФорму(
		"ЖурналДокументов.Взаимодействия.Форма.ФормаСпискаПараметрическая",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Источник.КлючУникальности,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
