////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		ДоступноИзменениеПользователей = Неопределено;
		ПользователиСлужебный.ПриОпределенииДоступностиИзмененияПользователей(ДоступноИзменениеПользователей);
		
		Если НЕ ДоступноИзменениеПользователей Тогда
			Если Объект.Ссылка.Пустая() Тогда
				ВызватьИсключение
					НСтр("ru = 'В демонстрационном режиме не поддерживается
					           |создание новых пользователей.'");
			КонецЕсли;
			ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Элементы.ПользовательИнфБазыПоказыватьВСпискеВыбора.Видимость   = Ложь;
		Элементы.ПользовательИнфБазыАутентификацияOpenID.Видимость      = Ложь;
		Элементы.ПользовательИнфБазыАутентификацияСтандартная.Видимость = Ложь;
		Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.Видимость   = Ложь;
		Элементы.СвойстваАутентификацииОС.Видимость = Ложь;
		Элементы.ПользовательИнфБазыРежимЗапуска.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.Служебный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Заполнение вспомогательных данных.
	
	АвторизованПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	// Заполнение списка выбора языка.
	Если Метаданные.Языки.Количество() < 2 Тогда
		Элементы.ПользовательИнфБазыЯзык.Видимость = Ложь;
	Иначе
		Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
			
			Элементы.ПользовательИнфБазыЯзык.СписокВыбора.Добавить(
				МетаданныеЯзыка.Имя, МетаданныеЯзыка.Синоним);
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение списка выбора режимов запуска.
	Для каждого РежимЗапуска Из РежимЗапускаКлиентскогоПриложения Цикл
		ПолноеИмяЗначения = ПолучитьПолноеИмяПредопределенногоЗначения(РежимЗапуска);
		ИмяЗначения = Сред(ПолноеИмяЗначения, Найти(ПолноеИмяЗначения, ".") + 1);
		Элементы.ПользовательИнфБазыРежимЗапуска.СписокВыбора.Добавить(ИмяЗначения, Строка(РежимЗапуска));
	КонецЦикла;
	Элементы.ПользовательИнфБазыРежимЗапуска.СписокВыбора.СортироватьПоПредставлению();
	
	// Подготовка к интерактивным действиям с учетом сценариев открытия формы.
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// Создание нового элемента.
		Если Параметры.ГруппаНовогоПользователя <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			ГруппаНовогоПользователя = Параметры.ГруппаНовогоПользователя;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// Копирование элемента.
			ЗначениеКопирования = Параметры.ЗначениеКопирования;
			Объект.Наименование = "";
			ПрочитатьПользователяИБ(
				ЗначениеЗаполнено(Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ));
		Иначе
			// Добавление элемента.
			Объект.ИдентификаторПользователяИБ = Параметры.ИдентификаторПользователяИБ;
			
			// Чтение начальных значений свойств пользователя ИБ.
			ПрочитатьПользователяИБ();
			
			Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
				ПользовательИнфБазыПоказыватьВСпискеВыбора   = Ложь;
				ПользовательИнфБазыАутентификацияOpenID      = Истина;
				ПользовательИнфБазыАутентификацияСтандартная = Истина;
				ДоступКИнформационнойБазеРазрешен = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		// Открытие существующего элемента.
		ПрочитатьПользователяИБ();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы", ПользовательИБСуществует);
	
	ОпределитьДействияВФорме();
	
	ОпределитьНесоответствияПользователяСПользователемИБ();
	
	ТолькоПросмотр
		=   ТолькоПросмотр
		ИЛИ   ДействияВФорме.Роли <> "Редактирование"
	        И ДействияВФорме.КонтактнаяИнформация <> "Редактирование"
	        И НЕ (    ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех"
	              ИЛИ ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих"     )
	        И ДействияВФорме.СвойстваЭлемента <> "Редактирование";
	
	ОбработатьИнтерфейсРолей(
		"УстановитьТолькоПросмотрРолей",
		    ПользователиСлужебный.ЗапретРедактированияРолей()
		ИЛИ ДействияВФорме.Роли <> "Редактирование");
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "КонтактнаяИнформация");
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	АдаптироватьРедактированиеКонтактнойИнформацииВСервисе();
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Недействителен.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ДействияСПользователемСервиса = Неопределено;
		ПользователиСлужебный.ПриПолученииДействийСПользователемСервиса(
			ДействияСПользователемСервиса, Объект.Ссылка);
	КонецЕсли;
		
	УстановитьПостояннуюДоступностьСвойств();
	УстановитьДоступностьСвойств(ЭтаФорма);
	
	ТребуетсяСинхронизацияССервисом = Объект.Ссылка.Пустая();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
	Элементы.ПользовательИнфБазыПользовательОС.КнопкаВыбора = Ложь;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.АутентификацияВСервисе") Тогда
		
		Если ВыбранноеЗначение <> Неопределено Тогда
			ПарольПользователяСервиса = ВыбранноеЗначение;
			Если ЗапросПароляПередЗаписью Тогда
				Записать();
			Иначе
				Подключаемый_EMailНачалоВыбора();
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Пользователи.Форма.ФормаВыбораПользователяОС") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
			ПользовательИнфБазыПользовательОС = ВыбранноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	ОчиститьСообщения();
	
	Если ДоступКИнформационнойБазеРазрешен Тогда
		ЗаголовокВопросов = НСтр("ru = 'Запись пользователя информационной базы'");
		
		Если ДействияВФорме.Роли = "Редактирование"
		   И ПользовательИнфБазыРоли.Количество() = 0 Тогда
			
			Ответ = Вопрос(
				НСтр("ru = 'Пользователю информационной базы не установлено ни одной роли. Продолжить?'"),
				РежимДиалогаВопрос.ДаНет,
				,
				,
				ЗаголовокВопросов);
			
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	
		// Обработка записи первого администратора.
		ТекстВопроса = "";
		Если ТребуетсяСоздатьПервогоАдминистратора(ТекстВопроса) Тогда
			
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , , ЗаголовокВопросов);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено
		И ТребуетсяСинхронизацияССервисом Тогда
		
		ЗапросПароляПередЗаписью = Истина;
		
		ПарольЕщёНеВведен = Ложь;
		СтандартныеПодсистемыКлиент.ПриЗапросеПароляДляАутентификацииВСервисе(
			ЭтаФорма, ПарольПользователяСервиса, ПарольЕщёНеВведен);
		
		Если ПарольЕщёНеВведен Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПарольПользователяСервиса", ПарольПользователяСервиса);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("СинхронизироватьССервисом", ТребуетсяСинхронизацияССервисом);
	
	// Восстановление действий в форме, если они изменены на клиенте
	ОпределитьДействияВФорме();
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех"
	 ИЛИ ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих" Тогда
		
		ОписаниеПользователяИБ = ОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Удалить("ПодтверждениеПароля");
		
		Если ДоступКИнформационнойБазеРазрешен Тогда
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		Иначе
			ОписаниеПользователяИБ.Вставить("Действие", "Удалить");
		КонецЕсли;
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить(
			"ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	КонецЕсли;
	
	Если ДействияВФорме.СвойстваЭлемента <> "Редактирование" Тогда
		
		ЗаполнитьЗначенияСвойств(
			ТекущийОбъект,
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ТекущийОбъект.Ссылка, "Наименование, ПометкаУдаления"));
	КонецЕсли;
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ГруппаНовогоПользователя", ГруппаНовогоПользователя);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	Если НЕ Отказ И ДействияВФорме.КонтактнаяИнформация = "Редактирование" Тогда
		УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТребуетсяСинхронизацияССервисом = Ложь;
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех"
	 ИЛИ ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих" Тогда
		
		ПараметрыЗаписи.Вставить(
			ТекущийОбъект.ДополнительныеСвойства.ОписаниеПользователяИБ.РезультатДействия);
	КонецЕсли;
	
	ПрочитатьПользователяИБ();
	
	ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_Пользователи", Новый Структура, Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ДобавленПользовательИБ") Тогда
		Оповестить("ДобавленПользовательИБ", ПараметрыЗаписи.ДобавленПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ИзмененПользовательИБ") Тогда
		Оповестить("ИзмененПользовательИБ", ПараметрыЗаписи.ИзмененПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("УдаленПользовательИБ") Тогда
		Оповестить("УдаленПользовательИБ", ПараметрыЗаписи.УдаленПользовательИБ, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ОчищенаСвязьСНесуществующимПользователемИБ") Тогда
		Оповестить(
			"ОчищенаСвязьСНесуществующимПользователемИБ",
			ПараметрыЗаписи.ОчищенаСвязьСНесуществующимПользователемИБ,
			ЭтаФорма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаНовогоПользователя) Тогда
		
		ОповеститьОбИзменении(ГруппаНовогоПользователя);
		Оповестить("Запись_ГруппыПользователей", Новый Структура, ГруппаНовогоПользователя);
		ГруппаНовогоПользователя = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ДоступКИнформационнойБазеРазрешен Тогда
		
		ОписаниеПользователяИБ = ОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Вставить("ИдентификаторПользователяИБ", Объект.ИдентификаторПользователяИБ);
		ПользователиСлужебный.ПроверитьОписаниеПользователяИБ(ОписаниеПользователяИБ, Отказ);
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьПолноеИмяПоПользователюИБ(Команда)
	
	Объект.Наименование = ПользовательИнфБазыПолноеИмя;
	Элементы.ПолноеИмяОбработкаНесоответствия.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// Если ПолноеИмя определено, то его нужно обновлять.
	// Прим.: неопределенное ПолноеИмя или другое свойство
	//        не учитывается при записи пользователя ИБ
	//        ПолноеИмя определено только для вида
	//        интерактивных действий "БезОграничения".
	
	Если ПользовательИнфБазыПолноеИмя <> Неопределено Тогда
		ПользовательИнфБазыПолноеИмя = Объект.Наименование;
	КонецЕсли;
	
	Если НЕ ПользовательИБСуществует
	   И ДоступКИнформационнойБазеРазрешен Тогда
		
		ПользовательИнфБазыИмя =
			ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
				Объект.Наименование);
	КонецЕсли;
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступКИнформационнойБазеРазрешенПриИзменении(Элемент)
	
	Если НЕ ПользовательИБСуществует
	   И ДоступКИнформационнойБазеРазрешен Тогда
		
		ПользовательИнфБазыИмя =
			ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
				Объект.Наименование);
		
		ПользовательИнфБазыПолноеИмя = Объект.Наименование;
	КонецЕсли;
	
	УстановитьДоступностьСвойств(ЭтаФорма);
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияСтандартнаяПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПользовательИнфБазыПароль = Пароль;
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияОСПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыПользовательОСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
		ОткрытьФорму("Справочник.Пользователи.Форма.ФормаВыбораПользователяОС", , ЭтаФорма);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДействителенПриИзменении(Элемент)
	
	Если Объект.Недействителен Тогда
		ДоступКИнформационнойБазеРазрешен = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьСвойств(ЭтаФорма);
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыИмяПриИзменении(Элемент)
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыЯзыкПриИзменении(Элемент)
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_EMailПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКИ = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	СтрокаEMail = ТаблицаКИ.НайтиСтроки(Новый Структура("Вид", 
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя")))[0];
	
	Если ЗначениеЗаполнено(ЭтаФорма[СтрокаEMail.ИмяРеквизита]) Тогда
		Пароль = "" + Новый УникальныйИдентификатор + "qQ";
		ПодтверждениеПароля = Пароль;
		ПользовательИнфБазыПароль = Пароль;
	КонецЕсли;
	УстановитьДоступностьСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТелефонПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
	УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_EMailНачалоВыбора()
	
	ЗапросПароляПередЗаписью = Ложь;
	
	ПарольЕщёНеВведен = Ложь;
	СтандартныеПодсистемыКлиент.ПриЗапросеПароляДляАутентификацииВСервисе(
		ЭтаФорма, ПарольПользователяСервиса, ПарольЕщёНеВведен);
	
	Если ПарольЕщёНеВведен Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКИ = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	
	Отбор = Новый Структура("Вид",
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
	
	СтрокаEMail = ТаблицаКИ.НайтиСтроки(Отбор)[0];
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПарольПользователяСервиса", ПарольПользователяСервиса);
	ПараметрыФормы.Вставить("СтараяПочта",  ЭтаФорма[СтрокаEMail.ИмяРеквизита]);
	ПараметрыФормы.Вставить("Пользователь", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.Пользователи.Форма.СменаПочты", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, , СтандартнаяОбработка);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтаФорма, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтаФорма, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтаФорма, Объект, Результат);
	
КонецФункции

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Роли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	Если Элементы.Роли.ТекущиеДанные <> Неопределено Тогда
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
		
		Если Элементы.Роли.ТекущиеДанные.Имя = "ПолныеПрава" Тогда
			УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ТолькоВыбранныеРоли");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ВключитьВсе");
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ИсключитьВсе");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОпределитьДействияВФорме()
	
	ДействияВФорме = Новый Структура;
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("Роли", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("КонтактнаяИнформация", "");
	
	// "", "ПросмотрВсех", "РедактированиеВсех", "РедактированиеСвоих".
	ДействияВФорме.Вставить("СвойстваПользователяИБ", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("СвойстваЭлемента", "");
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Администратор.
		ДействияВФорме.Роли                   = "Редактирование";
		ДействияВФорме.КонтактнаяИнформация   = "Редактирование";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
		
	ИначеЕсли РольДоступна("ДобавлениеИзменениеПользователей")
	        И НЕ Пользователи.ЭтоПолноправныйПользователь(Объект.Ссылка) Тогда
		
		// Ответственный за список пользователей и групп пользователей.
		// (Исполнитель распоряжений о приеме на работу и переводу,
		//  переназначению, созданию отделов, подразделений и рабочих групп).
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.КонтактнаяИнформация   = "Редактирование";
		ДействияВФорме.СвойстваПользователяИБ = "ПросмотрВсех";
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
		
	ИначеЕсли Объект.Ссылка = ПользователиКлиентСервер.АвторизованныйПользователь() Тогда
		// Свои свойства.
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.КонтактнаяИнформация   = "Редактирование";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	Иначе
		// Чужие свойства.
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.КонтактнаяИнформация   = "Просмотр";
		ДействияВФорме.СвойстваПользователяИБ = "";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	КонецЕсли;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.Пользователи\ПриОпределенииДействийВФорме");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииДействийВФорме(Объект.Ссылка, ДействияВФорме);
	КонецЦикла;
	
	ПользователиПереопределяемый.ИзменитьДействияВФорме(Объект.Ссылка, ДействияВФорме);
	
	// Проверка имен действий в форме.
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.Роли + ",") = 0 Тогда
		ДействияВФорме.Роли = "";
		
	ИначеЕсли ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		ДействияВФорме.Роли = "Просмотр";
	КонецЕсли;
	
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.КонтактнаяИнформация + ",") = 0 Тогда
		ДействияВФорме.КонтактнаяИнформация = "";
	КонецЕсли;
	
	Если Найти(", ПросмотрВсех, РедактированиеВсех, РедактированиеСвоих,",
	           ", " + ДействияВФорме.СвойстваПользователяИБ + ",") = 0 Тогда
		
		ДействияВФорме.СвойстваПользователяИБ = "";
	КонецЕсли;
	
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СвойстваЭлемента + ",") = 0 Тогда
		ДействияВФорме.СвойстваЭлемента = "";
	КонецЕсли;
	
	Если Объект.Служебный Тогда
		Если ДействияВФорме.Роли = "Редактирование" Тогда
			ДействияВФорме.Роли = "Просмотр";
		КонецЕсли;
		
		Если ДействияВФорме.КонтактнаяИнформация = "Редактирование" Тогда
			ДействияВФорме.КонтактнаяИнформация = "Просмотр";
		КонецЕсли;
		
		Если Найти(", РедактированиеВсех, РедактированиеСвоих,",
		           ", " + ДействияВФорме.СвойстваПользователяИБ + ",") <> 0 Тогда
			
			ДействияВФорме.СвойстваПользователяИБ = "ПросмотрВсех";
		КонецЕсли;
		
		Если ДействияВФорме.СвойстваЭлемента = "Редактирование" Тогда
			ДействияВФорме.СвойстваЭлемента = "Просмотр";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеПользователяИБ()
	
	Если Элементы.ПолноеИмяПояснениеНесоответствия.Видимость Тогда
		ПользовательИнфБазыПолноеИмя = Объект.Наименование;
	КонецЕсли;
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" Тогда
		
		Результат = Пользователи.НовоеОписаниеПользователяИБ();
		Пользователи.СкопироватьСвойстваПользователяИБ(
			Результат,
			ЭтаФорма,
			,
			"УникальныйИдентификатор,
			|Роли",
			"ПользовательИнфБазы");
		
	Иначе
		// РедактированиеСвоих.
		Результат = Новый Структура;
		Результат.Вставить("Пароль", ПользовательИнфБазыПароль);
		Результат.Вставить("Язык",   ПользовательИнфБазыЯзык);
	КонецЕсли;
	Результат.Вставить("ПодтверждениеПароля", ПодтверждениеПароля);
	
	Если ДействияВФорме.Роли = "Редактирование" Тогда
		ТекущиеРоли = ПользовательИнфБазыРоли.Выгрузить(, "Роль").ВыгрузитьКолонку("Роль");
		Результат.Вставить("Роли", ТекущиеРоли);
	КонецЕсли;
	
	Если ПользователиСлужебный.ТребуетсяСоздатьПервогоАдминистратора(Результат) Тогда
		РолиАдминистратора = Новый Массив;
		РолиАдминистратора.Добавить("ПолныеПрава");
		
		ИмяРолиАдминистратораСистемы = Пользователи.РольАдминистратораСистемы().Имя;
		Если РолиАдминистратора.Найти(ИмяРолиАдминистратораСистемы) = Неопределено Тогда
			РолиАдминистратора.Добавить(ИмяРолиАдминистратораСистемы);
		КонецЕсли;
		Результат.Вставить("Роли", РолиАдминистратора);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТребуетсяСоздатьПервогоАдминистратора(ТекстВопроса = Неопределено)
	
	Возврат ПользователиСлужебный.ТребуетсяСоздатьПервогоАдминистратора(
		ОписаниеПользователяИБ(),
		ТекстВопроса);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНеобходимостьСинхронизацииССервисом(Форма)
	
	Форма.ТребуетсяСинхронизацияССервисом = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка пользователя ИБ.

&НаСервере
Процедура ПрочитатьПользователяИБ(ПриКопированииЭлемента = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пароль              = "";
	ПодтверждениеПароля = "";
	ПрочитанныеСвойства               = Неопределено;
	ОписаниеПользователяИБ            = Пользователи.НовоеОписаниеПользователяИБ();
	ПользовательИБСуществует          = Ложь;
	ДоступКИнформационнойБазеРазрешен = Ложь;
	
	// Заполнение начальных значений свойств пользователяИБ.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
	Иначе
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора =
			НЕ Константы.ИспользоватьВнешнихПользователей.Получить();
	КонецЕсли;
	ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
	ОписаниеПользователяИБ.Роли = Новый Массив;
	
	Если ПриКопированииЭлемента Тогда
		
		Если Пользователи.ПрочитатьПользователяИБ(
		         Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ,
		         ПрочитанныеСвойства) Тогда
			
			// Установка связи пользователем ИБ.
			ДоступКИнформационнойБазеРазрешен = Истина;
			
			// Копирование свойств и ролей пользователяИБ.
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"АутентификацияOpenID,
				|АутентификацияСтандартная,
				|ЗапрещеноИзменятьПароль,
				|ПоказыватьВСпискеВыбора,
				|АутентификацияОС,
				|РежимЗапуска,
				|Язык,
				|Роли");
		КонецЕсли;
		Объект.ИдентификаторПользователяИБ = Неопределено;
	Иначе
		Если Пользователи.ПрочитатьПользователяИБ(
		         Объект.ИдентификаторПользователяИБ,
		         ПрочитанныеСвойства) Тогда
		
			ПользовательИБСуществует          = Истина;
			ДоступКИнформационнойБазеРазрешен = Истина;
			
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"Имя,
				|ПолноеИмя,
				|АутентификацияOpenID,
				|АутентификацияСтандартная,
				|ПоказыватьВСпискеВыбора,
				|ЗапрещеноИзменятьПароль,
				|АутентификацияОС,
				|ПользовательОС,
				|РежимЗапуска,
				|Язык,
				|Роли");
			
			Если ПрочитанныеСвойства.ПарольУстановлен Тогда
				Пароль              = "**********";
				ПодтверждениеПароля = "**********";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Пользователи.СкопироватьСвойстваПользователяИБ(
		ЭтаФорма,
		ОписаниеПользователяИБ,
		,
		"УникальныйИдентификатор,
		|Роли",
		"ПользовательИнфБазы");
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", ОписаниеПользователяИБ.Роли);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи = Неопределено)
	
	// Проверка соответствия свойства "ПолноеИмя" пользователяИБ и
	// свойства "Наименование" пользователя.
	
	Если НЕ (  ДействияВФорме.СвойстваЭлемента       = "Редактирование"
	         И ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех") Тогда
		
		// Прочитанное ПолноеИмя пользователя не может быть изменено, если не совпадает.
		ПользовательИнфБазыПолноеИмя = Неопределено;
	КонецЕсли;
	
	Если НЕ ПользовательИБСуществует
	 ИЛИ ПользовательИнфБазыПолноеИмя = Неопределено
	 ИЛИ ПользовательИнфБазыПолноеИмя = Объект.Наименование Тогда
		
		Элементы.ПолноеИмяОбработкаНесоответствия.Видимость = Ложь;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Элементы.ПолноеИмяПояснениеНесоответствия.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ПолноеИмяПояснениеНесоответствия.Заголовок,
				ПользовательИнфБазыПолноеИмя);
	Иначе
		Объект.Наименование = ПользовательИнфБазыПолноеИмя;
		Элементы.ПолноеИмяОбработкаНесоответствия.Видимость = Ложь;
	КонецЕсли;
	
	// Определение связи с несуществующим пользователем ИБ.
	ЕстьНоваяСвязьСНесуществующимПользователемИБ
		= НЕ ПользовательИБСуществует
		И ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ);
	
	Если ПараметрыЗаписи <> Неопределено
	   И ЕстьСвязьСНесуществующимПользователемИБ
	   И НЕ ЕстьНоваяСвязьСНесуществующимПользователемИБ Тогда
		
		ПараметрыЗаписи.Вставить("ОчищенаСвязьСНесуществующимПользователемИБ", Объект.Ссылка);
	КонецЕсли;
	ЕстьСвязьСНесуществующимПользователемИБ = ЕстьНоваяСвязьСНесуществующимПользователемИБ;
	
	Если ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех" Тогда
		// Связь не может быть изменена.
		Элементы.СвязьОбработкаНесоответствия.Видимость = Ложь;
	Иначе
		Элементы.СвязьОбработкаНесоответствия.Видимость = ЕстьСвязьСНесуществующимПользователемИБ;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Начальное заполнение, проверка заполнения, доступность свойств

&НаСервере
Процедура УстановитьПостояннуюДоступностьСвойств()
	
	Элементы.КонтактнаяИнформация.Видимость   = ЗначениеЗаполнено(ДействияВФорме.КонтактнаяИнформация);
	Элементы.СвойстваПользователяИБ.Видимость = ЗначениеЗаполнено(ДействияВФорме.СвойстваПользователяИБ);
	
	ВыводитьСписокРолей = ЗначениеЗаполнено(ДействияВФорме.Роли);
	Элементы.ОтображениеРолей.Видимость = ВыводитьСписокРолей;
	Элементы.СвойстваАутентификации1СПредприятия.Отображение = 
		?(ВыводитьСписокРолей, ОтображениеОбычнойГруппы.Нет, ОбщегоНазначенияКлиентСервер.ОтображениеОбычнойГруппыОтступ());
	
	Элементы.Наименование.ТолькоПросмотр =
		ДействияВФорме.СвойстваЭлемента <> "Редактирование";
	
	Элементы.ДоступКИнформационнойБазеРазрешен.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.СвойстваПользователяИБ.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ =  "ПросмотрВсех";
	
	Элементы.ПользовательИнфБазыИмя.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыАутентификацияСтандартная.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
		
	Элементы.ПользовательИнфБазыАутентификацияOpenID.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыПоказыватьВСпискеВыбора.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыАутентификацияОС.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыПользовательОС.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.ПользовательИнфБазыРежимЗапуска.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСвойств(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Пароль.ТолькоПросмотр =
		Форма.ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ Форма.АвторизованПолноправныйПользователь;
	
	Элементы.ПодтверждениеПароля.ТолькоПросмотр =
		Форма.ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ Форма.АвторизованПолноправныйПользователь;
	
	Элементы.ОсновныеСвойства.Доступность =
		Форма.ДоступКИнформационнойБазеРазрешен;
	
	Элементы.ОтображениеРолей.Доступность =
		Форма.ДоступКИнформационнойБазеРазрешен;
	
	Элементы.ПользовательИнфБазыИмя.АвтоОтметкаНезаполненного =
		Форма.ДоступКИнформационнойБазеРазрешен;
	
	Элементы.Пароль.Доступность =
		Форма.ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ПодтверждениеПароля.Доступность =
		Форма.ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.Доступность =
		Форма.ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ПользовательИнфБазыПоказыватьВСпискеВыбора.Доступность =
		Форма.ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ПользовательИнфБазыПользовательОС.Доступность =
		Форма.ПользовательИнфБазыАутентификацияОС;
	
	Элементы.ДоступКИнформационнойБазеРазрешен.Доступность =
		НЕ Форма.Объект.Недействителен;
		
		
	Если Форма.ДействияСПользователемСервиса <> Неопределено Тогда
		
		// Доступность редактирования КИ
		
		ДействияКИ = Форма.ДействияСПользователемСервиса.КонтактнаяИнформация;
		
		Для Каждого СтрокаКИ Из Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
			ДействияВидаКИ = ДействияКИ.Получить(СтрокаКИ.Вид);
			Если ДействияВидаКИ = Неопределено Тогда
				// Возможность редактирования этого вида КИ не регулируется менеджером сервиса
				Продолжить;
			КонецЕсли;
			
			ЭлементКИ = Элементы[СтрокаКИ.ИмяРеквизита];
			
			Если СтрокаКИ.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя") Тогда
				
				ЭлементКИ.ТолькоПросмотр = НЕ Форма.Объект.Ссылка.Пустая();
				
				ЭлементКИ.КнопкаВыбора = НЕ Форма.Объект.Ссылка.Пустая()
					И ДействияВидаКИ.Изменение;
					
				ЗаполненEMail = ЗначениеЗаполнено(Форма[СтрокаКИ.ИмяРеквизита]);
			Иначе
				ЭлементКИ.ТолькоПросмотр = ЭлементКИ.ТолькоПросмотр
					ИЛИ НЕ ДействияВидаКИ.Изменение;
			КонецЕсли;
		КонецЦикла;
		
		Если Форма.Объект.Ссылка.Пустая() И ЗаполненEMail Тогда
			МожноИзменятьПароль = Ложь;
		Иначе
			МожноИзменятьПароль = Форма.ДействияСПользователемСервиса.ИзменениеПароля;
		КонецЕсли;
		
		Элементы.Пароль.ТолькоПросмотр = Элементы.Пароль.ТолькоПросмотр
			ИЛИ НЕ МожноИзменятьПароль;
			
		Элементы.ПодтверждениеПароля.ТолькоПросмотр = Элементы.ПодтверждениеПароля.ТолькоПросмотр
			ИЛИ НЕ МожноИзменятьПароль;
		
		Элементы.ПользовательИнфБазыИмя.ТолькоПросмотр = Элементы.ПользовательИнфБазыИмя.ТолькоПросмотр
			ИЛИ НЕ Форма.ДействияСПользователемСервиса.ИзменениеИмени;
			
		Элементы.Наименование.ТолькоПросмотр = Элементы.Наименование.ТолькоПросмотр 
			ИЛИ НЕ Форма.ДействияСПользователемСервиса.ИзменениеПолногоИмени;
			
		Элементы.ДоступКИнформационнойБазеРазрешен.Доступность = Элементы.ДоступКИнформационнойБазеРазрешен.Доступность
			И Форма.ДействияСПользователемСервиса.ИзменениеДоступа;
			
		Элементы.Недействителен.Доступность = Элементы.Недействителен.Доступность 
			И Форма.ДействияСПользователемСервиса.ИзменениеДоступа;
			
		Форма.ЗапретИзмененияАдминистративногоДоступа = НЕ Форма.ДействияСПользователемСервиса.ИзменениеАдминистративногоДоступа;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АдаптироватьРедактированиеКонтактнойИнформацииВСервисе()
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	КонтактнаяИнформация = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	
	СтрокаEMail = КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.EmailПользователя))[0];
	ЭлементEMail = Элементы[СтрокаEMail.ИмяРеквизита];
	ЭлементEMail.УстановитьДействие("ПриИзменении", "Подключаемый_EMailПриИзменении");
	
	ЭлементEMail.КнопкаВыбора = Истина;
	ЭлементEMail.УстановитьДействие("НачалоВыбора", "Подключаемый_EMailНачалоВыбора");
	
	СтрокаТелефон = КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонПользователя))[0];
	ЭлементТелефон = Элементы[СтрокаТелефон.ИмяРеквизита];
	ЭлементТелефон.УстановитьДействие("ПриИзменении", "Подключаемый_ТелефонПриИзменении");
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыРежимЗапускаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр", ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",            ЭтаФорма);
	ПараметрыДействия.Вставить("КоллекцияРолей",   ПользовательИнфБазыРоли);
	ПараметрыДействия.Вставить("ЗапретИзмененияАдминистративногоДоступа", ЗапретИзмененияАдминистративногоДоступа);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ПараметрыДействия.Вставить("ТипПользователей",
			Перечисления.ТипыПользователей.ПользовательОбластиДанных);
	Иначе
		ПараметрыДействия.Вставить("ТипПользователей",
			Перечисления.ТипыПользователей.ПользовательЛокальногоРешения);
	КонецЕсли;
	
	БылУстановленАдминистративныйДоступ = ПользовательИнфБазыРоли.НайтиСтроки(
		Новый Структура("Роль", "ПолныеПрава")).Количество() > 0;
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
	УстановленАдминистративныйДоступ = ПользовательИнфБазыРоли.НайтиСтроки(
		Новый Структура("Роль", "ПолныеПрава")).Количество() > 0;
	
	Если УстановленАдминистративныйДоступ <> БылУстановленАдминистративныйДоступ Тогда
		УстановитьНеобходимостьСинхронизацииССервисом(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры
