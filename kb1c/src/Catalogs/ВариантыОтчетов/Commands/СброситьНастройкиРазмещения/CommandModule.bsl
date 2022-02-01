////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(МассивВариантов, ПараметрыВыполненияКоманды)
	ОбщееКоличество = МассивВариантов.Количество();
	Если ОбщееКоличество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отфильтровать(МассивВариантов);
	КоличествоПредопределенных = МассивВариантов.Количество();
	
	Если КоличествоПредопределенных = 0 Тогда
		Предупреждение(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сброс настроек выбранных вариантов отчетов (%1 шт) не требуется по ряду причин:
				|- Выбраны только пользовательские варианты отчетов.
				|- Выбранные варианты отчетов помечены на удаление.
				|- Выбраны варианты дополнительных или внешних отчетов.'"),
				Формат(КоличествоПредопределенных, "ЧГ=")));
		Возврат;
	КонецЕсли;
	
	ТекстВопроса =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Внимание, операция ""Сбросить настройки размещения"" необратима.
		|
		|Нажмите ""Продолжить"" что бы сбросить настройки размещения,
		|видимости и доступности выбранных вариантов отчетов (%1 шт).'"),
		Формат(КоличествоПредопределенных, "ЧГ="));
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(1, НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	Ответ = Вопрос(ТекстВопроса, Кнопки, , КодВозвратаДиалога.Отмена);
	Если Ответ <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	СброситьНастройкиРазмещенияСервер(МассивВариантов);
	Если КоличествоПредопределенных = 1 Тогда
		ВариантСсылка = МассивВариантов[0];
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сброшены настройки размещения варианта отчета'"),
			ПолучитьНавигационнуюСсылку(ВариантСсылка),
			Строка(ВариантСсылка));
	Иначе
		ПоказатьОповещениеПользователя(
			,
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сброшены настройки размещения
				|вариантов отчетов (%1 шт.).'"),
				Формат(МассивВариантов.Количество(), "ЧН=0; ЧГ=0")));
	КонецЕсли;
	
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция СброситьНастройкиРазмещенияСервер(МассивВариантов)
	НачатьТранзакцию();
	Для Каждого ВариантСсылка Из МассивВариантов Цикл
		ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
		ВариантОбъект.ВидимостьПоУмолчаниюПереопределена = Ложь;
		ВариантОбъект.ВидимостьПоУмолчанию = ВариантОбъект.ПредопределенныйВариант.ВидимостьПоУмолчанию;
		ВариантОбъект.Размещение.Очистить();
		ВариантОбъект.Записать();
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецФункции

&НаСервере
Процедура Отфильтровать(МассивВариантов)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов", МассивВариантов);
	Запрос.УстановитьПараметр("ТипОтчета", Перечисления.ТипыОтчетов.Внутренний);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВариантыОтчетовРазмещение.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетовРазмещение
	|ГДЕ
	|	ВариантыОтчетовРазмещение.Ссылка В(&МассивВариантов)
	|	И ВариантыОтчетовРазмещение.Пользовательский = ЛОЖЬ
	|	И ВариантыОтчетовРазмещение.ТипОтчета = &ТипОтчета
	|	И ВариантыОтчетовРазмещение.ПометкаУдаления = ЛОЖЬ";
	
	МассивВариантов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецПроцедуры

