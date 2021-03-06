////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Элементы.Курс.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Курс на %1'"),
		Формат(ДатаКурса, "ДЛФ=DD"));
	Элементы.Курс.Подсказка = Элементы.Курс.Заголовок;
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", ДатаКурса);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Валюты

&НаКлиенте
Процедура ВалютыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Текст = НСтр("ru = 'Есть возможность подобрать валюту из классификатора.
	|Подобрать?'");
	Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		
		ОткрытьФорму("Справочник.Валюты.Форма.ПодборВалютИзКлассификатора", , ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.Валюты.Форма.ПодборВалютИзКлассификатора",, ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Элементы.Валюты.Обновить();
	Элементы.Валюты.ТекущаяСтрока = ВыбранноеЗначение;

КонецПроцедуры

