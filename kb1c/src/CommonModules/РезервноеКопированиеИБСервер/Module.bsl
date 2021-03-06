////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииСпискаПредупрежденийЗавершенияРаботы"].Добавить(
			"РезервноеКопированиеИБКлиент");
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы"].Добавить(
			"РезервноеКопированиеИБКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении"].Добавить(
		"РезервноеКопированиеИБСервер");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске"].Добавить(
		"РезервноеКопированиеИБСервер");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем"].Добавить(
		"РезервноеКопированиеИБСервер");
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает параметры подсистемы РезервногоКопированияИБ, которые необходимы при завершении работы
// пользователей.
//
// Возвращаемое значение:
//	Структура - параметры.
//
Функция ПолучитьПараметрыПриЗавершенииРаботы()
	
	НастройкиРезервногоКопирования                   = ПолучитьНастройкиРезервногоКопирования();
	ПроводитьРезервноеКопированиеПриЗавершенииРаботы = ?(НастройкиРезервногоКопирования = Неопределено, НастройкиРезервногоКопирования, НастройкиРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы);
	
	ПараметрыПриЗавершении          = Новый Структура;
	ПараметрыПриЗавершении.Вставить("КоличествоАктивныхПользователей",                  ПолучитьКоличествоАктивныхПользователей(Истина));
	ПараметрыПриЗавершении.Вставить("ДоступностьРолейОповещения",                       ПолучитьДоступностьРолейОповещения());
	ПараметрыПриЗавершении.Вставить("ПроводитьРезервноеКопированиеПриЗавершенииРаботы", ПроводитьРезервноеКопированиеПриЗавершенииРаботы);
	
	Возврат ПараметрыПриЗавершении;
	
КонецФункции

// Возвращает коэффициент, позволяющий вычислить количество секунд в каждом интервале.
//
// Параметры:
//	ТипПериодаСтрока - Строка - имя интервала.
//
// Возвращаемое значение - Число - количество секунд интервала.
//
Функция ПолучитьВременнойПараметрПоСтроке(ТипПериодаСтрока) Экспорт
	Если ТипПериодаСтрока = "Минута" Тогда 
		Возврат 60; 
	ИначеЕсли ТипПериодаСтрока = "Час" Тогда
		Возврат 3600;
	ИначеЕсли ТипПериодаСтрока = "День" Тогда 
		Возврат 3600 * 24;
	ИначеЕсли ТипПериодаСтрока = "Неделя" Тогда
		Возврат 3600 * 24 * 7; 
	КонецЕсли;
КонецФункции

// Возвращает значение периода по заданному интервалу времени.
//
// Параметры:
//	ИнтервалВремени - Число - интервал времени в секундах.
//	
// Возвращаемое значение - Структура с полями:
//	ТипПериода - Строка - тип периода: День, Неделя, Месяц, Год.
//	ЗначениеПериода - Число - длина периода для заданного типа.
//
Функция ПолучитьПоИнтервалуВремениЗначениеПериода(ИнтервалВремени) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура("ТипПериода, ЗначениеПериода", "Месяц", 1);
	
	Если ИнтервалВремени = Неопределено Тогда 
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;	
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 365)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Год";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 365);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 30)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Месяц";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 30);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 7)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Неделя";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 7);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "День";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Возвращает сохраненные параметры резервного копирования.
//
// Возвращаемое значение - Структура - параметры резервного копирования.
//
Функция ПолучитьПараметрыРезервногоКопирования() Экспорт
	
	Параметры = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыРезервногоКопирования");
	Если Параметры = Неопределено ИЛИ Не Параметры.Свойство("ОтложенноеРезервноеКопирование") Тогда
		Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования();
	Иначе
		ПривестиПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	Возврат Параметры;
	
КонецФункции

