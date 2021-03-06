////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтносительныйРазмер = Параметры.ОтносительныйРазмер;
	МинимальныйЭффект = Параметры.МинимальныйЭффект;
	Элементы.МинимальныйЭффект.Видимость = Параметры.РежимПерестроения;
	Заголовок = ?(Параметры.РежимПерестроения,
	              НСтр("ru='Параметры перестроения'"),
	              НСтр("ru='Параметр расчета оптимальных агрегатов'"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатВыбора = Новый Структура("ОтносительныйРазмер, МинимальныйЭффект");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтаФорма);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры
