////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(УзелИнформационнойБазы, ПараметрыВыполненияКоманды)
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанных(УзелИнформационнойБазы, ПараметрыВыполненияКоманды, "ВыгрузкаДанных");
	
КонецПроцедуры