// Приводит параметры резервного копирования.
// Если в текущих параметрах резервного копирования нет параметра, который есть в 
// функции "НачальноеЗаполнениеНастроекРезервногоКопирования", то он добавляется со значением по умолчанию.
//
// Параметры:
//	ПараметрыРезервногоКопирования - Структура - параметры резервного копирования ИБ.
//
Процедура ПривестиПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования)
	
	ПараметрыИзменены = Ложь;
	
	Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования(Ложь);
	Для Каждого ЭлементСтруктуры Из Параметры Цикл
		НайденноеЗначение = Неопределено;
		Если ПараметрыРезервногоКопирования.Свойство(ЭлементСтруктуры.Ключ, НайденноеЗначение) Тогда
			Если НайденноеЗначение = Неопределено И ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		Иначе
			Если ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПараметрыИзменены Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Сохраняет параметры резервного копирования.
//
// Параметры:
//	СтруктураПараметров - Структура - параметры резервного копирования.
//
Процедура УстановитьПараметрыРезервногоКопирования(СтруктураПараметров) Экспорт
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПараметрыРезервногоКопирования", , СтруктураПараметров);
КонецПроцедуры

// Проверяет, не настало ли время проводить автоматическое резервное копирование.
//
// Возвращаемое значение:
//   Булево - Истина, если настал момент проведения резервного копирования.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования() Экспорт
	
	Параметры = ПолучитьПараметрыРезервногоКопирования();
	Если Параметры = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Расписание = Параметры.РасписаниеКопирования;
	Если Расписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроцессВыполняется") Тогда 
		Если Параметры.ПроцессВыполняется Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ДатаПроверки = ТекущаяДатаСеанса();
	Если Параметры.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаНачалаПроверки = Параметры.ДатаПоследнегоРезервногоКопирования;
	РасписаниеЗначение = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ДатаНачалаПроверки);
	
КонецФункции

// Формирует даты ближайшего следующего автоматического резервного копирования в соответствии с расписанием.
//
// Параметры:
//	НачальнаяНастройка - Булево - признак начальной настройки.
//
Функция СформироватьДатыСледующегоАвтоматическогоКопирования(НачальнаяНастройка = Ложь) Экспорт
	
	Результат = Новый Структура;
	
	НастройкиРезервногоКопирования = ПолучитьНастройкиРезервногоКопирования();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Если НачальнаяНастройка Тогда
		Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", ТекущаяДата);
		Результат.Вставить("ДатаПоследнегоРезервногоКопирования", ТекущаяДата);
	Иначе
		РасписаниеКопирования = НастройкиРезервногоКопирования.РасписаниеКопирования;
		ПериодПовтораВТечениеДня = РасписаниеКопирования.ПериодПовтораВТечениеДня;
		ПериодПовтораДней = РасписаниеКопирования.ПериодПовтораДней;
		
		Если ПериодПовтораВТечениеДня <> 0 Тогда
			Значение = ТекущаяДата + ПериодПовтораВТечениеДня;
		ИначеЕсли ПериодПовтораДней <> 0 Тогда
			Значение = ТекущаяДата + ПериодПовтораДней * ПолучитьВременнойПараметрПоСтроке("День");
		Иначе
			Значение = НачалоДня(КонецДня(ТекущаяДата) + 1);
		КонецЕсли;
		Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", Значение);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НастройкиРезервногоКопирования, Результат);
	УстановитьПараметрыРезервногоКопирования(НастройкиРезервногоКопирования);
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение настройки "Статус резервного копирования" в части результата.
// Используется при начале работы системы для показа формы с результатами резервного копирования.
//
Процедура УстановитьРезультатРезервногоКопирования() Экспорт
	СтруктураПараметров = ПолучитьНастройкиРезервногоКопирования();
	СтруктураПараметров.ПроведеноКопирование = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
КонецПроцедуры

// Устанавливает значение настройки "ДатаПоследнегоРезервногоКопирования".
//
// Параметры: 
//   ДатаКопирования - дата и время последнего резервного копирования.
//
Процедура УстановитьДатуПоследнегоКопирования(ДатаКопирования) Экспорт
	СтруктураПараметров = ПолучитьПараметрыРезервногоКопирования();
	СтруктураПараметров.ДатаПоследнегоРезервногоКопирования = ДатаКопирования;
	УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
