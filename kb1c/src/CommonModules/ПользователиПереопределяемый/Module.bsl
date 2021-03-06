////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Переопределяет стандартный способ установки ролей пользователям ИБ.
//
// Параметры:
//  Запрет - Булево. Если установить Истина, изменение ролей
//           блокируется (в том числе для администратора).
//
Процедура ИзменитьЗапретРедактированияРолей(Запрет) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей.
//
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи,
//           СправочникСсылка.ВнешниеПользователи,
//           СправочникСсылка.ГруппыВнешнихПользователей
//           ссылка на пользователя, внешнего пользователя или группу внешних пользователей
//           при создании формы.
//
//  ДействияВФорме - Структура (со свойствами типа Строка):
//           Роли                   = "", "Просмотр",     "Редактирование"
//           КонтактнаяИнформация   = "", "Просмотр",     "Редактирование"
//           СвойстваПользователяИБ = "", "ПросмотрВсех", "РедактированиеВсех", РедактированиеСвоих"
//           СвойстваЭлемента       = "", "Просмотр",     "Редактирование"
//           
//           Для групп внешних пользователей КонтактнаяИнформация и СвойстваПользователяИБ не существуют.
//
Процедура ИзменитьДействияВФорме(Знач Ссылка, Знач ДействияВФорме) Экспорт
	
	
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
//  Вызывается из процедуры ЗаписатьПользователяИБ(), если пользователь был действительно изменен.
//
// Параметры:
//  СтарыеСвойства - Структура, см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ()
//  НовыеСвойства  - Структура, см. параметры возвращаемые функцией Пользователи.ЗаписатьПользователяИБ()
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
	
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
//  Вызывается из процедуры УдалитьПользователяИБ(), если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура, см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ()
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей
//
// Параметры:
//  НастройкиКлиента - НастройкиКлиентскогоПриложения,
//  НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса.
//
Процедура ПриУстановкеНачальныхНастроек(НастройкиКлиента, НастройкиИнтерфейса) Экспорт
	
	
	
КонецПроцедуры
