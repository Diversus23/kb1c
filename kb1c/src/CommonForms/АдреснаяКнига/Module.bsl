////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Взаимодействия.ОбработатьНеобходимостьОтображенияГруппПользователей(ЭтаФорма);
	
	Взаимодействия.ДобавитьСтраницыФормыПодбораКонтактов(ЭтаФорма);
	ЗаполнитьТаблицуПолучателей();
	УстановитьГруппуПоУмолчанию();

	// Заполним контакты по предмету
	Предмет = Параметры.Предмет;
	Взаимодействия.ЗаполнитьКонтактыПоПредмету(Элементы, Предмет, КонтактыПоПредмету, Истина);
	
	// Получим информацию об индексе ППД
	Взаимодействия.ОбновитьИнформациюОбАктуальностиИндексаППД(
		ИнформацияОбАктуальностиИндексаППД, ППДВключен, ИндексАктуален);

	// Заполним список вариантов поиска и осуществим первый поиск
	ВсеСпискиПоиска = Взаимодействия.ПолучитьСписокДоступныхПоисков(ППДВключен, Параметры, Элементы, Истина);
	ВариантыПоиска = "ПоEmail";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью();
	УправлениеСтраницами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УправлениеСтраницами();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Истина);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Ложь);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Истина);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Ложь);

	ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, ТекущиеДанные.Адрес, ТекущиеДанные.Представление,
	                                    ТекущиеДанные.Контакт,ПараметрыОткрытия)
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПисьмаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Группа = "Кому";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПисьмаПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя = "Адрес" Тогда
		Элементы.Адрес.СписокВыбора.Очистить();
		
		ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекущиеДанные.СписокАдресов) Тогда
			Элементы.Адрес.СписокВыбора.ЗагрузитьЗначения(
			СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекущиеДанные.СписокАдресов,";"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПоПредметуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ДобавитьПолучателяИзСпискаПоПредмету();

КонецПроцедуры

&НаКлиенте
Процедура СписокСправочникаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.ПолучитьНаименованиеИАдресаЭлектроннойПочтыКонтакта(ВыбраннаяСтрока);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = Результат.Адреса[0];
	СписокАдресов = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Результат.Адреса, ";");
	
	ДобавитьПолучателя(Адрес, Результат.Наименование, ВыбраннаяСтрока, СписокАдресов);
	
КонецПроцедуры

//Универсальный обработчик активизации строки динамического списка, у которого есть подчиненные списки.
&НаКлиенте
Процедура Подключаемый_СписокВладелецПриАктивизацииСтроки(Элемент)
	
	ВзаимодействияКлиент.КонтактВладелецПриАктивизацииСтроки(Элемент, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеКонтактыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НайденныеКонтакты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.ПолучитьНаименованиеИАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Ссылка);
	Если Результат <> Неопределено И Результат.Адреса.Количество() > 0 Тогда
		СписокАдресов = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Результат.Адреса, ";");
	Иначе
		СписокАдресов = "";
	КонецЕсли;
	
	ДобавитьПолучателя(ТекущиеДанные.Представление, ТекущиеДанные.НаименованиеКонтакта, ТекущиеДанные.Ссылка, СписокАдресов);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Передает владельцу в качестве результата работы формы массив структур содержащих 
// адреса выбранных получателей и закрывает форму. 
//
&НаКлиенте
Процедура КомандаОКВыполнить()
	
	Результат = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ПолучателиПисьма Цикл
		Группа = ?(ПустаяСтрока(СтрокаТаблицы.Группа), "Кому", СтрокаТаблицы.Группа);
		Контакт = Новый Структура("Адрес, Представление, Контакт, Группа",
		                          СтрокаТаблицы.Адрес, СтрокаТаблицы.Представление, СтрокаТаблицы.Контакт, Группа);
		Результат.Добавить(Контакт);
	КонецЦикла;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

//Переносит текущий контакт из списка "Контакты по предмету" в список "Получатели письма". 
//
&НаКлиенте
Процедура ДобавитьИзСпискаПредметовВыполнить()

	ДобавитьПолучателяИзСпискаПоПредмету();

КонецПроцедуры

//Изменяет текущую группу получателей письма на группу "Кому". 
//
&НаКлиенте
Процедура ИзменитьГруппуКомуВыполнить()

	ИзменитьГруппу("Кому");

КонецПроцедуры

//Изменяет текущую группу получателей письма на группу "Копии". 
//
&НаКлиенте
Процедура ИзменитьГруппуКопииВыполнить()

	ИзменитьГруппу("Копии");

КонецПроцедуры 

