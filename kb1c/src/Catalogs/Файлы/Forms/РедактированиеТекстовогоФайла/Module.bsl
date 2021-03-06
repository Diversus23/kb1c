////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.Файл;
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяОткрываемогоФайла = Параметры.ИмяОткрываемогоФайла;
	
	КодФайла = Файл.Код;
	
	Если ДанныеФайла.РедактируетТекущийПользователь Тогда
		РежимРедактирования = Истина;
	КонецЕсли;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Видимость = Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
	Элементы.ПоказатьОтличия.Доступность = РежимРедактирования;
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		Элементы.Редактировать.Доступность = Ложь;
	КонецЕсли;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
	Если ЗначениеЗаполнено(ДанныеФайла.Версия) Тогда
		КодировкаТекстаФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьКодировкуВерсииФайла(
			ДанныеФайла.Версия);
		
		Если ЗначениеЗаполнено(КодировкаТекстаФайла) Тогда
			СписокКодировок = РаботаСФайламиСлужебный.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаТекстаФайла);
			Если ЭлементСписка = Неопределено Тогда
				КодировкаПредставление = КодировкаТекстаФайла;
			Иначе
				КодировкаПредставление = ЭлементСписка.Представление;
			КонецЕсли;
		Иначе
			КодировкаПредставление = НСтр("ru='По умолчанию'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлючУникальности = КодФайла;
	
	КодировкаТекстаДляЧтения = КодировкаТекстаФайла;
	Если Не ЗначениеЗаполнено(КодировкаТекстаДляЧтения) Тогда
		КодировкаТекстаДляЧтения = Неопределено;
	КонецЕсли;
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаДляЧтения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ФайлРедактировался" И Источник = Файл Тогда
		РежимРедактирования = Истина;
		УстановитьДоступностьКоманд();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" И Источник = Файл Тогда
		
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Файл);
		
		РежимРедактирования = Ложь;
		
		Если ДанныеФайла.РедактируетТекущийПользователь Тогда
			РежимРедактирования = Истина;
		КонецЕсли;
		
		Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
			РежимРедактирования = Ложь;
		КонецЕсли;
		
		УстановитьДоступностьКоманд();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ИмяИРасширение = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
			
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru ='Файл ""%1"" был изменен.'"), ИмяИРасширение);
			
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстВопроса", ТекстВопроса);
		
		ОткрытьФорму("Справочник.Файлы.Форма.ВопросПриВыходеИзТекстовогоРедактора", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВопросПриВыходеИзТекстовогоРедактора") Тогда
		
		Если ВыбранноеЗначение = "СохранитьИЗакончитьРедактирование" Тогда
			ЗаписатьТекст();
			РаботаСФайламиКлиент.ЗакончитьРедактирование(
				Файл,
				УникальныйИдентификатор,
				Неопределено,
				Неопределено,
				Неопределено,
				Неопределено,
				КодировкаТекстаФайла);
			Модифицированность = Ложь;
			Закрыть();
		ИначеЕсли ВыбранноеЗначение = "СохранитьИзменения" Тогда
			ЗаписатьТекст();
			Модифицированность = Ложь;
			Закрыть();
		ИначеЕсли ВыбранноеЗначение = "НеСохранять" Тогда
			Модифицированность = Ложь;
			Закрыть();
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий") Тогда
		
		Если ВыбранноеЗначение <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		
		// Повторное чтение настройки
		СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
		Если СпособСравненияВерсийФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВыборКодировки") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		
		ПрочитатьТекст();
		
		РаботаСФайламиСлужебныйВызовСервера.ЗаписатьКодировкуВерсииФайлаИИзвлеченныйТекст(
			ДанныеФайла.Версия,
			КодировкаТекстаФайла,
			Текст.ПолучитьТекст());
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	// выбираем путь к файлу на диске
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	
	ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	ВыборФайла.ПолноеИмяФайла = ИмяСРасширением;
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), ДанныеФайла.Расширение, ДанныеФайла.Расширение);
	ВыборФайла.Фильтр = Фильтр;
	
	Если ВыборФайла.Выбрать() Тогда
		
		ВыбранноеПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;
		
		Текст.Записать(ВыбранноеПолноеИмяФайла, КодировкаТекстаДляЗаписи);
		
		Состояние(НСтр("ru = 'Файл успешно сохранен'"), , ВыбранноеПолноеИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьЗначение(Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРедактор(Команда)
	
	ЗаписатьТекст();
	РаботаСФайламиСлужебныйКлиент.ВыполнитьЗапускПриложения(ИмяОткрываемогоФайла);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСФайламиКлиент.Редактировать(Файл, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ЗаписатьТекст();
	
	РаботаСФайламиКлиент.ЗакончитьРедактирование(
		Файл,
		УникальныйИдентификатор,
		Неопределено,
		Неопределено,
		Неопределено,
		Неопределено,
		КодировкаТекстаФайла);
	
	РежимРедактирования = Ложь;
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Команда)
	
	#Если НЕ ВебКлиент Тогда
		// Чтение настройки
		СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
		
		Если СпособСравненияВерсийФайлов = Неопределено Тогда 
			// Инициализация настройки
			ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий", , ЭтаФорма);
			Возврат;
		КонецЕсли;
		
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
	#Иначе
		Предупреждение(НСтр("ru = 'Сравнение версий в веб-клиенте не поддерживается.'"));
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		ЗаписатьТекст();
		
		РаботаСФайламиКлиент.ЗакончитьРедактирование(
			Файл,
			УникальныйИдентификатор,
			Неопределено,
			Неопределено,
			Неопределено,
			Неопределено,
			КодировкаТекстаФайла);
		
		РежимРедактирования = Ложь;
		УстановитьДоступностьКоманд();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаписатьТекст()
	
	Если Модифицированность Тогда
		
		КодировкаТекстаДляЗаписи = КодировкаТекстаФайла;
		Если Не ЗначениеЗаполнено(КодировкаТекстаДляЗаписи) Тогда
			КодировкаТекстаДляЗаписи = Неопределено;
		КонецЕсли;
		
		Текст.Записать(ИмяОткрываемогоФайла, КодировкаТекстаДляЗаписи);
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Элементы.Текст.ТолькоПросмотр = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Доступность = РежимРедактирования;
	Элементы.Редактировать.Доступность = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность = РежимРедактирования;
	Элементы.Записать.Доступность = РежимРедактирования;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + НСтр("ru=' (только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекст()
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов)
	#Если НЕ ВебКлиент Тогда
		
		ЗаписатьТекст();
		
		ДанныеФайлаДляСохранения = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
			Файл, Неопределено, УникальныйИдентификатор);
		
		АдресФайла = ДанныеФайлаДляСохранения.НавигационнаяСсылкаТекущейВерсии;
		
		Если ДанныеФайла.ТекущаяВерсия <> ДанныеФайла.Версия Тогда
			АдресФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(
				ДанныеФайла.Версия, УникальныйИдентификатор);
		КонецЕсли;
		
		ПутьКФайлу = ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение);
		
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПутьКФайлу, АдресФайла);
		ПередаваемыеФайлы.Добавить(Описание);
		
		// Сохраним Файл из БД на диск
		Если Не ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(ПутьКФайлу, ИмяОткрываемогоФайла, СпособСравненияВерсийФайлов);
		
	#КонецЕсли
КонецПроцедуры
