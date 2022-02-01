////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = Пользователи.ТекущийПользователь();
	СписокФайлов.Параметры.УстановитьЗначениеПараметра("Редактирует", Пользователь);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиСлужебныйВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	ЗавершениеРаботыПрограммы = Неопределено;
	Если Параметры.Свойство("ЗавершениеРаботыПрограммы", ЗавершениеРаботыПрограммы) Тогда 
		Ответ = ЗавершениеРаботыПрограммы;
		Если Ответ = Истина тогда
			Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость 	= Ответ;
			Элементы.ГруппаКоманднойПанели.Видимость 						= Ответ;
		КонецЕсли;	
	КонецЕсли;	
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

// Обработка события Выбор у списка 
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ОткрытьФайл(РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока, Неопределено, УникальныйИдентификатор)); 
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		УстановитьДоступностьКоманд(Ложь);
	Иначе
		УстановитьДоступностьКоманд(Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РедактируетТекущийПользователь = Истина;
	
	РаботаСФайламиКлиент.ЗакончитьРедактирование(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует,
		Элементы.Список.ТекущиеДанные.Автор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РедактируетТекущийПользователь = Истина;
	
	РаботаСФайламиКлиент.ОсвободитьФайл(
		Элементы.Список.ТекущаяСтрока,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОпубликоватьФайл(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Элементы.Список.ТекущаяСтрока, 
		Неопределено, 
		УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(
		Элементы.Список.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	МассивСтруктур = Новый Массив;
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
	    ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
		
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	Закрыть();	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьКоманд(Доступность)
	Элементы.ЗакончитьРедактирование.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = Доступность;
	
	Элементы.ОткрытьФайл.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Доступность;
	
	Элементы.Изменить.Доступность = Доступность;
	
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОсвободить.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Доступность;
КонецПроцедуры

Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции


