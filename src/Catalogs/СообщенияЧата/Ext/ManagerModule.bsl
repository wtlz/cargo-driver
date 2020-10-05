﻿Функция СоздатьСообщение(ПараметрыЗапроса) Экспорт

	Ссылка = ОбщегоНазначения.ПолучитьСсылкуПоУИД("СообщенияЧата", ПараметрыЗапроса.Ссылка);

	Если ЗначениеЗаполнено(Ссылка.ВерсияДанных) Тогда
		Возврат Ссылка;
	КонецЕсли;
	
	СправочникОбъект = Справочники.СообщенияЧата.СоздатьЭлемент();
	СправочникОбъект.УстановитьСсылкуНового(Ссылка);
	
	ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыЗапроса);
	
	Если НЕ ЗначениеЗаполнено(СправочникОбъект.Автор) Тогда
		СправочникОбъект.Автор = ОбщегоНазначения.ПолучитьСсылкуПоУИД("Сотрудники", ПараметрыЗапроса.Автор);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СправочникОбъект.ТранспортноеСредство) Тогда
		СправочникОбъект.ТранспортноеСредство = 
			ОбщегоНазначения.ПолучитьСсылкуПоУИД("ТранспортныеСредства", ПараметрыЗапроса.ТранспортноеСредство);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СправочникОбъект.КаналЧата) Тогда
		СправочникОбъект.КаналЧата = Перечисления.РолиСотрудников[ПараметрыЗапроса.КаналЧата];
	КонецЕсли;
	
	СправочникОбъект.Наименование = ПараметрыЗапроса.ТекстСообщения;
	
	Если Не ЗначениеЗаполнено(СправочникОбъект.ДатаСоздания) Тогда
		СправочникОбъект.ДатаСоздания = XMLЗначение(Тип("Дата"), ПараметрыЗапроса.ДатаСоздания);
	КонецЕсли;
	
	СправочникОбъект.ОбменДанными.Загрузка = Истина;
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция ПолучитьНовыеСообщения(ПараметрыЗапроса) Экспорт

	ТранспортноеСредство = ОбщегоНазначения.ПолучитьСсылкуПоУИД("ТранспортныеСредства", ПараметрыЗапроса.ТранспортноеСредство);
	
	МассивНовыхСообщений = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ТранспортноеСредство) Тогда
		Возврат МассивНовыхСообщений;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыСообщенийСрезПоследних.Сообщение КАК Сообщение,
		|	СтатусыСообщенийСрезПоследних.Сообщение.Автор КАК Автор,
		|	СтатусыСообщенийСрезПоследних.Сообщение.ДатаСоздания КАК ДатаСоздания,
		|	СтатусыСообщенийСрезПоследних.Сообщение.ТекстСообщения КАК ТекстСообщения,
		|	СтатусыСообщенийСрезПоследних.Сообщение.КаналЧата КАК КаналЧата,
		|	СтатусыСообщенийСрезПоследних.Сообщение.ТранспортноеСредство КАК ТранспортноеСредство
		|ИЗ
		|	РегистрСведений.СтатусыСообщений.СрезПоследних(, Сообщение.ТранспортноеСредство = &ТранспортноеСредство) КАК СтатусыСообщенийСрезПоследних
		|ГДЕ
		|	СтатусыСообщенийСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСообщений.Отправлено)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСоздания";
	
	Запрос.УстановитьПараметр("ТранспортноеСредство", ТранспортноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл

		СтруктураСообщения = Новый Структура("ДатаСоздания, ТекстСообщения");
		ЗаполнитьЗначенияСвойств(СтруктураСообщения, Выборка);
		
		СтруктураСообщения.Вставить("Автор", 		Строка(Выборка.Автор.УникальныйИдентификатор()));
		СтруктураСообщения.Вставить("Ссылка",		Строка(Выборка.Сообщение.УникальныйИдентификатор()));
		СтруктураСообщения.Вставить("КаналЧата",	XMLСтрока(Выборка.КаналЧата));
		СтруктураСообщения.Вставить("ТранспортноеСредство", Строка(Выборка.ТранспортноеСредство.УникальныйИдентификатор()));
		
		МассивНовыхСообщений.Добавить(СтруктураСообщения);
		
	КонецЦикла;
	
	Возврат МассивНовыхСообщений;
	
КонецФункции // ПолучитьНовыеСообщения()

Функция СообщениеПринято(Телеграм_ИдСообщения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СообщенияЧата.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СообщенияЧата КАК СообщенияЧата
		|ГДЕ
		|	СообщенияЧата.Телеграм_ИдСообщения = &Телеграм_ИдСообщения
		|	И НЕ СообщенияЧата.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Телеграм_ИдСообщения", Телеграм_ИдСообщения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции // СообщениеПринято()
