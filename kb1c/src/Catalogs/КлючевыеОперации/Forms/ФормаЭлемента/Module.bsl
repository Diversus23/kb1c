
///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.КлючевыеОперации.ОбщаяПроизводительностьСистемы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