КонецПроцедуры

// Возвращает количество работающих с ИБ пользователей.
//
// Параметры: 
//	ТолькоАдминистраторы - Булево - признак того, что учитываются только работающие пользователи с административными правами.
//
// Возвращаемое значение - Число - количество работающих пользователей.
//
Функция ПолучитьКоличествоАктивныхПользователей(ТолькоАдминистраторы = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СеансыИнформационнойБазы  = ПолучитьСеансыИнформационнойБазы();
	Если Не ТолькоАдминистраторы Тогда
		Возврат СеансыИнформационнойБазы.Количество();
	КонецЕсли;
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0 Тогда
		Возврат 1;
	КонецЕсли;
	
	КоличествоАдминистраторов = 0;
	Для Каждого Сеанс Из СеансыИнформационнойБазы Цикл
		
		Если Сеанс.Пользователь = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Сеанс.ИмяПриложения = "Designer" Тогда
			Продолжить;
		КонецЕсли;
		
		Если Сеанс.Пользователь.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
			КоличествоАдминистраторов = КоличествоАдминистраторов + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоличествоАдминистраторов;
	
КонецФункции

// Устанавливает дату последнего оповещения пользователя.
//
// Параметры: 
//	ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	ПараметрыОповещений = ПолучитьПараметрыРезервногоКопирования();
	ПараметрыОповещений.ДатаПоследнегоОповещения = ДатаНапоминания;
	УстановитьПараметрыРезервногоКопирования(ПараметрыОповещений);
КонецПроцедуры

// Устанавливает настройку в параметры резервного копирования. 
// 
// Параметры: 
//	ИмяЭлемента - Строка - имя параметра.
// 	ЗначениеЭлемента - Произвольный тип - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	СтруктураНастроек = ПолучитьПараметрыРезервногоКопирования();
	СтруктураНастроек.Вставить(ИмяЭлемента, ЗначениеЭлемента);
	УстановитьПараметрыРезервногоКопирования(СтруктураНастроек);
КонецПроцедуры

// Возвращает структуру с параметрами для работы приложения.
// 
// Параметры: 
//	НаКлиент - Булево - признак передачи параметров на клиент.
//
// Возвращаемое значение - Структура - параметры резервного копирования.
//
Функция ПолучитьНастройкиРезервногоКопирования(НачалоРаботы = Ложь) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено; // Не выполнен вход в область данных.
	КонецЕсли;
	
	Если Не ПолучитьДоступностьРолейОповещения() Тогда
		Возврат Неопределено; // Текущий пользователь не обладает необходимыми правами.
	КонецЕсли;
	
	СтруктураВозврата = ПолучитьПараметрыРезервногоКопирования();
	Если Не СтруктураВозврата.Свойство("ПервыйЗапуск") Тогда
		СтруктураВозврата.Вставить("ПервыйЗапуск", Истина);
	КонецЕсли;
	
	ВариантОповещения = ПолучитьВариантОповещения();
	Если ВариантОповещения = "Просрочено" Или ВариантОповещения = "Напомнить" Или ВариантОповещения = "ЕщеНеНастроено" Тогда
		УстановитьДатуПоследнегоНапоминания(ТекущаяДатаСеанса());
	КонецЕсли;
	
	СтруктураВозврата.Вставить("ПараметрОповещения", ВариантОповещения);
	Если СтруктураВозврата.ПроведеноКопирование И СтруктураВозврата.РезультатКопирования  Тогда
		УстановитьДатуПоследнегоКопирования(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если СтруктураВозврата.ПроведеноВосстановление Тогда
		ОбновитьРезультатВосстановления();
	КонецЕсли;
	
	Если НачалоРаботы И СтруктураВозврата.ПроцессВыполняется Тогда
		СтруктураВозврата.ПроцессВыполняется = Ложь;
		УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Обновляет результат восстановления и обновляет структуру параметров резервного копирования. 
//
Процедура ОбновитьРезультатВосстановления()
	СтруктураВозврата = ПолучитьПараметрыРезервногоКопирования();
	СтруктураВозврата.ПроведеноВосстановление = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураВозврата);
КонецПроцедуры

// Выбирает, какой вариант оповещения показать пользователю.
// Вызывается из формы помощника резервного копирования для определения стартовой формы.
//
// Возвращаемое значение: 
//   Строка:
//     "Недоступно" - автоматическое резервное копирование недоступно текущему пользователю.
//     "Просрочено" - просрочено автоматическое резервное копирование.
//     "Напомнить" - необходимо сделать напоминание о резервном копировании.
//     "ЕщеНеНастроено" - резервное копирование еще не настроено.
//     "НеОповещать" - не оповещать о необходимости выполнения резервного копирования (например, если выполняется сторонними средствами)
//
Функция ПолучитьВариантОповещения() Экспорт
	Результат = "Недоступно";
	Если Не ПолучитьДоступностьРолейОповещения() Тогда
		Возврат Результат;
	КонецЕсли;
	ПараметрыОповещенияОКопировании = ПолучитьПараметрыРезервногоКопирования();
	Если ПараметрыОповещенияОКопировании.ВыборПунктаНастройки = 2 Тогда 
		Результат = "НеОповещать";
		Возврат Результат;
	КонецЕсли;
	ОповещатьОНеобходимостиРезервногоКопирования = ?((ТекущаяДатаСеанса() >= (ПараметрыОповещенияОКопировании.ДатаПоследнегоОповещения + 
		?(ПараметрыОповещенияОКопировании.ПериодОповещения = Неопределено, 0, ПараметрыОповещенияОКопировании.ПериодОповещения)) 
		И ПараметрыОповещенияОКопировании.ПериодОповещения > 0), Истина, Ложь);
	
	Если ПараметрыОповещенияОКопировании.НастроеноПользователем Тогда
		Если НеобходимостьАвтоматическогоРезервногоКопирования() Тогда
			Результат = "Просрочено";
		ИначеЕсли ОповещатьОНеобходимостиРезервногоКопирования Тогда
			Результат = "Напомнить";
		КонецЕсли;
	Иначе
		Если ОповещатьОНеобходимостиРезервногоКопирования Тогда
			Результат = "ЕщеНеНастроено";  
		КонецЕсли;		
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает начальное заполнение настроек автоматического резервного копирования.
//
// Параметры:
//	СохранятьПараметры - сохранять или нет параметры в хранилище настроек.
//
// Возвращаемое значение - Структура - начальное заполнение параметров резервного копирования.
//
Функция НачальноеЗаполнениеНастроекРезервногоКопирования(СохранятьПараметры = Истина) Экспорт
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Параметры = Новый Структура;
	Параметры.Вставить("ПериодОповещения", 24*3600); // раз в сутки
	Параметры.Вставить("ДатаПоследнегоОповещения", ТекущаяДата);
	Параметры.Вставить("НастроеноПользователем", Ложь);
	Параметры.Вставить("ДатаПоследнегоРезервногоКопирования", ТекущаяДата);
	Параметры.Вставить("РасписаниеКопирования", ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Новый РасписаниеРегламентногоЗадания));
	Параметры.Вставить("КаталогХраненияРезервныхКопий", "");
	Параметры.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", '29990101');
	Параметры.Вставить("ПроизводитьУдаление", Истина);
	Параметры.Вставить("УдалятьПоПериоду",  Истина);
	Параметры.Вставить("ЗначениеПараметра", ДобавитьМесяц(ТекущаяДата, 6) - ТекущаяДата);
	Параметры.Вставить("ПроведеноКопирование", Ложь);
	Параметры.Вставить("ПроведеноВосстановление", Ложь);
	Параметры.Вставить("РезультатКопирования", Неопределено);
	Параметры.Вставить("ИмяФайлаРезервнойКопии", "");
	Параметры.Вставить("ВыборПунктаНастройки", 3);
	Параметры.Вставить("ПроводитьРезервноеКопированиеПриЗавершенииРаботы", Ложь);
	Параметры.Вставить("ПервыйЗапуск", Истина);
	Параметры.Вставить("ПроцессВыполняется", Ложь);
	Параметры.Вставить("АдминистраторИБ", "");
	Параметры.Вставить("ПарольАдминистратораИБ", "");
	
	// Параметры обработчиков ожидания.
	Параметры.Вставить("ЕжечасноеОповещение", Ложь);
	Параметры.Вставить("АвтоматическоеРезервноеКопирование", Ложь);
	Параметры.Вставить("ОтложенноеРезервноеКопирование", Ложь);
	
	Если СохранятьПараметры Тогда
		УстановитьПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Возвращает признак наличия у пользователя полных прав.
