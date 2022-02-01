////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
		Элементы.ПутьКАрхивуWindows.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows'"); 
	Иначе
		Элементы.ПутьКАрхивуWindows.КнопкаВыбора = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПутьКАрхивуWindowsНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Диалог.Заголовок                    = НСтр("ru = 'Выберите файл'");
	Диалог.ПолноеИмяФайла               = ?(ЭтаФорма.ПутьКАрхивуWindows = "", "files.zip", ЭтаФорма.ПутьКАрхивуWindows);
	Диалог.МножественныйВыбор           = Ложь;
	Диалог.ПредварительныйПросмотр      = Ложь;
	Диалог.ПроверятьСуществованиеФайла  = Истина;
	Диалог.Фильтр                       = "Архивы zip(*.zip)|*.zip";
	
	Если Диалог.Выбрать() Тогда
		
		ЭтаФорма.ПутьКАрхивуWindows = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Разместить(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(ПутьКАрхивуWindows) И ПустаяСтрока(ПутьКАрхивуLinux) Тогда
		Текст = НСтр("ru = 'Укажите полное имя архива с
		                   |файлами начального образа (файл *.zip)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПутьКАрхивуWindows");
		Возврат;
	КонецЕсли;
	
	Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
	
		Если Не ПустаяСтрока(ПутьКАрхивуWindows) И (Лев(ПутьКАрхивуWindows, 2) <> "\\" ИЛИ Найти(ПутьКАрхивуWindows, ":") <> 0) Тогда
			ТекстОшибки = НСтр("ru = 'Путь к архиву с файлами начального образа
			                         |должен быть в формате UNC (\\servername\resource).'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьКАрхивуWindows");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
	Состояние(
		НСтр("ru = 'Обмен данными'"),
		,
		НСтр("ru = 'Осуществляется размещение файлов из
		           |архива с файлами начального образа...'"),
		БиблиотекаКартинок.СоздатьНачальныйОбраз);
	
	ДобавитьФайлыВТома();
	
	Предупреждение(НСтр("ru = 'Размещение файлов из архива с файлами
	                          |начального образа успешно завершено.'"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ДобавитьФайлыВТома()
	
	ФайловыеФункцииСлужебный.ДобавитьФайлыВТома(ПутьКАрхивуWindows, ПутьКАрхивуLinux);
	
КонецПроцедуры
