
&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ПарольПользователяСервиса = Пароль;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповеститьОВыборе(ПарольПользователяСервиса);
	
КонецПроцедуры