//
// Возвращаемое значение - Булево - Истина, если это полноправный пользователь.
//
Функция ПолучитьДоступностьРолейОповещения() Экспорт
	Возврат Пользователи.ЭтоПолноправныйПользователь(,Истина);
КонецФункции

// Процедура, вызываемая из скрипта через com-соединение.
// Записывает результат проведенного копирования в настройки.
// 
// Параметры:
//	Результат - Булево - результат копирования.
//	ИмяФайлаРезервнойКопии - Строка - имя файла резервной копии.
//
Процедура ЗавершитьРезервноеКопирование(Результат, ИмяФайлаРезервнойКопии =  "") Экспорт
	СтруктураРезультата = ПолучитьНастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноКопирование = Истина;
	СтруктураРезультата.РезультатКопирования = Результат;
	СтруктураРезультата.ИмяФайлаРезервнойКопии = ИмяФайлаРезервнойКопии;
	СтруктураРезультата.ПервыйЗапуск = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
КонецПроцедуры

// Вызывается из скрипта через com-соединение для
// записи результата проведенного восстановления ИБ в настройки.
//
// Параметры:
//	Результат - Булево - результат восстановления.
//
Процедура ЗавершитьВосстановление(Результат) Экспорт
	СтруктураРезультата = ПолучитьНастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноВосстановление = Истина;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
