////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
#Если ВебКлиент Тогда
	Предупреждение(НСтр("ru = 'В веб-клиенте параметры прокси-сервера необходимо задавать в настройках браузера.'"));
	Возврат;
#КонецЕсли		

	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры
