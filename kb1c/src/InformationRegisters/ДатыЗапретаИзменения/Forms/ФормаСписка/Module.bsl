
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПредставлениеТиповПлановОбмена = "";
	ПредставлениеУзловПлановОбмена = "";
	Для каждого ТипПользователя Из Метаданные.РегистрыСведений.ДатыЗапретаИзменения.Измерения.Пользователь.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипПользователя);
		Если НЕ Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		//
		ПредставлениеТиповПлановОбмена = ПредставлениеТиповПлановОбмена + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"
		|	КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(%1.ПустаяСсылка)
		|		ТОГДА ""%2""",
		ОбъектМетаданных.ПолноеИмя(),
		ОбъектМетаданных.Представление() + ": " + НСтр("ru = '<Все узлы>'"));
		//
		ПредставлениеУзловПлановОбмена = ПредставлениеУзловПлановОбмена + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"
		|	КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = Тип(%1)
		|		ТОГДА ""%2: "" + ВЫРАЗИТЬ(ДатыЗапретаИзменения.Пользователь КАК %1).Наименование",
		ОбъектМетаданных.ПолноеИмя(),
		ОбъектМетаданных.Представление());
	КонецЦикла;
	ПредставлениеПлановОбмена = ПредставлениеТиповПлановОбмена + ПредставлениеУзловПлановОбмена;
	
	ПользовательПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	"ВЫБОР
	|	КОГДА ДатыЗапретаИзменения.Пользователь = НЕОПРЕДЕЛЕНО
	|		ТОГДА ""%1""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|		ТОГДА ""%2""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ПустаяСсылка)
	|		ТОГДА ""%3""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
	|		ТОГДА ""%4""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Справочник.ГруппыВнешнихПользователей.ПустаяСсылка)
	|		ТОГДА ""%5""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = Значение(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)
	|		ТОГДА ""%6""
	|	КОГДА ДатыЗапретаИзменения.Пользователь = Значение(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз)
	|		ТОГДА ""%7""
	|	КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.Пользователи)
	|			ИЛИ ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыПользователей)
	|			ИЛИ ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ВнешниеПользователи)
	|			ИЛИ ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|		ТОГДА ПРЕДСТАВЛЕНИЕ(ДатыЗапретаИзменения.Пользователь)
	|%8
	|	ИНАЧЕ ""%9""
	|КОНЕЦ",
	НСтр("ru = 'Неопределено'"),
	НСтр("ru = 'Пустой пользователь'"),
	НСтр("ru = 'Пустая группа пользователей'"),
	НСтр("ru = 'Пустой внешний пользователь'"),
	НСтр("ru = 'Пустая группа внешних пользователей'"),
	"<" + Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей + ">",
	"<" + Перечисления.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз + ">",
	ПредставлениеПлановОбмена,
	НСтр("ru = 'Неизвестный тип'"));
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "&ПользовательПредставление", ПользовательПредставление);
	
	// Настройка команды
	СвойстваРазделов = ДатыЗапретаИзмененияПовтИсп.СвойстваРазделов();
	Элементы.ФормаДатыЗапретаЗагрузкиДанных.Видимость = СвойстваРазделов.ИспользоватьДатыЗапретаЗагрузкиДанных;
	
	// Настройка порядка
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
		Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	Иначе
		Порядок = Список.Порядок;
	КонецЕсли;
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Пользователь");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Раздел");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Объект");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДатыЗапретаИзмененияДанных(Команда)
	
	ОткрытьФорму("РегистрСведений.ДатыЗапретаИзменения.Форма.ДатыЗапретаИзменения");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатыЗапретаЗагрузкиДанных(Команда)
	
	ПараметрыФормы = Новый Структура("ДатыЗапретаЗагрузкиДанных", Истина);
	ОткрытьФорму("РегистрСведений.ДатыЗапретаИзменения.Форма.ДатыЗапретаИзменения", ПараметрыФормы);
	
КонецПроцедуры

