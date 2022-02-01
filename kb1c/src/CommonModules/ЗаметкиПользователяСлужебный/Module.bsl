////////////////////////////////////////////////////////////////////////////////
// Подсистема "Заметки пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.НапоминанияПользователя\ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания"].Добавить(
			"ЗаметкиПользователяСлужебный");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
// установки напоминаний: дата документа или задачи и прочие.
// 
// Параметры
//  Источник	 - Любая ссылка - Ссылка на объект, для которого формируется массив реквизитов с датами
//  МассивРеквизитов - Массив - Массив имён реквизитов (из метаданных), содержащих даты
//
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	
	Если ТипЗнч(Источник) = Тип("СправочникСсылка.Заметки") Тогда
		МассивРеквизитов.Очистить();
	КонецЕсли;
	
КонецПроцедуры
