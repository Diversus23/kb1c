////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
			"ФайловыеФункцииСлужебныйВМоделиСервиса");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииПсевдонимовОбработчиков"].Добавить(
				"ФайловыеФункцииСлужебныйВМоделиСервиса");
	
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииИспользованияРегламентныхЗаданий"].Добавить(
				"ФайловыеФункцииСлужебныйВМоделиСервиса");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриОпределенииПсевдонимовОбработчиков.
//
// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных
//    В качестве значения можно указать Неопределено, в этом случае считается что имя 
//    совпадает с псевдонимом
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("ФайловыеФункцииСлужебный.ИзвлечьТекстИзФайловНаСервере");
	
КонецПроцедуры

// Формирует таблицу регламентных заданий
// с признаком использования в модели сервиса
//
// Параметры:
// ТаблицаИспользования - ТаблицаЗначений - таблица, которую необходимо 
// заполнить регламентными заданиями и признаком использования, колонки:
//  РегламентноеЗадание - Строка - имя предопределенного регламентного задания
//  Использование - Булево - Истина, если регламентное задание должно
//   выполняться в модели сервиса. Ложь - если не должно.
//
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
	НоваяСтрока = ТаблицаИспользования.Добавить();
	НоваяСтрока.РегламентноеЗадание = "ПланированиеИзвлеченияТекстаВМоделиСервиса";
	НоваяСтрока.Использование       = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Стандартный программный интерфейс

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.2.4";
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ЗаполнитьОчередьИзвлеченияТекста";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.19";
	Обработчик.Процедура = "ФайловыеФункцииСлужебныйВМоделиСервиса.ПеренестиОчередьИзвлеченияТекстаВоВспомогательныеДанные";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Добавляет и удаляет записи в регистр сведений ОчередьИзвлеченияТекста при изменении
// состояние извлечения текста версий файлов
//
// Параметры:
//	ИсточникТекста - СправочникСсылка.ВерсииФайлов, СправочникСсылка.*ПрисоединенныеФайлы,
//		файл, у которого изменилось состояние извлечения текста
//	СостояниеИзвлеченияТекста - ПеречислениеСсылка.СтатусыИзвлеченияТекстаФайлов, новый
//		статус извлечения текста у файла
//
Процедура ОбновитьСостояниеОчередиИзвлеченияТекста(ИсточникТекста, СостояниеИзвлеченияТекста) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(ОбщегоНазначения.ЗначениеРазделителяСеанса());
	НаборЗаписей.Отбор.ИсточникТекста.Установить(ИсточникТекста);
	
	Если СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен
			ИЛИ СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ПустаяСсылка() Тогда
			
		Запись = НаборЗаписей.Добавить();
		Запись.ОбластьДанныхВспомогательныеДанные = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Запись.ИсточникТекста = ИсточникТекста.Ссылка;
			
	КонецЕсли;
		
	НаборЗаписей.Записать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Извлечение текста

// Определяет перечень областей данных, в которых требуется извлечение текста и планирует
// для них его выполнение с использованием очереди заданий
//
Процедура ОбработатьОчередьИзвлеченияТекста() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяРазделенногоМетода = "ФайловыеФункцииСлужебный.ИзвлечьТекстИзФайловНаСервере";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
	|	ВЫБОР
	|		КОГДА ЧасовыеПояса.Значение = """"
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЕСТЬNULL(ЧасовыеПояса.Значение, НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ КАК ЧасовойПояс
	|ИЗ
	|	РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ЧасовыеПояса.ОбластьДанныхВспомогательныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ОбластиДанных.ОбластьДанныхВспомогательныеДанные
	|ГДЕ
	|	НЕ ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные В (&ОбрабатываемыеОбластиДанных)
	|	И ОбластиДанных.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбластейДанных.Используется)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОбрабатываемыеОбластиДанных", ОчередьЗаданий.ПолучитьЗадания(
		Новый Структура("ИмяМетода", ИмяРазделенногоМетода)));
	
	Выборка = ОбщегоНазначения.ВыполнитьЗапросВнеТранзакции(Запрос).Выбрать();
	Пока Выборка.Следующий() Цикл
		// Проверка блокировки области
		Если РаботаВМоделиСервиса.ОбластьДанныхЗаблокирована(Выборка.ОбластьДанных) Тогда
			// Область заблокирована, перейти к следующей записи
			Продолжить;
		КонецЕсли;
		
		НовоеЗадание = Новый Структура();
		НовоеЗадание.Вставить("ОбластьДанных", Выборка.ОбластьДанных);
		НовоеЗадание.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(ТекущаяУниверсальнаяДата(), Выборка.ЧасовойПояс));
		НовоеЗадание.Вставить("ИмяМетода", ИмяРазделенногоМетода);
		ОчередьЗаданий.ДобавитьЗадание(НовоеЗадание);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Заполняет очередь извлечения текста для текущей области данных. Используется для начального заполнения при обновлении.
Процедура ЗаполнитьОчередьИзвлеченияТекста() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "";
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииТекстаЗапросаДляИзвлеченияТекста");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииТекстаЗапросаДляИзвлеченияТекста(ТекстЗапроса, Истина);
	КонецЦикла;
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьСостояниеОчередиИзвлеченияТекста(Выборка.Ссылка, Выборка.СтатусИзвлеченияТекста);
	КонецЦикла;
	
КонецПроцедуры

// Переносит флаг необходимости выполнения извлечения текста в областях
// данных из РС УдалитьОчередьИзвлеченияТекста в РС ОчередьИзвлеченияТекста
//
Процедура ПеренестиОчередьИзвлеченияТекстаВоВспомогательныеДанные() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		БлокировкаРегистра = Блокировка.Добавить("РегистрСведений.ОчередьИзвлеченияТекста");
		БлокировкаРегистра.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные, УдалитьОчередьИзвлеченияТекста.ОбластьДанных) КАК ОбластьДанныхВспомогательныеДанные,
		|	ЕСТЬNULL(ОчередьИзвлеченияТекста.ИсточникТекста, УдалитьОчередьИзвлеченияТекста.ИсточникТекста) КАК ИсточникТекста
		|ИЗ
		|	РегистрСведений.УдалитьОчередьИзвлеченияТекста КАК УдалитьОчередьИзвлеченияТекста
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
		|		ПО УдалитьОчередьИзвлеченияТекста.ОбластьДанных = ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные
		|			И УдалитьОчередьИзвлеченияТекста.ИсточникТекста = ОчередьИзвлеченияТекста.ИсточникТекста";
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Набор = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
		Набор.Загрузить(Запрос.Выполнить().Выгрузить());
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

