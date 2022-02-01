////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Open Office Writer - специфичные функции
//
// Описание ссылки на печатную форму и макет
// Структура с полями:
// ServiceManager - сервис менеджер, сервис open office
// Desktop - приложение Open Office (сервис UNO)
// Document - документ (печатная форма)
// Тип - тип печатной формы ("ODT")
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ    

// Инициализация печатной формы: создается COM - объект,
// ему устанавливаются свойства.
Функция ИнициализироватьПечатнуюФормуOOWriter(Знач Шаблон = Неопределено) Экспорт
	
	Попытка
		ServiceManager = Новый COMОбъект("com.sun.star.ServiceManager");
	Исключение
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			НСтр("ru = 'Ошибка при связи с сервис менеджером (com.sun.star.ServiceManager).'") + 
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
	Попытка
		Desktop = ServiceManager.CreateInstance("com.sun.star.frame.Desktop");
	Исключение
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			НСтр("ru = 'Ошибка при запуске сервиса Desktop (com.sun.star.frame.Desktop).'") + 
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
	Параметры = ПолучитьComSafeArray();
	
#Если Не ВебКлиент Тогда
	Параметры.SetValue(0, СвойствоЗначение(ServiceManager, "Hidden", Истина));
#КонецЕсли
	
	Document = Desktop.LoadComponentFromURL("private:factory/swriter", "_blank", 0, Параметры);
	
#Если ВебКлиент Тогда
	Document.getCurrentController().getFrame().getContainerWindow().setVisible(Ложь);
#КонецЕсли

    // настраиваем поля по шаблону
	Если Шаблон <> Неопределено Тогда
		TemplateStyleName = Шаблон.Document.CurrentController.getViewCursor().PageStyleName;
		TemplateStyle = Шаблон.Document.StyleFamilies.getByName("PageStyles").getByName(TemplateStyleName);
			
		StyleName = Document.CurrentController.getViewCursor().PageStyleName;
		Style = Document.StyleFamilies.getByName("PageStyles").getByName(StyleName);
		
		Style.TopMargin = TemplateStyle.TopMargin;
		Style.LeftMargin = TemplateStyle.LeftMargin;
		Style.RightMargin = TemplateStyle.RightMargin;
		Style.BottomMargin = TemplateStyle.BottomMargin;
	КонецЕсли;

	// Подготавливаем ссылку на макет
	Handler = Новый Структура("ServiceManager,Desktop,Document,Тип");
	Handler.ServiceManager = ServiceManager;
	Handler.Desktop = Desktop;
	Handler.Document = Document;
	
	Возврат Handler;
	
КонецФункции

// Возвращает структуру с макетом печатной формы
//
// Параметры:
// ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета
// Возвращаемое значение:
// структура - ссылка макет
//
Функция ПолучитьМакетOOWriter(знач ДвоичныеДанныеШаблона, ИмяВременногоФайла) Экспорт
	
	Handler = Новый Структура("ServiceManager,Desktop,Document,ИмяФайла");
	
	Попытка
		ServiceManager = Новый COMОбъект("com.sun.star.ServiceManager");
	Исключение
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			НСтр("ru = 'Ошибка при связи с сервис менеджером (com.sun.star.ServiceManager).'") + 
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
	Попытка
		Desktop = ServiceManager.CreateInstance("com.sun.star.frame.Desktop");
	Исключение
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			НСтр("ru = 'Ошибка при запуске сервиса Desktop (com.sun.star.frame.Desktop).'") + 
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
		НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке());
	КонецПопытки;
	
#Если НЕ ВебКлиент Тогда
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("ODT");
	ДвоичныеДанныеШаблона.Записать(ИмяВременногоФайла);
#КонецЕсли
	
	Параметры = ПолучитьComSafeArray();
#Если Не ВебКлиент Тогда
	Параметры.SetValue(0, СвойствоЗначение(ServiceManager, "Hidden", Истина));
#КонецЕсли
	
	Document = Desktop.LoadComponentFromURL("file:///" + ИмяВременногоФайла, "_blank", 0, Параметры);
	
#Если ВебКлиент Тогда
	Document.getCurrentController().getFrame().getContainerWindow().setVisible(Ложь);
#КонецЕсли
	
	// Подготавливаем ссылку на макет
	Handler.ServiceManager = ServiceManager;
	Handler.Desktop = Desktop;
	Handler.Document = Document;
	Handler.ИмяФайла = ИмяВременногоФайла;
	
	Возврат Handler;
	
КонецФункции

