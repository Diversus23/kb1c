////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьВсеТиповыеПравила(Команда)
	
	ОбновитьВсеТиповыеПравилаНаСервере();
	
	Предупреждение(НСтр("ru = 'Обновление правил успешно завершено.'"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьВсеТиповыеПравилаНаСервере()
	
	ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры
