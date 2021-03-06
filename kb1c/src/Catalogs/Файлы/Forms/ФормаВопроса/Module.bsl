////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СообщениеВопрос = Параметры.СообщениеВопрос;
	СообщениеЗаголовок = Параметры.СообщениеЗаголовок;
	Заголовок = Параметры.Заголовок;
	Файлы = Параметры.Файлы;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Файлы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяСтрока = Файлы[ВыбраннаяСтрока].Значение;
	
	КакОткрывать = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
		ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(
		РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
			ВыбраннаяСтрока, Неопределено, УникальныйИдентификатор));
	
КонецПроцедуры