// Закрывает макет печатной формы и затирает ссылки на COM объект
//
Функция ЗакрытьСоединение(Handler, знач ЗакрытьПриложение) Экспорт
	
	Если ЗакрытьПриложение Тогда
		Handler.Document.Close(0);
	КонецЕсли;
	
	Handler.Document = Неопределено;
	Handler.Desktop = Неопределено;
	Handler.ServiceManager = Неопределено;
	ScriptControl = Неопределено;
	
	Если Handler.Свойство("ИмяФайла") Тогда
		УдалитьФайлы(Handler.ИмяФайла);
	КонецЕсли;
	
	Handler = Неопределено;
	
КонецФункции

// Устанавливает свойство видимости у приложения OO Writer
// Handler - ссылка на печатную форму
//
Процедура ПоказатьДокументOOWriter(знач Handler) Экспорт
	
	ContainerWindow = Handler.Document.getCurrentController().getFrame().getContainerWindow();
	ContainerWindow.setVisible(Истина);
	ContainerWindow.setFocus();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с макетом

// Получает область из макета.
// Параметры
// Handler - ссылка на макет
// ИмяОбласти - имя области в макете
// СмещениеНачало - смещение относительно начала области
//					смещение по умолчанию: 1 - означает что область берется без символа
//					перевода строки, за операторной скобкой открытия области
// СмещениеОкончание - смещение относительно окончания области,
//					смещение по умолчанию: -11 - означает что область берется без символа
//					перевода строки, перед операторной скобкой закрытия области
//
Функция ПолучитьОбластьМакета(знач Handler, знач ИмяОбласти) Экспорт
	
	Результат = Новый Структура("Document,Start,End");
	
	Результат.Start = ПолучитьПозициюНачалаОбласти(Handler.Document, ИмяОбласти);
	Результат.End   = ПолучитьПозициюОкончанияОбласти(Handler.Document, ИмяОбласти);
	Результат.Document = Handler.Document;
	
	Возврат Результат;
	
КонецФункции

// Получает область верхнего колонтитула
//
Функция ПолучитьОбластьВерхнегоКолонтитула(знач МакетСсылка) Экспорт
	
	Возврат Новый Структура("Document, ServiceManager", МакетСсылка.Document, МакетСсылка.ServiceManager);
	
КонецФункции

// Получает область нижнего колонтитула
//
Функция ПолучитьОбластьНижнегоКолонтитула(МакетСсылка) Экспорт
	
	Возврат Новый Структура("Document, ServiceManager", МакетСсылка.Document, МакетСсылка.ServiceManager);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с печатной формой

// Вставляет разрыв на следующую строку
// Параметры
// Handler - ссылка на документ MS Word в который требуется вставить разрыв
//
Процедура ВставитьРазрывНаНовуюСтроку(знач Handler) Экспорт
	
	oText = Handler.Document.getText();
	oCursor = oText.createTextCursor();
	oCursor.gotoEnd(False);
	oText.insertControlCharacter(oCursor, 0, False);
	
КонецПроцедуры

// Добавляет верхний колонтитул к печатной форме
//
Процедура ДобавитьВерхнийКолонтитул(знач ПечатнаяФорма,
									знач Область) Экспорт
	
	Макет_oTxtCrsr = УстановитьОсновнойКурсорНаВерхнийКолонтитул(Область);
	Пока Макет_oTxtCrsr.goRight(1, Истина) Цикл
	КонецЦикла;
	TransferableObject = Область.Document.getCurrentController().Frame.controller.getTransferable();
	
	УстановитьОсновнойКурсорНаВерхнийКолонтитул(ПечатнаяФорма);
	ПечатнаяФорма.Document.getCurrentController().insertTransferable(TransferableObject);
	
КонецПроцедуры

// Добавляет нижний колонтитул к печатной форме
//
Процедура ДобавитьНижнийКолонтитул(знач ПечатнаяФорма,
									знач Область) Экспорт
	
	Макет_oTxtCrsr = УстановитьОсновнойКурсорНаНижнийКолонтитул(Область);
	Пока Макет_oTxtCrsr.goRight(1, Истина) Цикл
	КонецЦикла;
	TransferableObject = Область.Document.getCurrentController().Frame.controller.getTransferable();
	
	УстановитьОсновнойКурсорНаНижнийКолонтитул(ПечатнаяФорма);
	ПечатнаяФорма.Document.getCurrentController().insertTransferable(TransferableObject);
	
КонецПроцедуры

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры
// ПечатнаяФорма - ссылка на печатную форму
// ОбластьHandler - ссылка на область в макете.
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
// Возвращаемое значение:
// КоординатыОбласти
//
Процедура ПрисоединитьОбласть(знач ПечатнаяФормаHandler,
							знач ОбластьHandler,
							знач ПереходНаСледСтроку = Истина,
							знач ПрисоединитьСтрокуТаблицы = Ложь) Экспорт
	
	Макет_oTxtCrsr = ОбластьHandler.Document.getCurrentController().getViewCursor();
	Макет_oTxtCrsr.gotoRange(ОбластьHandler.Start, Ложь);
	
	Если НЕ ПрисоединитьСтрокуТаблицы Тогда
		Макет_oTxtCrsr.goRight(1, Ложь);
	КонецЕсли;
	
	Макет_oTxtCrsr.gotoRange(ОбластьHandler.End, Истина);
	
	TransferableObject = ОбластьHandler.Document.getCurrentController().Frame.controller.getTransferable();
	ПечатнаяФормаHandler.Document.getCurrentController().insertTransferable(TransferableObject);
	
	Если ПрисоединитьСтрокуТаблицы Тогда
		УдалитьСтроку(ПечатнаяФормаHandler);
	КонецЕсли;
	
	Если ПереходНаСледСтроку Тогда
		ВставитьРазрывНаНовуюСтроку(ПечатнаяФормаHandler);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет параметры в табличном поле печатной формы
//
Процедура ЗаполнитьПараметры(ПечатнаяФорма, Данные) Экспорт
	
	Для Каждого КлючЗначение Из Данные Цикл
		Если ТипЗнч(КлючЗначение) <> Тип("Массив") Тогда
			ПФ_oDoc = ПечатнаяФорма.Document;
			ПФ_ReplaceDescriptor = ПФ_oDoc.createReplaceDescriptor();
			ПФ_ReplaceDescriptor.SearchString = "{v8 " + КлючЗначение.Ключ + "}";
			ПФ_ReplaceDescriptor.ReplaceString = Строка(КлючЗначение.Значение);
			ПФ_oDoc.replaceAll(ПФ_ReplaceDescriptor);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет область коллекции к печатной форме
//
Процедура ПрисоединитьИЗаполнитьКоллекцию(знач ПечатнаяФормаHandler,
										  знач ОбластьHandler,
										  знач Данные,
										  знач ЭтоСтрокаТаблицы = Ложь,
										  знач ПереходНаСледСтроку = Истина) Экспорт
	
	Макет_oTxtCrsr = ОбластьHandler.Document.getCurrentController().getViewCursor();
	Макет_oTxtCrsr.gotoRange(ОбластьHandler.Start, Ложь);
	
	Если НЕ ЭтоСтрокаТаблицы Тогда
		Макет_oTxtCrsr.goRight(1, Ложь);
	КонецЕсли;
	Макет_oTxtCrsr.gotoRange(ОбластьHandler.End, Истина);
	
	TransferableObject = ОбластьHandler.Document.getCurrentController().Frame.controller.getTransferable();
	
	Для Каждого СтрокаСДанными Из Данные Цикл
		ПечатнаяФормаHandler.Document.getCurrentController().insertTransferable(TransferableObject);
		Если ЭтоСтрокаТаблицы Тогда
			УдалитьСтроку(ПечатнаяФормаHandler);
		КонецЕсли;
		ЗаполнитьПараметры(ПечатнаяФормаHandler, СтрокаСДанными);
	КонецЦикла;
	
	Если ПереходНаСледСтроку Тогда
		ВставитьРазрывНаНовуюСтроку(ПечатнаяФормаHandler);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает курсор в конец документа ДокументСсылка
//
Процедура УстановитьОсновнойКурсорНаТелоДокумента(знач ДокументСсылка) Экспорт
	
	oDoc = ДокументСсылка.Document;
	oViewCursor = oDoc.getCurrentController().getViewCursor();
	oTextCursor = oDoc.Text.createTextCursor();
	oViewCursor.gotoRange(oTextCursor, Ложь);
	oViewCursor.gotoEnd(Ложь);
	
КонецПроцедуры

// Устанавливает курсор на верхний колонтитул
//
Функция УстановитьОсновнойКурсорНаВерхнийКолонтитул(знач ДокументСсылка) Экспорт
	
	xCursor = ДокументСсылка.Document.getCurrentController().getViewCursor();
	PageStyleName = xCursor.getPropertyValue("PageStyleName");
	oPStyle = ДокументСсылка.Document.getStyleFamilies().getByName("PageStyles").getByName(PageStyleName);
	oPStyle.HeaderIsOn = Истина;
	HeaderTextCursor = oPStyle.getPropertyValue("HeaderText").createTextCursor();
	xCursor.gotoRange(HeaderTextCursor, Ложь);
	Возврат xCursor;
	
КонецФункции

