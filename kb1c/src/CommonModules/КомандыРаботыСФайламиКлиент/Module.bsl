////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
// Устаревший модуль. Будет удален в следующей редакции БСП.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
// Устаревший программный интерфейс. Будет удален в следующей редакции БСП.

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура ЗакончитьРедактирование(
	ПараметрКоманды,
	ИдентификаторФормы,
	Знач ХранитьВерсии = Неопределено,
	Знач РедактируетТекущийПользователь = Неопределено,
	Знач Редактирует = Неопределено,
	Знач АвторТекущейВерсии = Неопределено,
	Знач Кодировка = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.ЗакончитьРедактирование(
		ПараметрКоманды,
		ИдентификаторФормы,
		ХранитьВерсии,
		РедактируетТекущийПользователь,
		Редактирует,
		АвторТекущейВерсии,
		Кодировка);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура Редактировать(ОбъектСсылка,
                        УникальныйИдентификатор = Неопределено,
                        РабочийКаталогВладельца = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.Редактировать(
		ОбъектСсылка,
		УникальныйИдентификатор,
		РабочийКаталогВладельца);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура Занять(ПараметрКоманды, УникальныйИдентификатор = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.Занять(ПараметрКоманды, УникальныйИдентификатор);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура ОсвободитьФайл(
	ПараметрКоманды,
	Знач ХранитьВерсии = Неопределено,
	Знач РедактируетТекущийПользователь = Неопределено,
	Знач Редактирует = Неопределено,
	УникальныйИдентификатор = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.ОсвободитьФайл(
		ПараметрКоманды,
		ХранитьВерсии,
		РедактируетТекущийПользователь,
		Редактирует,
		УникальныйИдентификатор);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура Открыть(ДанныеФайла) Экспорт
	
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура ОпубликоватьФайл(ПараметрКоманды, ИдентификаторФормы) Экспорт
	
	РаботаСФайламиКлиент.ОпубликоватьФайл(ПараметрКоманды, ИдентификаторФормы);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура ОткрытьКаталогФайла(ДанныеФайла) Экспорт
	
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура СохранитьКак(ДанныеФайла, УникальныйИдентификатор = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура ОбновитьИзФайлаНаДиске(ДанныеФайла, ИдентификаторФормы) Экспорт
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, ИдентификаторФормы);
	
КонецПроцедуры

// Устарела. Следует использовать вызываемую функцию. Будет удалена в следующей редакции БСП.
Функция СформироватьПодписьФайла(ДанныеФайла, ДанныеПодписи) Экспорт
	
	Возврат РаботаСФайламиКлиент.СформироватьПодписьФайла(ДанныеФайла, ДанныеПодписи);
	
КонецФункции

// Устарела. Следует использовать вызываемую функцию. Будет удалена в следующей редакции БСП.
Функция Зашифровать(ДанныеФайла,
                    УникальныйИдентификатор,
                    МассивДанныхДляЗанесенияВБазу,
                    МассивОтпечатков) Экспорт
	
	Возврат РаботаСФайламиКлиент.Зашифровать(
		ДанныеФайла,
		УникальныйИдентификатор,
		МассивДанныхДляЗанесенияВБазу,
		МассивОтпечатков);
	
КонецФункции

// Устарела. Следует использовать вызываемую функцию. Будет удалена в следующей редакции БСП.
Функция Расшифровать(ДанныеФайла, УникальныйИдентификатор, МассивДанныхДляЗанесенияВБазу) Экспорт
	
	Возврат РаботаСФайламиКлиент.Расшифровать(
		ДанныеФайла, УникальныйИдентификатор, МассивДанныхДляЗанесенияВБазу);
	
КонецФункции

// Устарела. Следует использовать вызываемую функцию. Будет удалена в следующей редакции БСП.
Функция ДобавитьЭЦПИзФайла(ДанныеФайла, УникальныйИдентификатор = Неопределено) Экспорт
	
	Возврат РаботаСФайламиКлиент.ДобавитьЭЦПИзФайла(ДанныеФайла, УникальныйИдентификатор);
	
КонецФункции

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Процедура СохранитьВместеСЭЦП(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
	РаботаСФайламиКлиент.СохранитьВместеСЭЦП(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры
