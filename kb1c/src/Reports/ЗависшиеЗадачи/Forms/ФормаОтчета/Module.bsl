////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	ЗначениеРасшифровки = Неопределено;
	Если БизнесПроцессыИЗадачиВызовСервера.ЭтоЗадачаИсполнителю(Расшифровка, ДанныеРасшифровки, ЗначениеРасшифровки) Тогда
		СтандартнаяОбработка = НЕ БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ЗначениеРасшифровки);
	КонецЕсли;
КонецПроцедуры

