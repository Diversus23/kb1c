
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ЗадачиПоБизнесПроцессу",
		Новый Структура("ЗначениеОтбора", ПараметрКоманды),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Источник.КлючУникальности,
			ПараметрыВыполненияКоманды.Окно);	
КонецПроцедуры
