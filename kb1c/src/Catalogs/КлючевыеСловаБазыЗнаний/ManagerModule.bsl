Функция ПолучитьКлючевоеСловоПоНаименованию(Наименование, знач Описание = "") Экспорт
	
	Наименование	= СокрЛП(Наименование);
	ЭлементСсылка	= Справочники.КлючевыеСловаБазыЗнаний.НайтиПоНаименованию(Наименование, Истина);
	Если НЕ ЗначениеЗаполнено(ЭлементСсылка) Тогда
		ЭлементОбъект = Справочники.КлючевыеСловаБазыЗнаний.СоздатьЭлемент();
		ЭлементОбъект.ОбменДанными.Загрузка = Истина;
		ЭлементОбъект.Наименование	= Наименование;
		ЭлементОбъект.Описание		= Описание;
		ЭлементОбъект.Записать();
		
		ЭлементСсылка = ЭлементОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ЭлементСсылка;
	
КонецФункции