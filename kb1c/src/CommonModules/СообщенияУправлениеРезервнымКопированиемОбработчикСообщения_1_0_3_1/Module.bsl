////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 1.0.3.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УПРАВЛЕНИЯ РЕЗЕРВНЫМ КОПИРОВАНИЕМ ОБЛАСТЕЙ ДАННЫХ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ManageZonesBackup/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "1.0.3.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияУправлениеРезервнымКопированиемИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеПланироватьАрхивациюОбласти(Пакет()) Тогда
		ПланироватьАрхивациюОбласти(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОбновитьНастройкиПериодическогоРезервногоКопирования(Пакет()) Тогда
		ОбновитьНастройкиПериодическогоРезервногоКопирования(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтменитьПериодическоеРезервноеКопирование(Пакет()) Тогда
		ОтменитьПериодическоеРезервноеКопирование(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПланироватьАрхивациюОбласти(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУправлениеРезервнымКопированиемРеализация.ПланироватьСозданиеРезервнойКопииОбласти(
		ТелоСообщения.Zone,
		ТелоСообщения.BackupId,
		ТелоСообщения.Date,
		Истина);
	
КонецПроцедуры

Процедура ОбновитьНастройкиПериодическогоРезервногоКопирования(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	
	Настройки = Новый Структура;
	Настройки.Вставить("СоздаватьЕжедневные", ТелоСообщения.CreateDailyBackup);
	Настройки.Вставить("СоздаватьЕжемесячные", ТелоСообщения.CreateMonthlyBackup);
	Настройки.Вставить("СоздаватьЕжегодные", ТелоСообщения.CreateYearlyBackup);
	Настройки.Вставить("ТолькоПриАктивностиПользователей", ТелоСообщения.CreateBackupOnlyAfterUsersActivity);
	Настройки.Вставить("НачалоИнтервалаФормированияКопий", ТелоСообщения.BackupCreationBeginTime);
	Настройки.Вставить("ОкончаниеИнтервалаФормированияКопий", ТелоСообщения.BackupCreationEndTime);
	Настройки.Вставить("ДеньСозданияЕжемесячных", ТелоСообщения.MonthlyBackupCreationDay);
	Настройки.Вставить("МесяцСозданияЕжегодных", ТелоСообщения.YearlyBackupCreationMonth);
	Настройки.Вставить("ДеньСозданияЕжегодных", ТелоСообщения.YearlyBackupCreationDay);
	Настройки.Вставить("ДатаСозданияПоследнейЕжедневной", ТелоСообщения.LastDailyBackupDate);
	Настройки.Вставить("ДатаСозданияПоследнейЕжемесячной", ТелоСообщения.LastMonthlyBackupDate);
	Настройки.Вставить("ДатаСозданияПоследнейЕжегодной", ТелоСообщения.LastYearlyBackupDate);
	
	СообщенияУправлениеРезервнымКопированиемРеализация.ОбновитьНастройкиПериодическогоРезервногоКопирования(
		ТелоСообщения.Zone,
		Настройки);
	
КонецПроцедуры

Процедура ОтменитьПериодическоеРезервноеКопирование(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	
	СообщенияУправлениеРезервнымКопированиемРеализация.ОтменитьПериодическоеРезервноеКопирование(
		ТелоСообщения.Zone);
	
КонецПроцедуры
