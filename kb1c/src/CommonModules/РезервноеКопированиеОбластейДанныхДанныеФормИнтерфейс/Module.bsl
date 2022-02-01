////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование областей данных".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПараметрыФормыНастроек(Знач ОбластьДанных) Экспорт
	
	Параметры = Реализация().ПолучитьПараметрыФормыНастроек(ОбластьДанных);
	Параметры.Вставить("ОбластьДанных", ОбластьДанных);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьНастройкиОбласти(Знач ОбластьДанных) Экспорт
	
	Возврат Реализация().ПолучитьНастройкиОбласти(ОбластьДанных);
	
КонецФункции

Процедура УстановитьНастройкиОбласти(Знач ОбластьДанных, Знач НовыеНастройки, Знач ИсходныеНастройки) Экспорт
	
	Реализация().УстановитьНастройкиОбласти(ОбластьДанных, НовыеНастройки, ИсходныеНастройки);
	
КонецПроцедуры

Функция ПолучитьСтандартныеНастройки() Экспорт
	
	Возврат Реализация().ПолучитьСтандартныеНастройки();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция Реализация()
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеОбластейДанныхМС") Тогда
		Возврат ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РезервноеКопированиеОбластейДанныхДанныеФормРеализацияИБ");
	Иначе
		Возврат ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РезервноеКопированиеОбластейДанныхДанныеФормРеализацияWebСервис");
	КонецЕсли;
	
КонецФункции