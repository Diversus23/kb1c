////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи"
// Клиентские процедуры и функции обработки "НастройкиПользователей"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Предназначена для открытия переданного отчета или формы
//
// Параметры:
//  ТекущийЭлемент               - ТаблицаФормы - выделенная строка дерева значений.
//  Пользователь                 - Строка - имя пользователя информационной базы,
//  ТекущийПользователь          - Строка - имя пользователя информационной базы, для открытия формы
//                                 должен совпадать значением параметра "Пользователь".
//  ИмяФормыПерсональныхНастроек - Строка - путь для открытия формы персональных настроек
//                                 вида "ОбщаяФорма.НазваниеФормы"
Процедура ОткрытьОтчетИлиФорму(ТекущийЭлемент, Пользователь, ТекущийПользователь, ИмяФормыПерсональныхНастроек) Экспорт
	
	ЭлементДереваЗначений = ТекущийЭлемент;
	Если ЭлементДереваЗначений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователь <> ТекущийПользователь Тогда
		ТекстПредупреждения = НСтр("ru = 'Для просмотра настроек другого пользователя необходимо запустить программу от его имени 
			|и открыть нужный отчет или форму.'");
		Предупреждение(ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ЭлементДереваЗначений.Имя = "НастройкиОтчетовДерево" Тогда
		
		КлючОбъекта = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Значение;
		КлючОбъектаМассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КлючОбъекта, "/");
		КлючВарианта = КлючОбъектаМассивСтрок[1];
		ПараметрыОтчета = Новый Структура("КлючВарианта, КлючПользовательскихНастроек", КлючВарианта, "");
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "НастройкаОтчета" Тогда
			КлючПользовательскихНастроек = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Представление;
			ПараметрыОтчета.Вставить("КлючПользовательскихНастроек", КлючПользовательскихНастроек);
		КонецЕсли;
		
		ОткрытьФорму(КлючОбъектаМассивСтрок[0] + ".Форма", ПараметрыОтчета);
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ВнешнийВид" Тогда
		
		Для Каждого КлючОбъекта Из ЭлементДереваЗначений.ТекущиеДанные.Ключи Цикл
			
			Если КлючОбъекта.Пометка = Истина Тогда
				
				ОткрытьФорму(КлючОбъекта.Значение);
				Возврат;
			Иначе
				РодительЭлемента = ЭлементДереваЗначений.ТекущиеДанные.ПолучитьРодителя();
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиРабочегоСтола" Тогда
					Предупреждение(НСтр("ru = 'Для просмотра настроек рабочего стола перейдите к разделу ""Рабочий стол""
						|в командном интерфейсе программы.'"));
					Возврат;
				КонецЕсли;
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиКомандногоИнтерфейса" Тогда
					Предупреждение(НСтр("ru = 'Для просмотра настроек командного интерфейса выберите нужный раздел
						|командного интерфейса программы.'"));
					Возврат;
				КонецЕсли;
				
				Если РодительЭлемента <> Неопределено Тогда
					ТекстПредупреждения = НСтр("ru = 'Для просмотра данной настройки необходимо открыть ""%1"" 
						|и затем перейти к форме ""%2"".'");
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения,
						РодительЭлемента.Настройка, ЭлементДереваЗначений.ТекущиеДанные.Настройка);
					Предупреждение(ТекстПредупреждения);
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Предупреждение(НСтр("ru = 'Данную настройку невозможно просмотреть.'"));
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ПрочиеНастройки" Тогда
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "ПерсональныеНастройки"
			И ИмяФормыПерсональныхНастроек <> "" Тогда
			ОткрытьФорму(ИмяФормыПерсональныхНастроек);
			Возврат;
		КонецЕсли;
		
		Предупреждение(НСтр("ru = 'Данную настройку невозможно просмотреть.'"));
		Возврат;
		
	КонецЕсли;
	
	Предупреждение(НСтр("ru = 'Выберите настройку для просмотра.'"));
	
КонецПроцедуры

// Предназначена для формирования окончания у слова "настройка".
//
// Параметры:
//  КоличествоНастроек - Число - количество настроек
//
// Возвращаемое значение:
//  Строка - вида "хх настроек" с правильным окончанием.
//
Функция ФормированиеСтрокиКоличестваНастроек(КоличествоНастроек) Экспорт
	
	ПрописьЧисла = ЧислоПрописью(
		КоличествоНастроек,
		"Л = ru_RU",
		НСтр("ru = ',,,,,,,,0'"));
	ПрописьЧислаИПредмета = ЧислоПрописью(
		КоличествоНастроек,
		"Л = ru_RU",
		НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
	ПрописьПредмета = СтрЗаменить(
		ПрописьЧислаИПредмета,
		ПрописьЧисла,
		Формат(КоличествоНастроек, "ЧДЦ=0") + " ");
		
	Возврат ПрописьПредмета;
КонецФункции

// Предназначена для формирования строки пояснения при копировании настроек
//
// Параметры:
//  ПредставлениеНастройки            - Строка - название настройки. Используется если копируется одна настройка.
//  КоличествоНастроек                - Число  - количество настроек. Используется, если копируется две более настроек.
//  ПояснениеКомуСкопированыНастройки - Строка - кому копируются настройки.
//
// Возвращаемое значение:
//  Строка - текст пояснения при копировании настройки
//
Функция ФормированиеПоясненияПриКопировании(ПредставлениеНастройки, КоличествоНастроек, ПояснениеКомуСкопированыНастройки) Экспорт
	
	Если КоличествоНастроек = 1 Тогда
		
		Если СтрДлина(ПредставлениеНастройки) > 24 Тогда
			ПредставлениеНастройки = Лев(ПредставлениеНастройки, 24) + "...";
		КонецЕсли;
		
		ТекстПояснения = НСтр("ru = '""%1"" скопирована %2'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстПояснения, ПредставлениеНастройки, ПояснениеКомуСкопированыНастройки);
	Иначе
		ПрописьПредмета = ФормированиеСтрокиКоличестваНастроек(КоличествоНастроек);
		ТекстПояснения = НСтр("ru = 'Скопировано %1 %2'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстПояснения, ПрописьПредмета, ПояснениеКомуСкопированыНастройки);
	КонецЕсли;
	
	Возврат ТекстПояснения;
КонецФункции

// Формирует строку получателя настройки
//
// Параметры:
//  КоличествоПользователей - Число  - используется, если значение больше единицы.
//  Пользователь            - Строка - имя пользователя. Используется, если количество пользователей
//                            равно единице.
//
// Возвращаемое значение:
//  Строка - пояснение кому копируется настройка
//
Функция ПояснениеПользователи(КоличествоПользователей, Пользователь) Экспорт
	
	Если КоличествоПользователей = 1 Тогда
		ПояснениеКомуСкопированыНастройки = НСтр("ru = 'пользователю ""%1""'");
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПояснениеКомуСкопированыНастройки, Пользователь);
	Иначе
		ПояснениеКомуСкопированыНастройки = НСтр("ru = '%1 пользователям'");
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПояснениеКомуСкопированыНастройки, КоличествоПользователей);
	КонецЕсли;
	
	Возврат ПояснениеКомуСкопированыНастройки;
КонецФункции




