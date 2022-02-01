
#Область УниверсальныеСтруктуры

// Возвращает универсальную структуру User
//
// Возвращаемое значение
//	Структура
//		id - Строка. Уникальный идентификатор
//		name - Строка. Представление пользователя
//		login - Строка. Имя пользователя ИБ
//
Функция ПолучитьСтруктуру_user()
	
	Возврат Новый Структура("id, name, login",
		"",
		"",
		"");
	
КонецФункции

// Возвращает универсальную структуру Category
//
// Возвращаемое значение
//	Структура
//		id - Строка. Уникальный идентификатор
//		descr - Строка. Наименование категории
//		text - Строка. Описание категории
//		statistics - Структура
//			articles - Число. Количество подчиненных статей
//			categories - Число. Количество подчиненных категорий
//		
Функция ПолучитьСтруктуру_category()
	
	Возврат Новый Структура("id, descr, text, statistics",
		"",
		"",
		"",
		Новый Структура("articles, categories",
			0,
			0));
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеУниверсальныхСтруктур

Процедура ЗаполнитьСтруктуру_user(Структура, ПользовательСсылка)
	
	ТипПараметрПользователь = ТипЗнч(ПользовательСсылка);
	Если ТипПараметрПользователь = Тип("СправочникСсылка.Пользователи")
		ИЛИ ТипПараметрПользователь = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПользовательСсылка, "Ссылка, Наименование, ИдентификаторПользователяИБ");
	Иначе
		Реквизиты = ПользовательСсылка;
	КонецЕсли;
	
	Структура.id	= Строка(Реквизиты.Ссылка.УникальныйИдентификатор());
	Структура.name	= СокрЛП(Реквизиты.Наименование);
	Структура.login	= СокрЛП(Реквизиты.ИдентификаторПользователяИБ);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуру_category(Структура, КатегорияСсылка)
	
	//Если ТипЗнч(КатегорияСсылка) = Тип("СправочникСсылка.КатегорииБазыЗнаний") Тогда
	//	
	//	
	//	
	//Иначе 
	//	Реквизиты = КатегорияСсылка;
	//КонецЕсли;
	//
	//Структура.id	= Строка(ПользовательСсылка.УникальныйИдентификатор());
	//Структура.descr	= СокрЛП(Реквизиты.Наименование);
	//Структура.text	= СокрЛП(Реквизиты.ИдентификаторПользователяИБ);
	//Структура.articles
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеСессиями

