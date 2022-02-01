////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Записать настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
// Параметры:
//   Значение - Булево   - значение настройки.
// 
Процедура СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(Значение) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", Значение);
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
Функция ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если Параметры.ПервыйЗапросПараметров Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Количество() = 0 Тогда
		ПараметрыКлиента = Новый Соответствие;
		ПараметрыКлиента.Вставить("ПараметрЗапуска", Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы", Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске", ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент",    Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент", Параметры.ЭтоLinuxКлиент);
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если НЕ СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске");
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры);
	КонецЦикла;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = ОбщегоНазначенияВызовСервераПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске();
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	Параметры = Новый Структура;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры);
	КонецЦикла;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиента(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = ОбщегоНазначенияВызовСервераПереопределяемый.ПараметрыРаботыКлиента();
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиента(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// Возвращает тип платформы строкой.
Функция ТипПлатформыСервераСтрокой() Экспорт
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux_x86";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux_x86_64";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows_x86";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "Windows_x86_64";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Неизвестный тип платформы ""%1""'"),
		Строка(СистемнаяИнфо.ТипПлатформы));
	
КонецФункции

// Возвращает массив имен клиентских модулей.
Функция МассивИменКлиентскихМодулей() Экспорт
	
	КлиентскиеМодули = Новый Массив;
	
	Для каждого ОбщийМодуль Из Метаданные.ОбщиеМодули Цикл
		Если ОбщийМодуль.Глобальный Тогда
			Продолжить;
		КонецЕсли;
		Если ОбщийМодуль.КлиентУправляемоеПриложение Тогда
			КлиентскиеМодули.Добавить(ОбщийМодуль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат КлиентскиеМодули;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации при завершении работы.
//
Функция ПараметрыРаботыКлиентаПриЗавершении() Экспорт
	
	Параметры = Новый Структура();
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении(Параметры);
	КонецЦикла;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗавершении");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентаПриЗавершении(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = ОбщегоНазначенияВызовСервераПереопределяемый.ПараметрыРаботыКлиентаПриЗавершении();
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗавершении(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецФункции

// Только для внутреннего использования.
Процедура ПриОшибкеПолученияОбработчиковКлиентскогоСобытия() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 ИЛИ НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		Константы.ПараметрыСлужебныхСобытий.СоздатьМенеджерЗначения().Обновить();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(ОшибкаУстановкиМонопольногоРежима) Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Если ПравоДоступа("Администрирование", Метаданные, ТекущийПользователь) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.ЗагрузитьОбновитьПараметрыРаботыПрограммы(ОшибкаУстановкиМонопольногоРежима);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	Возврат СтандартныеПодсистемыПовтИсп.ПредопределенныйЭлемент(ПолноеИмяПредопределенного);
	
КонецФункции
