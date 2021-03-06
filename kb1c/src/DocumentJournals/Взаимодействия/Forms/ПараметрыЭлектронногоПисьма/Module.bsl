////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормыИзПараметров(Параметры);
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(Отказ, Модифицированность, ВыполненаКомандаЗакрыть); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыполненаКомандаЗакрыть = Истина;
	
	Если Папка <> ТекущаяПапка Тогда
		ВзаимодействияВызовСервера.УстановитьПапкуЭлектронногоПисьма(Письмо,Папка);
	КонецЕсли;
	
	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" И ОтправленоПолучено = Дата(1,1,1) И Модифицированность Тогда
		
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("УведомитьОДоставке", УведомитьОДоставке);
		РезультатВыбора.Вставить("УведомитьОПрочтении", УведомитьОПрочтении);
		РезультатВыбора.Вставить("ВключатьТелоИсходногоПисьма", ВключатьТелоИсходногоПисьма);
		РезультатВыбора.Вставить("Папка", Неопределено);
		
		
	Иначе
		
		РезультатВыбора = Неопределено;
		
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьРеквизитФормыИзПараметра(Параметры,ИмяПараметра,ИмяРеквизита = "")

	Если Параметры.Свойство(ИмяПараметра) Тогда
		
		ЭтаФорма[?(ПустаяСтрока(ИмяРеквизита),ИмяПараметра,ИмяРеквизита)] = Параметры[ИмяПараметра];
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыИзПараметров(Параметры)

	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"ВнутреннийНомер");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"ЗаголовкиИнтернета");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"Создано");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"Получено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"Отправлено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"УведомитьОДоставке");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"УведомитьОПрочтении");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"Письмо");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"ТипПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"ВключатьТелоИсходногоПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(Параметры,"УчетнаяЗапись");
	
	Папка = Взаимодействия.ПолучитьПапкуЭлектронногоПисьма(Письмо);
	ТекущаяПапка = Папка;

КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()

	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" Тогда
		Элементы.Заголовки.Заголовок = НСтр("ru='Идентификаторы'");
		Если ОтправленоПолучено = Дата(1,1,1) Тогда
			Элементы.УведомитьОДоставке.ТолькоПросмотр          = Ложь;
			Элементы.УведомитьОПрочтении.ТолькоПросмотр         = Ложь;
			Элементы.ВключатьТелоИсходногоПисьма.ТолькоПросмотр = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтправленоПолучено.Заголовок = НСтр("ru='Получено'");
		Элементы.ВключатьТелоИсходногоПисьма.Видимость =Ложь;
	КонецЕсли;
	
	Элементы.Папка.Доступность = ЗначениеЗаполнено(УчетнаяЗапись);
	
КонецПроцедуры

