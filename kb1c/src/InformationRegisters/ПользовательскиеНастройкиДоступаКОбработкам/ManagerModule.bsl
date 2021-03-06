#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Записывает настройки быстрого доступа к обработкам "по пользователям".
//
Процедура ОбновитьДанныеПриЗаписиДополнительногоОбъекта(ДополнительныйОтчетИлиОбработка, БыстрыйДоступ) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДополнительныйОтчетИлиОбработка.Установить(ДополнительныйОтчетИлиОбработка);
	
	Для Каждого СтрокаТаблицы Из БыстрыйДоступ Цикл
		Запись = НаборЗаписей.Добавить();
		Запись.ДополнительныйОтчетИлиОбработка = ДополнительныйОтчетИлиОбработка;
		ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
		Запись.Доступно = Истина;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
КонецПроцедуры


#КонецЕсли