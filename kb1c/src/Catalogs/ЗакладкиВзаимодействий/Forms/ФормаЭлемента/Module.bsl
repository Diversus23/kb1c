
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
	Если Объект.Ссылка.Пустая() Тогда
		
		ИнициализироватьКомпоновщикСервер(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СохраненныйКомпоновщикНастроек = ТекущийОбъект.КомпоновщикНастроек.Получить();
	ИнициализироватьКомпоновщикСервер(СохраненныйКомпоновщикНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.КомпоновщикНастроек = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗакладкиВзаимодействий", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкаКомпоновки)
	
	СхемаКомпоновки = ЖурналыДокументов.Взаимодействия.ПолучитьМакет("СхемаОтборВзаимодействия");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

