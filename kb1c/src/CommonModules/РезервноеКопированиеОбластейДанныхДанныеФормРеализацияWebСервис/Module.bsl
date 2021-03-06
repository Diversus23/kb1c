////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование областей данных".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПараметрыФормыНастроек(Знач ОбластьДанных) Экспорт
	
	ИнформацияОбОшибке = Неопределено;
	Параметры = Прокси().GetSettingsFormParameters(
		ОбластьДанных,
		КлючОбласти(),
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Возврат СериализаторXDTO.ПрочитатьXDTO(Параметры);
	
КонецФункции

Функция ПолучитьНастройкиОбласти(Знач ОбластьДанных) Экспорт
	
	ИнформацияОбОшибке = Неопределено;
	Параметры = Прокси().GetZoneSettings(
		ОбластьДанных,
		КлючОбласти(),
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Возврат СериализаторXDTO.ПрочитатьXDTO(Параметры);
	
КонецФункции

Процедура УстановитьНастройкиОбласти(Знач ОбластьДанных, Знач НовыеНастройки, Знач ИсходныеНастройки) Экспорт
	
	ИнформацияОбОшибке = Неопределено;
	Прокси().SetZoneSettings(
		ОбластьДанных,
		КлючОбласти(),
		СериализаторXDTO.ЗаписатьXDTO(НовыеНастройки),
		СериализаторXDTO.ЗаписатьXDTO(ИсходныеНастройки),
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
КонецПроцедуры

Функция ПолучитьСтандартныеНастройки() Экспорт
	
	ИнформацияОбОшибке = Неопределено;
	Параметры = Прокси().GetDefaultSettings(
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Возврат СериализаторXDTO.ПрочитатьXDTO(Параметры);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция КлючОбласти()
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.КлючОбластиДанных.Получить();
	
КонецФункции

Функция Прокси()
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = Константы.ВнутреннийАдресМенеджераСервиса.Получить();
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'"));
	КонецЕсли;
	
	АдресСервиса = АдресМенеджераСервиса + "/ws/ZoneBackupControl_1_0_2_1?wsdl";
	ИмяПользователя = Константы.ИмяСлужебногоПользователяМенеджераСервиса.Получить();
	ПарольПользователя = Константы.ПарольСлужебногоПользователяМенеджераСервиса.Получить();
	
	Прокси = ОбщегоНазначения.WSПрокси(АдресСервиса, "http://www.1c.ru/1cFresh/ZoneBackupControl/1.0.2.1",
		"ZoneBackupControl_1_0_2_1", , ИмяПользователя, ПарольПользователя, 10);
		
	Возврат Прокси;
	
КонецФункции