// Возвращает список пользователей для отображения в целях
// авторизации в базе знаний
//
// Параметры
//	отсутствуют
//
// Возвращаемое значение
//	result - Число.
//		0 - пользователи не найдены
//		1 - пользователи найдены
//	users - Массив
//		см. структуру User
//
Функция GetUsers()
	
	ИсходящийПакет = Новый Структура("result, users", 0, Новый Массив);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВнешниеПользователи.Ссылка,
	|	ВнешниеПользователи.Наименование,
	|	ВнешниеПользователи.ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	НЕ ВнешниеПользователи.Недействителен
	|	И НЕ ВнешниеПользователи.ПометкаУдаления
	|	И ВнешниеПользователи.ИдентификаторПользователяИБ <> """"";
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ИсходящийПакет.result = 1;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДанныеUser = ПолучитьСтруктуру_user();
			ЗаполнитьСтруктуру_user(ДанныеUser, Выборка);
			
			ИсходящийПакет.users.Добавить(ДанныеUser);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПарсерСериализаторJSON.ЗаписатьJSON(ИсходящийПакет);
	
КонецФункции

// Открывает сессию пользователя, если время окончания сессии задано
// она автоматически закрывается через указанный промежуток времени
//
// Параметры
//	timeout - время ограничения сессии в минутах
//
// Возвращаемое значение
//	result - Число.
//		0 - сессия не открыта
//		1 - сессия открыта
//	token - Строка .Уникальный идентификатор сессии
//	user - Структура. см. структуру User
//
Функция StartSession(timeout)
	
	ИсходящийПакет = Новый Структура("result, token, user", 0, "", ПолучитьСтруктуру_user());
	
	ТекПользователь = Пользователи.АвторизованныйПользователь();
	КлючСессии		= БазаЗнаний.НачатьСессиюПользователя(ТекПользователь);
	
	Если БазаЗнаний.ПроверитьСтатусСессии(КлючСессии) = Истина Тогда
		ИсходящийПакет.result	= 1;
		ИсходящийПакет.token	= Строка(КлючСессии);
		ЗаполнитьСтруктуру_user(ИсходящийПакет.user, ТекПользователь);
	КонецЕсли;	
		
	Возврат ПарсерСериализаторJSON.ЗаписатьJSON(ИсходящийПакет);
	
КонецФункции

// Закрывает сессию пользователя
//
// Параметры
//	token - Строка. Уникальный идентификатор сессии открытой ранее
//
// Возвращаемое значение
//	result - Число.
//		0 - сессия не закрыта
//		1 - сессия закрыта
//
Функция EndSession(token)
	
	ИсходящийПакет = Новый Структура("result", 0);
	
	ЭтоИдентификатор = СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(token);
	Если ЭтоИдентификатор Тогда
		КлючСессии = Новый УникальныйИдентификатор(token);
		БазаЗнаний.ЗавершитьСессииПользователя(КлючСессии);
		
		СессияЗакрыта = (БазаЗнаний.ПроверитьСтатусСессии(КлючСессии) = Ложь);
		
		Если СессияЗакрыта Тогда
			ИсходящийПакет.result = 1;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПарсерСериализаторJSON.ЗаписатьJSON(ИсходящийПакет);
	
КонецФункции

#КонецОбласти

#Область УправлениеКатегориями

// Возвращает массив категорий по заданному родителю
//
// Параметры
//
// Возвращаемое значение
//
Функция GetCategories(parent, nameFilter, sortKey)
	
	ИсходящийПакет = Новый Структура("result, categories, count", 0, Новый Массив, 0, 1, "");
	
	pageNum = ?(pageNum = 0, 1, pageNum);
	
	ЭтоИдентификатор = СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(parent);
	Если ЭтоИдентификатор Тогда
		ИдентификаторРодитель = Новый УникальныйИдентификатор(parent);
		РодительСсылка = Справочники.КатегорииБазыЗнаний.ПолучитьСсылку(ИдентификаторРодитель);
	Иначе 
		РодительСсылка = Справочники.КатегорииБазыЗнаний.ПустаяСсылка();
	КонецЕсли;
	
	НастройкаОтбора = Новый Массив;
	НастройкаОтбора.Добавить(Новый Структура("Поле, ВидСравнения, Значение", "Родитель", ВидСравнения.Равно, РодительСсылка));
	Если НЕ ПустаяСтрока(nameFilter) Тогда
		НастройкаОтбора.Добавить(Новый Структура("Поле, ВидСравнения, Значение", "Наименование", ВидСравнения.Содержит, nameFilter));
	КонецЕсли;
	
	КлючиСортировки = Новый Соответствие;
	КлючиСортировки.Вставить("code", "РеквизитДопУпорядочивания");
	КлючиСортировки.Вставить("descr", "Наименование");
	
	ПолеСортировки	= КлючиСортировки.Получить(sortKey);
	Если НЕ ЗначениеЗаполнено(ПолеСортировки) Тогда
		ПолеСортировки = "РеквизитДопУпорядочивания";
	КонецЕсли;
	
	НастройкаПорядка = Новый Массив;
	НастройкаПорядка.Добавить(Новый Структура("Поле, Направление", ПолеСортировки, НаправлениеСортировки.Возр));
	
	ТаблицаКатегории = БазаЗнаний.ПолучитьКатегории(НастройкаОтбора, НастройкаПорядка);
	Для Каждого СтрокаТаблицы Из ТаблицаКатегории Цикл
		
		ДанныеКатегории = ПолучитьСтруктуру_category();
		ДанныеКатегории.id		= Строка(СтрокаТаблицы.Ссылка.УникальныйИдентификатор());
		ДанныеКатегории.descr	= СокрЛП(СтрокаТаблицы.Наименование);
		ДанныеКатегории.text	= СокрЛП(СтрокаТаблицы.Описание);
		ДанныеКатегории.statistics.articles		= СтрокаТаблицы.КоличествоСтатей;
		ДанныеКатегории.statistics.categories	= СтрокаТаблицы.КоличествоКатегорий;
		
		ИсходящийПакет.categories.Добавить(ДанныеКатегории);
		
	КонецЦикла;
	
	ИсходящийПакет.result	= 1;
	ИсходящийПакет.count	= ТаблицаКатегории.Количество();
	
	Возврат ПарсерСериализаторJSON.ЗаписатьJSON(ИсходящийПакет);
	
КонецФункции

#КонецОбласти





//// 0 - запрос выполнен, 1 - ошибка формата, 2 - родитель отсутствует, 3 - нет страницы
//Функция ПолучитьКатегории(token, format, parent, nameFilter, limit, pageNumber, sortKey)
//	
//	ВыходныеДанные = Новый Структура("result, format, categories, count, page", 0, "json", Новый Массив, 0, 0);
//	
//	// Обработка параметров
//	format		= НРег(format);
//	pageNumber	= ?(pageNumber = 0, 1, pageNumber);
//	
//	// Проверка ключа сессии
//	КлючСессии		= Новый УникальныйИдентификатор(token);
//	СтатусСессии	= БазаЗнаний.ПроверитьСтатусСессии(КлючСессии);
//	Если СтатусСессии = Неопределено Тогда
//		ВыходныеДанные.Вставить("result", 102);
//	ИначеЕсли НЕ СтатусСессии Тогда
//		ВыходныеДанные.Вставить("result", 101);
//	КонецЕсли;
//	
//	Если ПроверитьКодыОшибок(ВыходныеДанные.result) Тогда
//		Возврат ПреобразоватьДанныеПоФормату(ВыходныеДанные, format);
//	КонецЕсли;
//	
//	Если НЕ ПроверитьФорматДанных(format) Тогда
//		ВыходныеДанные.result = 1;
//		Возврат ПреобразоватьДанныеПоФормату(ВыходныеДанные, format);
//	КонецЕсли;
//	
//	Если ЗначениеЗаполнено(parent) Тогда
//		ИДРодителя		= Новый УникальныйИдентификатор(parent);
//		РодительСсылка	= Справочники.КатегорииБазыЗнаний.ПолучитьСсылку(ИДРодителя);
//		
//		Если РодительСсылка.ПолучитьОбъект() = Неопределено Тогда
//			ВыходныеДанные.result = 2;
//			Возврат ПреобразоватьДанныеПоФормату(ВыходныеДанные, format);
//		КонецЕсли;
//	Иначе 
//		РодительСсылка	= Справочники.КатегорииБазыЗнаний.ПустаяСсылка();
//	КонецЕсли;
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Родитель", РодительСсылка);
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	Категории.Ссылка,
//	|	Категории.Наименование,
//	|	Категории.Описание
//	|ИЗ
//	|	Справочник.КатегорииБазыЗнаний КАК Категории
//	|ГДЕ
//	|	Категории.Тип = 0
//	|	И НЕ Категории.ПометкаУдаления
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Категории.РеквизитДопУпорядочивания";
//	
//	// Если указано количество категорий, тогда выберем только необходимое количество статей
//	Если limit > 0 Тогда
//		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВЫБРАТЬ", "ВЫБРАТЬ ПЕРВЫЕ " + Формат(limit * pageNumber, "ЧГ="));
//	КонецЕсли;
//	
//	// Установим признак сортировки, если по наименованию
//	Если НРег(sortKey) = "descr" Тогда
//		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УПОРЯДОЧИТЬ ПО
//		|	Категории.РеквизитДопУпорядочивания", "УПОРЯДОЧИТЬ ПО
//		|	Категории.Наименование");
//	КонецЕсли;
// 	
//	// Установим отбор по наименованию
//	Если ЗначениеЗаполнено(nameFilter) Тогда
//		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И НЕ Категории.ПометкаУдаления", "И НЕ Категории.ПометкаУдаления
//		|	И Категории.Наименование ПОДОБНО '%" + СокрЛП(nameFilter) + "%'");
//	КонецЕсли;
//	
//	Результат = Запрос.Выполнить();
//	Если Результат.Пустой() Тогда
//		ВыходныеДанные.result = 3;
//	Иначе 
//		ТаблицаКатегорий = Результат.Выгрузить();
//		
//		Если limit > 0 Тогда
//			ПерваяСтрока = limit * (pageNumber - 1) + 1;
//		Иначе 
//			ПерваяСтрока = 1;
//		КонецЕсли;
//		
//		МассивКатегорий		= Новый Массив;
//		ОграничениеСтрок	= ТаблицаКатегорий.Количество() - 1;
//		Для ИндексСтроки = ПерваяСтрока - 1 По ОграничениеСтрок Цикл
//			СтрокаТаблицы = ТаблицаКатегорий[ИндексСтроки];
//			
//			СтруктураКатегории = Новый Структура;
//			СтруктураКатегории.Вставить("id"	, Строка(СтрокаТаблицы.Ссылка.УникальныйИдентификатор()));
//			СтруктураКатегории.Вставить("descr"	, СокрЛП(СтрокаТаблицы.Наименование));
//			СтруктураКатегории.Вставить("text"	, СокрЛП(СтрокаТаблицы.Описание));
//			
//			МассивКатегорий.Добавить(СтруктураКатегории);
//		КонецЦикла;
//		
//		ВыходныеДанные.result 		= 0;
//		ВыходныеДанные.format		= format;
//		ВыходныеДанные.count		= (ОграничениеСтрок - ПерваяСтрока - 1);
//		ВыходныеДанные.page			= pageNumber;
//		ВыходныеДанные.categories	= МассивКатегорий;
//	КонецЕсли;
//	
//	Возврат ПреобразоватьДанныеПоФормату(ВыходныеДанные, format);
//	
//КонецФункции