
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Респондент") Тогда
		Объект.Респондент = Параметры.Респондент;
	Иначе
	КонецЕсли;
	
	УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтвеченныеАнкетыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОтвеченныеАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.Анкета);
	СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
	СтруктураПараметров.Вставить("ТолькоПросмотр",Истина);
	
	ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаДереваАнкет()
	
	Для каждого ДоступныйПараметр Из ОтвеченныеАнкеты.Параметры.ДоступныеПараметры.Элементы Цикл
		
		Если ДоступныйПараметр.Заголовок = "Респондент" Тогда
			ОтвеченныеАнкеты.Параметры.УстановитьЗначениеПараметра(ДоступныйПараметр.Параметр,Объект.Респондент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю()
	
	Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя();
	УстановитьПараметрыДинамическогоСпискаДереваАнкет();
	
КонецПроцедуры
