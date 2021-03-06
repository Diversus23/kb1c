
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияЗаполнения = Новый Структура("УчетнаяЗаписьЭлектроннойПочты", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.ФормаЗаписи",
		Новый Структура("Ключ,ЗначенияЗаполнения", КлючЗаписи(ПараметрКоманды), ЗначенияЗаполнения),
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция КлючЗаписи(УчетнаяЗаписьЭлектроннойПочты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты
	|ИЗ
	|	РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты КАК НастройкиУчетныхЗаписейЭлектроннойПочты
	|ГДЕ
	|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты = &УчетнаяЗаписьЭлектроннойПочты";
	
	Запрос.УстановитьПараметр("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	ДанныеКлючаЗаписи = Новый Структура("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	ПараметрыКонструктора = Новый Массив();
	ПараметрыКонструктора.Добавить(ДанныеКлючаЗаписи);
	Возврат Новый("РегистрСведенийКлючЗаписи.НастройкиУчетныхЗаписейЭлектроннойПочты", ПараметрыКонструктора);
	
КонецФункции
