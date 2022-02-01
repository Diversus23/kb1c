////////////////////////////////////////////////////////////////////////////////
// Подсистема "Трансляция XDTO".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO, транслируемый объект,
//  РезультирующаяВерсия - строка, номер результирующей версии интерфейса, в формате РР.{П|ПП}.ЗЗ.СС
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВВерсию(Знач ИсходныйОбъект, Знач РезультирующаяВерсия, Знач ПакетИсходнойВерсии = "") Экспорт
	
	Если ПакетИсходнойВерсии = "" Тогда
		ПакетИсходнойВерсии = ИсходныйОбъект.Тип().URIПространстваИмен;
	КонецЕсли;
	
	ОписаниеИсходнойВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетИсходнойВерсии);
	ОписаниеРезультирующейВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		РезультирующаяВерсия);
	
	Возврат ТрансляцияXDTOСлужебный.ВыполнитьТрансляцию(
		ИсходныйОбъект,
		ОписаниеИсходнойВерсии,
		ОписаниеРезультирующейВерсии);
	
КонецФункции

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO, транслируемый объект,
//  РезультирующаяВерсия - строка, пространство имен результирующей версии,
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВПространствоИмен(Знач ИсходныйОбъект, Знач ПакетРезультирующейВерсии, Знач ПакетИсходнойВерсии = "") Экспорт
	
	Если ИсходныйОбъект.Тип().URIПространстваИмен = ПакетРезультирующейВерсии Тогда
		Возврат ИсходныйОбъект;
	КонецЕсли;
	
	Если ПакетИсходнойВерсии = "" Тогда
		ПакетИсходнойВерсии = ИсходныйОбъект.Тип().URIПространстваИмен;
	КонецЕсли;
	
	ОписаниеИсходнойВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетИсходнойВерсии);
	ОписаниеРезультирующейВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетРезультирующейВерсии);
	
	Возврат ТрансляцияXDTOСлужебный.ВыполнитьТрансляцию(
		ИсходныйОбъект,
		ОписаниеИсходнойВерсии,
		ОписаниеРезультирующейВерсии);
	
КонецФункции
