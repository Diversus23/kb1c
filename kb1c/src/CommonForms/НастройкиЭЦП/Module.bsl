////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьНастройкиШифрования") И Параметры.ПоказыватьНастройкиШифрования = Ложь Тогда
		Элементы.АлгоритмШифрования.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоПодчиненныйУзел = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	
	Если ЭтоПодчиненныйУзел Тогда // мы в не главном узле
		Элементы.ПровайдерЭЦП.ТолькоПросмотр = Истина;
		Элементы.ТипПровайдераЭЦП.ТолькоПросмотр = Истина;
		Элементы.АлгоритмПодписи.ТолькоПросмотр = Истина;
		Элементы.АлгоритмХеширования.ТолькоПросмотр = Истина;
		Элементы.АлгоритмШифрования.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ВыполнятьПроверкуЭЦПНаСервере.Видимость = Ложь;
		Элементы.ПутиМодулейКриптографииСерверовLinux.Видимость = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПутиМодулейКриптографииСерверовLinux.ИмяКомпьютера,
	|	ПутиМодулейКриптографииСерверовLinux.ПутьМодуляКриптографии,
	|	ПутиМодулейКриптографииСерверовLinux.Комментарий
	|ИЗ
	|	РегистрСведений.ПутиМодулейКриптографииСерверовLinux КАК ПутиМодулейКриптографииСерверовLinux";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = ПутиМодулейКриптографииСерверовLinux.Добавить();
		
		Строка.ИмяКомпьютера = Выборка.ИмяКомпьютера;
		Строка.ПутьМодуляКриптографии = Выборка.ПутьМодуляКриптографии;
		Строка.Комментарий = Выборка.Комментарий;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьМодульКриптографии(Отказ);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(ПровайдерЭЦП) И НЕ СпискиАлгоритмовУспешноЗаполнены Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось подключить провайдера ЭП.
			|Укажите Провайдера и его Тип согласно инструкции фирмы-производителя криптопровайдера.'"),
			,
			"ТипПровайдераЭЦП");
	КонецЕсли;
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ПровайдерЭЦП) ИЛИ ЭтоПодчиненныйУзел Тогда
		
		ИсключаемыеРеквизиты.Добавить("АлгоритмПодписи");
		ИсключаемыеРеквизиты.Добавить("АлгоритмХеширования");
		ИсключаемыеРеквизиты.Добавить("АлгоритмШифрования");
		
	ИначеЕсли НЕ Элементы.АлгоритмШифрования.Видимость Тогда
		
		ИсключаемыеРеквизиты.Добавить("АлгоритмШифрования");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыполнятьПроверкуЭЦПНаСервереПриИзменении(Элемент)
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПровайдераЭЦППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭЦППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭЦПОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТипаПровайдера = "";
	Пока Прав(ВыбранноеЗначение, 1) <> "/" Цикл
		СтрокаТипаПровайдера = Прав(ВыбранноеЗначение, 1) + СтрокаТипаПровайдера;
		ВыбранноеЗначение = Лев(ВыбранноеЗначение, СтрДлина(ВыбранноеЗначение) - 1);
	КонецЦикла;
	ВыбранноеЗначение = Лев(ВыбранноеЗначение, СтрДлина(ВыбранноеЗначение) - 1);
	
	ТипПровайдераЭЦП = Число(СтрокаТипаПровайдера);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если НЕ СохранитьПараметры() Тогда
		Возврат;
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПодключитьМодульКриптографии(Отказ)
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		
		ЗаголовокВопроса = НСтр("ru = 'Расширение работы с криптографией'");
		
		ТекстВопроса = НСтр("ru = 'Для настройки ЭП необходимо установить
		|расширение работы с криптографией.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(1, НСтр("ru = 'Установить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Ответ = Вопрос(ТекстВопроса, Кнопки, 60, 1, ЗаголовокВопроса);
		
		Если Ответ <> 1 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УстановитьРасширениеРаботыСКриптографией();
		
		Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПерсональныеНастройкиРаботыСЭЦП =
		ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП();
	
	ЗаполнитьЗначенияСвойств(
		ЭтаФорма,
		ПерсональныеНастройкиРаботыСЭЦП,
		"ПровайдерЭЦП,
		|ТипПровайдераЭЦП,
		|АлгоритмПодписи,
		|АлгоритмХеширования,
		|АлгоритмШифрования,
		|ВыполнятьПроверкуЭЦПНаСервере");
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность                = ВыполнятьПроверкуЭЦПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	
	Если ТипПровайдераЭЦП = 0 Тогда
		ТипПровайдераЭЦП = 75;
	КонецЕсли;
	
	ДобавитьМенеджераКриптографииВСписок("Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Signal-COM CPGOST Cryptographic Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Infotecs Cryptographic Service Provider", "", 2);
	ДобавитьМенеджераКриптографииВСписок("Microsoft Enhanced Cryptographic Provider v1.0", "", 1);
	ДобавитьМенеджераКриптографииВСписок("Microsoft Strong Cryptographic Provider", "", 1);
	ДобавитьМенеджераКриптографииВСписок("", "", 75);
	
	Если Элементы.ПровайдерЭЦП.СписокВыбора.Количество() = 0 Тогда
		Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
			ИмяКнопки = "КнопкаВыпадающегоСписка";
		Иначе
			ИмяКнопки = "КнопкаСпискаВыбора";
		КонецЕсли;
		Элементы.ПровайдерЭЦП[ИмяКнопки] = Ложь;
		Элементы.ПровайдерЭЦП.КнопкаОчистки = Ложь;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНаКлиенте()
	
	ОчиститьСообщения();
	
	Элементы.АлгоритмПодписи.СписокВыбора.Очистить();
	Элементы.АлгоритмХеширования.СписокВыбора.Очистить();
	Элементы.АлгоритмШифрования.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(ПровайдерЭЦП) Тогда
		ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографии(ПровайдерЭЦП, Неопределено, ТипПровайдераЭЦП);
	Иначе
		ИнформацияМенеджера = Неопределено;
	КонецЕсли;
	
	Если ИнформацияМенеджера = Неопределено Тогда
		
		СпискиАлгоритмовУспешноЗаполнены = Ложь;
		
	Иначе
		
		СпискиАлгоритмовУспешноЗаполнены = Истина;
		
		АлгоритмПодписиНайден = Ложь;
		АлгоритмХешированияНайден = Ложь;
		АлгоритмШифрованияНайден = Ложь;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыПодписи Цикл
			Элементы.АлгоритмПодписи.СписокВыбора.Добавить(Строка);
			Если АлгоритмПодписи = Строка Тогда
				АлгоритмПодписиНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыХеширования Цикл
			Элементы.АлгоритмХеширования.СписокВыбора.Добавить(Строка);
			Если АлгоритмХеширования = Строка Тогда
				АлгоритмХешированияНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыШифрования Цикл
			Элементы.АлгоритмШифрования.СписокВыбора.Добавить(Строка);
			Если АлгоритмШифрования = Строка Тогда
				АлгоритмШифрованияНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ АлгоритмПодписиНайден Тогда
			АлгоритмПодписи = "";
		КонецЕсли;
			
		Если НЕ АлгоритмХешированияНайден Тогда
			АлгоритмХеширования = "";
		КонецЕсли;
		
		Если НЕ АлгоритмШифрованияНайден Тогда
			АлгоритмШифрования = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.АлгоритмПодписи.Доступность     = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмХеширования.Доступность = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмШифрования.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
	
КонецПроцедуры

&НаКлиенте
Функция СкомпоноватьИнформациюМенеджераКриптографии(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии,
	СообщатьОшибки = Истина)
	
	Если ПутьМодуляКриптографии = Неопределено Тогда
		ПутьМодуляКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ПутьМодуляКриптографии;
	КонецЕсли;
	
	ИнформацияМенеджера = Неопределено;
	
	Попытка
		
		МенеджерКриптографии = Новый МенеджерКриптографии(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии);
		ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		
	Исключение
		
		Если СообщатьОшибки Тогда
			ПредставлениеОшибки = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Если Прав(ПредставлениеОшибки, 1) <> "." Тогда
				ПредставлениеОшибки = ПредставлениеОшибки + ".";
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось подключить провайдера ЭП: %1
					|Укажите Провайдера и его Тип согласно инструкции фирмы-производителя криптопровайдера.'"),
					ПредставлениеОшибки
				),
				,
				"ТипПровайдераЭЦП");
		КонецЕсли;
		
	КонецПопытки;
	
	Если ИнформацияМенеджера <> Неопределено Тогда
		
		ЗначениеСпискаВыбора = ИнформацияМенеджера.Имя + "/" + ТипМодуляКриптографии;
		
		Если Элементы.ПровайдерЭЦП.СписокВыбора.НайтиПоЗначению(ЗначениеСпискаВыбора) = Неопределено Тогда
			Элементы.ПровайдерЭЦП.СписокВыбора.Добавить(ЗначениеСпискаВыбора, ИнформацияМенеджера.Имя);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИнформацияМенеджера;
КонецФункции

&НаКлиенте
Процедура ДобавитьМенеджераКриптографииВСписок(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии)
	
	ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографии(
		ИмяМодуляКриптографии,
		ПутьМодуляКриптографии,
		ТипМодуляКриптографии,
		Ложь);
	
КонецПроцедуры

&НаСервере
Функция СохранитьПараметры()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Константы.ПровайдерЭЦП.Установить(ПровайдерЭЦП);
	Константы.ТипПровайдераЭЦП.Установить(ТипПровайдераЭЦП);
	Константы.АлгоритмХеширования.Установить(АлгоритмХеширования);
	Константы.АлгоритмПодписи.Установить(АлгоритмПодписи);
	Константы.АлгоритмШифрования.Установить(АлгоритмШифрования);
	Константы.ВыполнятьПроверкуЭЦПНаСервере.Установить(ВыполнятьПроверкуЭЦПНаСервере);
	
	Для Каждого Строка Из ПутиМодулейКриптографииСерверовLinux Цикл
		НаборЗаписей = РегистрыСведений.ПутиМодулейКриптографииСерверовLinux.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ИмяКомпьютера.Установить(Строка.ИмяКомпьютера);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИмяКомпьютера = Строка.ИмяКомпьютера;
		НоваяЗапись.ПутьМодуляКриптографии = Строка.ПутьМодуляКриптографии;
		НоваяЗапись.Комментарий = Строка.Комментарий;
		
		НаборЗаписей.Записать();
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат Истина;
	
КонецФункции
