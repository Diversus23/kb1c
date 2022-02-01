////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Имя типа дополнительных отчетов и обработок - "печатная форма".
//
Функция ВидОбработкиПечатнаяФорма() Экспорт
	
	Возврат "ПечатнаяФорма"; // не локализуется
	
КонецФункции

// Имя типа дополнительных отчетов и обработок - "заполнение объекта".
//
Функция ВидОбработкиЗаполнениеОбъекта() Экспорт
	
	Возврат "ЗаполнениеОбъекта"; // не локализуется
	
КонецФункции

// Имя типа дополнительных отчетов и обработок - "создание связанных объектов".
//
Функция ВидОбработкиСозданиеСвязанныхОбъектов() Экспорт
	
	Возврат "СозданиеСвязанныхОбъектов"; // не локализуется
	
КонецФункции

// Имя типа дополнительных отчетов и обработок - "назначаемый отчет".
//
Функция ВидОбработкиОтчет() Экспорт
	
	Возврат "Отчет"; // не локализуется
	
КонецФункции

// Имя типа дополнительных отчетов и обработок - "дополнительная обработка".
//
Функция ВидОбработкиДополнительнаяОбработка() Экспорт
	
	Возврат "ДополнительнаяОбработка"; // не локализуется
	
КонецФункции

// Имя типа дополнительных отчетов и обработок - "дополнительный отчет".
//
Функция ВидОбработкиДополнительныйОтчет() Экспорт
	
	Возврат "ДополнительныйОтчет"; // не локализуется
	
КонецФункции

// Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
//
Функция ФильтрДиалоговВыбораИСохранения() Экспорт
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");
	Возврат Фильтр;
	
КонецФункции

// Идентификатор, который используется для рабочего стола
//
Функция ИдентификаторРабочегоСтола() Экспорт
	
	Возврат "РабочийСтол"; // не локализуется
	
КонецФункции

// Наименование подсистемы.
//
Функция НаименованиеПодсистемы(КодЯзыка) Экспорт
	
	Возврат НСтр("ru = 'Дополнительные отчеты и обработки'", ?(КодЯзыка = Неопределено, ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(), КодЯзыка));
	
КонецФункции

// Идентификатор формы списка.
//
Функция ТипФормыСписка() Экспорт
	
	Возврат "ФормаСписка"; // не локализуется
	
КонецФункции

// Идентификатор формы объекта.
//
Функция ТипФормыОбъекта() Экспорт
	
	Возврат "ФормаОбъекта"; // не локализуется
	
КонецФункции

// Имя типа команд "вызов клиентского метода".
//
Функция ТипКомандыВызовКлиентскогоМетода() Экспорт
	
	Возврат "ВызовКлиентскогоМетода"; // не локализуется
	
КонецФункции

// Имя типа команд "вызов серверного метода".
//
Функция ТипКомандыВызовСерверногоМетода() Экспорт
	
	Возврат "ВызовСерверногоМетода"; // не локализуется
	
КонецФункции

// Имя типа команд "открытие формы".
//
Функция ТипКомандыОткрытиеФормы() Экспорт
	
	Возврат "ОткрытиеФормы"; // не локализуется
	
КонецФункции

// Имя типа команд "заполнение формы".
//
Функция ТипКомандыЗаполнениеФормы() Экспорт
	
	Возврат "ЗаполнениеФормы"; // не локализуется
	
КонецФункции

// Имя типа команд "Сценарий в безопасном режиме".
//
Функция ТипКомандыСценарийВБезопасномРежиме() Экспорт
	
	Возврат "СценарийВБезопасномРежиме"; // не локализуется
	
КонецФункции

