#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Получатель = Отбор["Получатель"].Значение;
	
	Если Получатель <> Неопределено
		И Получатель = ОбменСообщениямиВнутренний.ЭтотУзел() Тогда
		
		Получатели = ОбменСообщениямиВнутренний.ВсеПолучатели();
		
		ОбменДанными.Получатели.Очистить();
		
		Для Каждого Узел Из Получатели Цикл
			
			ОбменДанными.Получатели.Добавить(Узел);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли