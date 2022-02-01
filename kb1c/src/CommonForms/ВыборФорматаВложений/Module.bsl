////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// загрузка переданных параметров
	ПереданныйМассивФорматов = Новый Массив;
	Если Параметры.НастройкиФормата <> Неопределено Тогда
		ПереданныйМассивФорматов = Параметры.НастройкиФормата.ФорматыСохранения;
		УпаковатьВАрхив = Параметры.НастройкиФормата.УпаковатьВАрхив;
	КонецЕсли;
	
	// заполнение списка форматов
	Для Каждого ФорматСохранения Из УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		Пометка = Ложь;
		Если Параметры.НастройкиФормата <> Неопределено Тогда 
			ПереданныйФормат = ПереданныйМассивФорматов.Найти(ФорматСохранения.ТипФайлаТабличногоДокумента);
			Если ПереданныйФормат <> Неопределено Тогда
				Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
		ВыбранныеФорматыСохранения.Добавить(ФорматСохранения.ТипФайлаТабличногоДокумента, Строка(ФорматСохранения.Ссылка), Пометка, ФорматСохранения.Картинка);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если Параметры.НастройкиФормата <> Неопределено И Параметры.НастройкиФормата.ФорматыСохранения.Количество() > 0 Тогда
		Настройки.Удалить("ВыбранныеФорматыСохранения");
		Настройки.Удалить("УпаковатьВАрхив");
		Возврат;
	КонецЕсли;
	
	ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			ВыбранныйФормат.Пометка = ФорматИзНастроек <> Неопределено И ФорматИзНастроек.Пометка;
		КонецЦикла;
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВыборФормата();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	РезультатВыбора = ВыбранныеНастройкиФормата();
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВыборФормата()
	
	ЕстьВыбранныйФормат = Ложь;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ЕстьВыбранныйФормат = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВыбранныйФормат Тогда
		ВыбранныеФорматыСохранения[0].Пометка = Истина; // выбор по умолчанию - первый в списке
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройкиФормата()
	
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	Результат = Новый Структура;
	Результат.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	Результат.Вставить("ФорматыСохранения", ФорматыСохранения);
	
	Возврат Результат;
	
КонецФункции
