&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ЧасовойПоясПрограммы = ПолучитьЧасовойПоясИнформационнойБазы();
	Элементы.ЧасовойПоясПрограммы.СписокВыбора.Добавить(ЧасовойПоясПрограммы);
	
	// Настройки видимости при запуске
	
	// СтандартныеПодсистемы.ПолучениеФайловИзИнтернета
	Элементы.ГруппаОткрытьПараметрыПроксиСервера.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ПолучениеФайловИзИнтернета
	
	// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	Элементы.ГруппаПараметрыАдминистрированияИБ.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
	Элементы.ГруппаОткрытьНастройкиАгентаСервиса.Видимость = РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЗаголовокПрограммыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
КонецПроцедуры

&НаКлиенте
Процедура ЧасовойПоясПрограммыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЧасовойПоясПрограммыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Элемент.СписокВыбора.Количество() < 2 Тогда
		ЗагрузитьЧасовыеПояса();
	КонецЕсли;
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов
&НаКлиенте
Процедура ИспользоватьВерсионированиеОбъектовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ИспользоватьДополнительныеРеквизитыИСведенияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура КаталогВременныхФайловДляWindowsПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КаталогВременныхФайловДляLinuxПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ВерсионированиеОбъектов
&НаКлиенте
Процедура РегистрСведенийНастройкиВерсионированияОбъектов(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиВерсионированияОбъектов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ДополнительныеРеквизиты(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "НаборыДополнительныхРеквизитов");
	
	ОткрытьФорму(
		"Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка",
		ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСведения(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "НаборыДополнительныхСведений");
	
	ОткрытьФорму(
		"Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка",
		ПараметрыФормы);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПоказатьВремяТекущегоСеанса(Команда)
	
	Предупреждение(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Время сеанса: %1
				|На сервере: %2
				|На клиенте: %3
				|
				|Время сеанса - это время сервера,
				|приведенное к часовому поясу клиента.'"),
			Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДЛФ=T"),
			Формат(ДатаСервера(), "ДЛФ=T"),
			Формат(ТекущаяДата(), "ДЛФ=T")));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьЧасовыеПояса()
	
	Элементы.ЧасовойПоясПрограммы.СписокВыбора.ЗагрузитьЗначения(ПолучитьДопустимыеЧасовыеПояса());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаСервера()
	
	Возврат ТекущаяДата();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "ЧасовойПоясПрограммы" Тогда
		Если ЧасовойПоясПрограммы <> ПолучитьЧасовойПоясИнформационнойБазы() Тогда 
			УстановитьПривилегированныйРежим(Истина);
			Попытка
				ОбщегоНазначения.ЗаблокироватьИБ();
				УстановитьЧасовойПоясИнформационнойБазы(ЧасовойПоясПрограммы);
				ОбщегоНазначения.РазблокироватьИБ();
			Исключение
				ОбщегоНазначения.РазблокироватьИБ();
				ВызватьИсключение;
			КонецПопытки;
			УстановитьПривилегированныйРежим(Ложь);
			УстановитьЧасовойПоясСеанса(ЧасовойПоясПрограммы);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВерсионированиеОбъектов"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"РегистрСведенийНастройкиВерсионированияОбъектов",
			"Доступность",
			НаборКонстант.ИспользоватьВерсионированиеОбъектов);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаДополнительныеРеквизитыИСведенияПрочиеНастройки",
			"Доступность",
			НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаДополнительныеРеквизитыИлиСведения",
			"Доступность",
			НаборКонстант.ИспользоватьДополнительныеРеквизитыИСведения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
