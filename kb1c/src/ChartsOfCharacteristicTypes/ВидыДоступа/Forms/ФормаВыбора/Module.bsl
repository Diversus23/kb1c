////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НедоступныеВидыДоступа = Новый СписокЗначений;
	НеиспользуемыеВидыДоступа  = Новый СписокЗначений;
	
	Для каждого СвойстваВидаДоступа Из УправлениеДоступомСлужебный.СвойстваВидаДоступа() Цикл
		
		Если СвойстваВидаДоступа.ВидДоступаИспользуетсяВсегда Тогда
			// Технологические виды доступа всегда недоступны.
			НедоступныеВидыДоступа.Добавить(СвойстваВидаДоступа.ВидДоступа);
			
		ИначеЕсли НЕ УправлениеДоступомСлужебный.ВидДоступаИспользуется(СвойстваВидаДоступа.ВидДоступа) Тогда
			Если НЕ Параметры.Свойство("ПоказыватьНеиспользуемыеВидыДоступа") Тогда
				НедоступныеВидыДоступа.Добавить(СвойстваВидаДоступа.ВидДоступа);
			КонецЕсли;
			НеиспользуемыеВидыДоступа.Добавить(СвойстваВидаДоступа.ВидДоступа);
		КонецЕсли;
	КонецЦикла;
	
	// Скрытие недоступных видов доступа.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ссылка", НедоступныеВидыДоступа, ВидСравненияКомпоновкиДанных.НеВСписке, , Истина);
	
	// Оформление неиспользуемых видов доступа.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НедоступныеДанныеЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = НеиспользуемыеВидыДоступа;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие помеченных на удаление.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, , , Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