// Устанавливает курсор на нижний колонтитул
//
Функция УстановитьОсновнойКурсорНаНижнийКолонтитул(знач ДокументСсылка) Экспорт
	
	xCursor = ДокументСсылка.Document.getCurrentController().getViewCursor();
	PageStyleName = xCursor.getPropertyValue("PageStyleName");
	oPStyle = ДокументСсылка.Document.getStyleFamilies().getByName("PageStyles").getByName(PageStyleName);
	oPStyle.FooterIsOn = Истина;
	FooterTextCursor = oPStyle.getPropertyValue("FooterText").createTextCursor();
	xCursor.gotoRange(FooterTextCursor, Ложь);
	Возврат xCursor;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

// Получает специальную структуру, через которую объектам UNO устанавливаются
// параметры.
//
Функция СвойствоЗначение(знач ServiceManager, знач Свойство, знач Значение)
	
	PropertyValue = ServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue");
	PropertyValue.Name = Свойство;
	PropertyValue.Value = Значение;
	
	Возврат PropertyValue;
	
КонецФункции

Функция ПолучитьПозициюНачалаОбласти(знач xDocument, знач ИмяОбласти)
	
	ТекстДляПоиска = "{v8 Область." + ИмяОбласти + "}";
	
	xSearchDescr = xDocument.createSearchDescriptor();
	xSearchDescr.SearchString = ТекстДляПоиска;
	xSearchDescr.SearchCaseSensitive = Ложь;
	xSearchDescr.SearchWords = Истина;
	xFound = xDocument.findFirst(xSearchDescr);
	Если xFound = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не найдено начало области макета:'") + " " + ИмяОбласти;	
	КонецЕсли;
	Возврат xFound.End;
	
КонецФункции

Функция ПолучитьПозициюОкончанияОбласти(знач xDocument, знач ИмяОбласти)
	
	ТекстДляПоиска = "{/v8 Область." + ИмяОбласти + "}";
	
	xSearchDescr = xDocument.createSearchDescriptor();
	xSearchDescr.SearchString = ТекстДляПоиска;
	xSearchDescr.SearchCaseSensitive = Ложь;
	xSearchDescr.SearchWords = Истина;
	xFound = xDocument.findFirst(xSearchDescr);
	Если xFound = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не найден конец области макета:'") + " " + ИмяОбласти;	
	КонецЕсли;
	Возврат xFound.Start;
	
КонецФункции

Процедура УдалитьСтроку(ПечатнаяФормаHandler)
	
	oFrame = ПечатнаяФормаHandler.Document.getCurrentController().Frame;
	
	dispatcher = ПечатнаяФормаHandler.ServiceManager.CreateInstance ("com.sun.star.frame.DispatchHelper");
	
	oViewCursor = ПечатнаяФормаHandler.Document.getCurrentController().getViewCursor();
	
	dispatcher.executeDispatch(oFrame, ".uno:GoUp", "", 0, ПолучитьComSafeArray());
	
	Пока oViewCursor.TextTable <> Неопределено Цикл
		dispatcher.executeDispatch(oFrame, ".uno:GoUp", "", 0, ПолучитьComSafeArray());
	КонецЦикла;
	
	dispatcher.executeDispatch(oFrame, ".uno:Delete", "", 0, ПолучитьComSafeArray());
	
	Пока oViewCursor.TextTable <> Неопределено Цикл
		dispatcher.executeDispatch(oFrame, ".uno:GoDown", "", 0, ПолучитьComSafeArray());
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьComSafeArray()
	
#Если ВебКлиент Тогда
	scr = Новый COMОбъект("MSScriptControl.ScriptControl");
	scr.language = "javascript";
	scr.eval("Массив=new Array()");
	Возврат scr.eval("Массив");
#Иначе
	Возврат Новый COMSafeArray("VT_DISPATCH", 1);
#КонецЕсли
	
КонецФункции

Функция СобытиеЖурналаРегистрации()
	Возврат НСтр("ru = 'Печать'");
КонецФункции

Процедура НеУдалосьСформироватьПечатнуюФорму(ИнформацияОбОшибке)
#Если ВебКлиент Тогда
	ТекстУточнения = НСтр("ru = 'При работе через веб, требуется браузер Internet Explorer под управлением операционной системы Windows.'");
#Иначе		
	ТекстУточнения = "";	
#КонецЕсли
	ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось сформировать печатную форму: %1. 
			|Для вывода печатных форм в формате OpenOffice.org Writer требуется, чтобы на компьютере был установлен пакет OpenOffice.org. %2'"),
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке), ТекстУточнения);
	ВызватьИсключение ТекстИсключения;
КонецПроцедуры