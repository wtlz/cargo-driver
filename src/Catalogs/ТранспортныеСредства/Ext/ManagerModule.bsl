﻿Процедура ОбновитьИдентификаторУстройства(ПараметрыЗапроса) Экспорт

	ИмяСправочника = "ТранспортныеСредства";
	
	Ссылка = ОбщегоНазначения.ПолучитьСсылкуПоУИД(ИмяСправочника, ПараметрыЗапроса.ТранспортноеСредство);

	Если НЕ ЗначениеЗаполнено(Ссылка.ВерсияДанных) Тогда
		Возврат;
	КонецЕсли;
	
	СправочникОбъект = Ссылка.ПолучитьОбъект();
	
	СправочникОбъект.ИдентификаторУстройства = XMLЗначение(Тип("ХранилищеЗначения"), ПараметрыЗапроса.ИдентификаторУстройства);
	
	СправочникОбъект.ОбменДанными.Загрузка = Истина;
	СправочникОбъект.Записать();

КонецПроцедуры

Функция ПолучитьТранспортноеСредство(ПараметрыЗапроса) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТранспортныеСредства.Ссылка КАК Ссылка,
		|	ТранспортныеСредства.Код КАК Код
		|ИЗ
		|	Справочник.ТранспортныеСредства КАК ТранспортныеСредства
		|ГДЕ
		|	ТранспортныеСредства.Код ПОДОБНО &Код
		|	И НЕ ТранспортныеСредства.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Код", ПараметрыЗапроса.Код);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		Результат = Новый Структура;
		Результат.Вставить("Ссылка",	Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		Результат.Вставить("Код",		Выборка.Код);
		
	    Возврат Результат;
	
	КонецЕсли;

КонецФункции 

Функция СоздатьТранспортноеСредство(Результат) Экспорт
	
	Ссылка = ОбщегоНазначения.ПолучитьСсылкуПоУИД("ТранспортныеСредства", Результат.Получить("Ссылка"));

	Если ЗначениеЗаполнено(Ссылка.ВерсияДанных) Тогда
		Возврат Ссылка;
	КонецЕсли;
	
	СправочникОбъект = Справочники.ТранспортныеСредства.СоздатьЭлемент();
	СправочникОбъект.Код = Результат.Получить("Код");
	
	СправочникОбъект.УстановитьСсылкуНового(Ссылка);
	
	СправочникОбъект.Записать();
	
	Возврат Ссылка;

КонецФункции
