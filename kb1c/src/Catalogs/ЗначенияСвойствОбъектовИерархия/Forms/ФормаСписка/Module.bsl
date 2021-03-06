
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		КлючСохраненияПоложенияОкна = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Свойство = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Свойство) Тогда
		Элементы.Свойство.Видимость = Истина;
		НастроитьПорядокЗначенийПоСвойствам(Список);
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	УстановитьЗаголовок();
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения"
	   И Источник = Свойство Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПриИзмененииСвойства", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СвойствоПриИзменении(Элемент)
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование
	   И Элементы.Список.Отображение = ОтображениеТаблицы.Список Тогда
		
		Родитель = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура НастроитьПорядокЗначенийПоСвойствам(Список)
	
	Перем Порядок;
	
	// Порядок.
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
		Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	Иначе
		Порядок = Список.Порядок;
	КонецЕсли;
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	СтрокаЗаголовка = "";
	
	Если ЗначениеЗаполнено(Свойство) Тогда
		СтрокаЗаголовка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Свойство, "ЗаголовокФормыВыбораЗначения");
	КонецЕсли;
	
	Если ПустаяСтрока(СтрокаЗаголовка) Тогда
		
		Если ЗначениеЗаполнено(Свойство) Тогда
			Если НЕ Параметры.РежимВыбора Тогда
				СтрокаЗаголовка = НСтр("ru = 'Значения свойства %1'");
			Иначе
				СтрокаЗаголовка = НСтр("ru = 'Выберите значение свойства %1'");
			КонецЕсли;
			
			СтрокаЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СтрокаЗаголовка, Строка(Свойство));
		
		ИначеЕсли Параметры.РежимВыбора Тогда
			СтрокаЗаголовка = НСтр("ru = 'Выберите значение свойства'");
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтрокаЗаголовка) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтрокаЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПриИзмененииСвойства()
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСвойства()
	
	Если ЗначениеЗаполнено(Свойство) Тогда
		
		ВладелецДополнительныхЗначений = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
			Свойство, "ВладелецДополнительныхЗначений");
		
		Если ЗначениеЗаполнено(ВладелецДополнительныхЗначений) Тогда
			ТолькоПросмотр = Истина;
			
			ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ВладелецДополнительныхЗначений, "ТипЗначения");
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Владелец", ВладелецДополнительныхЗначений);
			
			ДополнительныеЗначенияСВесом = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
				ВладелецДополнительныхЗначений, "ДополнительныеЗначенияСВесом");
		Иначе
			ТолькоПросмотр = Ложь;
			ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Свойство, "ТипЗначения");
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Владелец", Свойство);
			
			ДополнительныеЗначенияСВесом = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
				Свойство, "ДополнительныеЗначенияСВесом");
		КонецЕсли;
		
		Если ТипЗнч(ТипЗначения) = Тип("ОписаниеТипов")
		   И ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
			
			Элементы.Список.ИзменятьСоставСтрок = Истина;
		Иначе
			Элементы.Список.ИзменятьСоставСтрок = Ложь;
		КонецЕсли;
		
		Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;
		Элементы.Владелец.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, "Владелец");
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Элементы.Список.ИзменятьСоставСтрок = Ложь;
		Элементы.Владелец.Видимость = Истина;
		Элементы.Список.Шапка = Истина;
	КонецЕсли;
	
КонецПроцедуры