КонецПроцедуры

// Возвращает текущую настройку резервного копирования строкой
// Два варианта использования функции - или с передачей всех параметров или без параметров
//
Функция ТекущаяНастройкаРезервногоКопирования(КодНастройки = Неопределено,
	ПриЗавершенииРаботы = Неопределено, Расписание = Неопределено) Экспорт
	
	Если КодНастройки = Неопределено Тогда
		НастройкиРезервногоКопирования = ПолучитьНастройкиРезервногоКопирования();
		КодНастройки = НастройкиРезервногоКопирования.ВыборПунктаНастройки;
		ПриЗавершенииРаботы = НастройкиРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы;
		Расписание = НастройкиРезервногоКопирования.РасписаниеКопирования;
	КонецЕсли;
	
	НадписьПоУмолчанию = НСтр("ru = 'Резервное копирование не настроено, информационная база подвергается риску потери данных.'");;
	
	Если КодНастройки = 3 Тогда
		ТекущаяНастройка = НадписьПоУмолчанию;
	ИначеЕсли КодНастройки = 2 Тогда
		ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано средствами СУБД или другими сторонними программами)'");
	Иначе
		Если ПриЗавершенииРаботы Тогда
			ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно при завершении работы.'");
		Иначе
			Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
			Если Не ПустаяСтрока(Расписание) Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно по расписанию:'") + " " + Строка(Расписание);
			Иначе
				ТекущаяНастройка = НадписьПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекущаяНастройка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Заполняет структуру параметров, необходимых для работы клиентского кода
// при завершении работы конфигурации, т.е. в обработчиках:
// - ПередЗавершениемРаботыСистемы,
// - ПриЗавершенииРаботыСистемы
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗавершении(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", ПолучитьПараметрыПриЗавершенииРаботы());
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", ПолучитьНастройкиРезервногоКопирования(Истина));
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", ПолучитьНастройкиРезервногоКопирования());
	
КонецПроцедуры