//Изменяет текущую группу получателей письма на группу "Скрытые". 
//
&НаКлиенте
Процедура ИзменитьГруппуСкрытыеВыполнить()

	ИзменитьГруппу("Скрытые");

КонецПроцедуры

//Инициирует процесс поиска контактов.
//
&НаКлиенте
Процедура КомандаНайтиВыполнить()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Предупреждение(НСтр("ru = 'Не задана строка поиска!'"));
		Возврат;
	КонецЕсли;
	
	Результат = "";
	НайденныеКонтакты.Очистить();
	
	Если ВариантыПоиска = "ПоEmail" Тогда
		НайтиПоEmail(Ложь);
	ИначеЕсли ВариантыПоиска = "ПоДомену" Тогда
		НайтиПоEmail(Истина);
	ИначеЕсли ВариантыПоиска = "ПоСтроке" Тогда
		Результат = КонтактыНайденныеПоСтроке();
	ИначеЕсли ВариантыПоиска = "НачинаетсяС" Тогда
		НайтиПоНачалуНаименования();
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) Тогда
		
		Предупреждение(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

//Обновляет индекс полнотекстового поиска. 
//
&НаКлиенте
Процедура КомандаОбновитьИндексППДВыполнить()
	
	ВзаимодействияКлиент.КомандаОбновитьИндексППДВыполнить(ИнформацияОбАктуальностиИндексаППД,ППДВключен,ИндексАктуален);
	УправлениеДоступностью();
	
КонецПроцедуры 

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте из 
//списка "Найденные контакты".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаНайденныхВыполнить()
	
	ТекущиеДанные = Элементы.НайденныеКонтакты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
//из списка "Получатели письма".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаПолучателейВыполнить()
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Контакт);
	КонецЕсли;
	
КонецПроцедуры

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
//из списка "Контакты по предмету".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаПредметовВыполнить()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры 

//Инициирует поиск контактов по адресу электронной почты текущей строки списка "Получатели письма". 
//
&НаКлиенте
Процедура НайтиПоАдресуВыполнить()
	
	Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов;
	НайденныеКонтакты.Очистить();
	ВариантыПоиска = "ПоEmail";

	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СтрокаПоиска = ТекущиеДанные.Адрес;
	Если Не ПустаяСтрока(СтрокаПоиска) Тогда
		НайтиПоEmail(Ложь);
	КонецЕсли;

КонецПроцедуры

//Инициирует поиск контактов по представлению текущей строки списка "Получатели письма". 
//
&НаКлиенте
Процедура НайтиПоПредставлениюВыполнить()
	
	Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов;
	НайденныеКонтакты.Очистить();
	ВариантыПоиска = "ПоСтроке";

	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПоиска = ТекущиеДанные.Представление;
	Если Не ПустаяСтрока(СтрокаПоиска) Тогда
		Результат = КонтактыНайденныеПоСтроке();
		Если Не ПустаяСтрока(Результат) Тогда
			Предупреждение(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

//Осуществляет поиск всех адресов электронной почты контакта из списка "Получатели письма" и
 //предлагает пользователю сделать выбор, если у контакта более одного адреса электронной почты.
&НаКлиенте
Процедура УстановитьАдресКонтактаВыполнить()
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.ПолучитьАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Контакт);
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Количество() = 1 Тогда
		Адрес = Результат[0].АдресЭП;
		Представление = Результат[0].Представление;
	Иначе
		СписокВыбора = Новый СписокЗначений;
		Номер = 0;
		Для Каждого Элемент Из Результат Цикл
			СписокВыбора.Добавить(Номер, Элемент.ВидНаименование + ": " + Элемент.АдресЭП);
			Номер = Номер + 1;
		КонецЦикла;
		
		ВыбранныйЭлемент = СписокВыбора.ВыбратьЭлемент();
		Если ВыбранныйЭлемент = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Индекс = ВыбранныйЭлемент.Значение;
		Адрес = Результат[Индекс].АдресЭП;
		Представление = Результат[Индекс].Представление;
	КонецЕсли;

	Позиция = Найти(Представление, "<");
	Представление = ?(Позиция= 0, "", СокрЛП(Лев(Представление, Позиция-1)));

	ТекущиеДанные.Адрес = Адрес;
	Если Не ПустаяСтрока(Представление) Тогда
		ТекущиеДанные.Представление = Представление;
	КонецЕсли;

КонецПроцедуры

//Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
//из списка "Контакты по предмету".
//
&НаКлиенте
Процедура УстановитьКонтактИзСпискаПредметовВыполнить()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьКонтактВСпискеПолучателей(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПереместитьИзВыбранногоВСписокВсе(Команда)
	
	ПолучателиПисьма.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьИзВыбранногоВСписок(Команда)
	
	ВыделенныеСтроки = Элементы.ПолучателиПисьма.ВыделенныеСтроки;
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ПолучателиПисьма.Удалить(ПолучателиПисьма.НайтиПоИдентификатору(ВыделеннаяСтрока));
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьИзСпискаВВыбранное(Команда)
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов Тогда
		
		Для каждого ВыделеннаяСтрока Из Элементы.НайденныеКонтакты.ВыделенныеСтроки Цикл
		
			ДанныеСтроки = Элементы.НайденныеКонтакты.ДанныеСтроки(ВыделеннаяСтрока);
			ДобавитьПолучателя(ДанныеСтроки.Представление, ДанныеСтроки.НаименованиеКонтакта, ДанныеСтроки.Ссылка);
		
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	НомерЭлементаФормы = Неопределено;
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 1 Тогда
		
		НомерЭлементаФормы = 0;
		
		
	ИначеЕсли Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 2 Тогда
		
		Если ТекущийЭлемент.Имя = "ПереместитьИзВерхнегоСпискаВВыбранное" Тогда
			
			НомерЭлементаФормы = 0;
			
		Иначе
			
			НомерЭлементаФормы = 1;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НомерЭлементаФормы = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПеренестиВыделенныеСтроки(
		Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы[НомерЭлементаФормы].ВыделенныеСтроки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции осуществления поиска

// Осуществляет поиск контактов по доменному имени или по адресу электронной почты.
// 
&НаСервере
Процедура НайтиПоEmail(ПоДомену)
	
	Взаимодействия.НайтиПоEmail(СтрокаПоиска, ПоДомену ,ЭтаФорма);
	
КонецПроцедуры

//Осуществляет поиск контактов по строке
//
&НаСервере
Функция КонтактыНайденныеПоСтроке()
	
	Возврат Взаимодействия.ОсуществитьПоискКонтактовПоСтроке(ЭтаФорма, Истина);
	
КонецФункции

// Осуществляет поиск контактов по началу наименования
//
&НаСервере
Процедура НайтиПоНачалуНаименования()
	
	Взаимодействия.ПолучитьВсеКонтактыПоНачалуНаименованияСАдресамиЭлектроннойПочты(СтрокаПоиска, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьТаблицуПолучателей()
	
	табПолучатели = РеквизитФормыВЗначение("ПолучателиПисьма");
	
	Для Каждого ГруппаВыбранных Из Параметры.СписокВыбранных Цикл
		Если ГруппаВыбранных.Значение <> Неопределено Тогда
			Для Каждого Элемент Из ГруппаВыбранных.Значение Цикл
				НоваяСтрока = табПолучатели.Добавить();
				НоваяСтрока.Группа = ГруппаВыбранных.Представление;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	табПолучатели.Сортировать("Группа");
	
	Если табПолучатели.Количество() > 0 Тогда
		ТаблицаАдресов =
			Взаимодействия.ПолучитьАдресаЭлектроннойПочтыДляМассиваКонтактов(табПолучатели.ВыгрузитьКолонку("Контакт"));
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ПолучателиПисьма.Адрес,
			|	ПолучателиПисьма.Представление,
			|	ПолучателиПисьма.Контакт,
			|	ПолучателиПисьма.Группа
			|ПОМЕСТИТЬ ПолучателиПисьма
			|ИЗ
			|	&ПолучателиПисьма КАК ПолучателиПисьма
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КонтактыАдреса.Контакт,
			|	КонтактыАдреса.СписокАдресов
			|ПОМЕСТИТЬ КонтактыСписокАдресов
			|ИЗ
			|	&КонтактыАдреса КАК КонтактыАдреса
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПолучателиПисьма.Адрес,
			|	ПолучателиПисьма.Представление,
			|	ПолучателиПисьма.Контакт,
			|	ПолучателиПисьма.Группа,
			|	ЕСТЬNULL(КонтактыСписокАдресов.СписокАдресов, """") КАК СписокАдресов
			|ИЗ
			|	ПолучателиПисьма КАК ПолучателиПисьма
			|		ЛЕВОЕ СОЕДИНЕНИЕ КонтактыСписокАдресов КАК КонтактыСписокАдресов
			|		ПО КонтактыСписокАдресов.Контакт = ПолучателиПисьма.Контакт";
			
			Запрос.УстановитьПараметр("ПолучателиПисьма", табПолучатели);
			Запрос.УстановитьПараметр("КонтактыАдреса", ТаблицаАдресов);
			
			табПолучатели = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(табПолучатели, "ПолучателиПисьма");
	
КонецПроцедуры

//Добавляет строку в таблицу "Получатели письма" и заполняет ее согласно переданным параметрам.
//
//Параметры
//  Адрес        - Строка - адрес электронной почты.
//  Наименование - Строка - Представление адресата.
//  Контакт      - СправочникСсылка - контакт получатель.
//
&НаКлиенте
Процедура ДобавитьПолучателя(Адрес, Наименование, Контакт,СписокАдресов = "")
	
	НоваяСтрока = ПолучателиПисьма.Добавить();
	НоваяСтрока.Адрес         = Адрес;
	НоваяСтрока.Представление = Наименование;
	НоваяСтрока.Контакт       = Контакт;
	НоваяСтрока.СписокАдресов = СписокАдресов;
	НоваяСтрока.Группа        = ГруппаПоУмолчанию;
	
КонецПроцедуры

// Добавляет в таблицу получателей письма выбранную строку из списка "Контакты по предмету"
//
&НаКлиенте
Процедура ДобавитьПолучателяИзСпискаПоПредмету()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.ПолучитьНаименованиеИАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Ссылка);
	Если Результат <> Неопределено И Результат.Адреса.Количество() > 0 Тогда
		СписокАдресов = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Результат.Адреса, ";");
	Иначе
		СписокАдресов = "";
	КонецЕсли;
	
	ДобавитьПолучателя(ТекущиеДанные.Адрес, ТекущиеДанные.Наименование, ТекущиеДанные.Ссылка, СписокАдресов);
	
КонецПроцедуры

//Позиционируется на заданном контакте в списке получателей письма
//
//Параметры
//  Контакт - СправочникСсылка - контакт, на котором необходимо спозиционироваться.
//
&НаКлиенте
Процедура УстановитьКонтактВСпискеПолучателей(Контакт)
	
	Если ЗначениеЗаполнено(Контакт) И Элементы.ПолучателиПисьма.ТекущиеДанные <> Неопределено Тогда
		Элементы.ПолучателиПисьма.ТекущиеДанные.Контакт = Контакт;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает текущим контакт в соответствующем динамическом списке.
//
//Параметры
//  Контакт  - СправочникСсылка - контакт, на котором необходимо спозиционироваться.
//
&НаСервере
Процедура УстановитьТекущимКонтакт(Контакт)
	
	Взаимодействия.УстановитьТекущимКонтакт(Контакт, ЭтаФорма);
	
КонецПроцедуры

//Изменяет группу получателей письма.
//
//Параметры
//  ИмяГруппы  - Строка - имя группы, которое будет установлено выделенным получателям письма.
//
&НаКлиенте
Процедура ИзменитьГруппу(ИмяГруппы)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ПолучателиПисьма.ВыделенныеСтроки Цикл
		Элемент = ПолучателиПисьма.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Элемент.Группа = ИмяГруппы;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиВыделенныеСтроки(ЗНАЧ ВыделенныеСтроки)

	Результат = Взаимодействия.ПолучитьАдресаЭлектроннойПочтыДляМассиваКонтактов(ВыделенныеСтроки, ГруппаПоУмолчанию);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Результат, ПолучателиПисьма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьГруппуПоУмолчанию()
	
	Если Параметры.Свойство("ГруппаПоУмолчанию") Тогда
		ГруппаПоУмолчанию = Параметры.ГруппаПоУмолчанию;
	КонецЕсли;
	Если ПустаяСтрока(ГруппаПоУмолчанию) Тогда
		ГруппаПоУмолчанию = НСтр("ru = 'Кому'");
	КонецЕсли;
	
КонецПроцедуры 

// Управляет доступностью элементов формы
&НаКлиенте
Процедура УправлениеДоступностью()

	Элементы.КомандаОбновитьИндексППД.Доступность = Не ИндексАктуален;

КонецПроцедуры

&НаКлиенте
Процедура УправлениеСтраницами()

	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаВсеКонтактыПоПредмету ИЛИ 
		Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов ИЛИ 
		Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 1 ИЛИ
		(Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПользователей И 
		(НЕ ИспользоватьГруппыПользователей))Тогда
		
		Элементы.СтраницыПереместить.ТекущаяСтраница = Элементы.СтраницаПереместитьОднаТаблица;
		
	Иначе
		
		Элементы.СтраницыПереместить.ТекущаяСтраница = Элементы.СтраницаПереместитьДвеТаблицы;
		
	КонецЕсли;

КонецПроцедуры 
