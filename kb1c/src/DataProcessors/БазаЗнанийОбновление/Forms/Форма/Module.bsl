
// 1.3.1.0

&НаКлиенте
Процедура Версия_1_3_1_0(Команда)
	ОбновитьНаСервере_Версия_1_3_1_0();
	
	// Удалим каталог пользователя с картинками
	Попытка
		УдалитьФайлы(КаталогВременныхФайлов() + "kb_1c_ptb");
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьНаСервере_Версия_1_3_1_0()
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Началось обновления на версию 1.3.1.0");
	ОбновлениеИнформационнойБазыБазаЗнаний.ПерейтиНаВерсию_1_3_1_0();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обновление на версию 1.3.1.0 завершено");
	
КонецПроцедуры

// 1.1.1.0

&НаКлиенте
Процедура Версия_1_1_1_0(Команда)
	ОбновитьНаСервере_Версия_1_1_1_0();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьНаСервере_Версия_1_1_1_0()
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Началось обновления на версию 1.1.1.0");
	ОбновлениеИнформационнойБазыБазаЗнаний.ПерейтиНаВерсию_1_1_1_0();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обновление на версию 1.1.1.0 завершено");
	
КонецПроцедуры
